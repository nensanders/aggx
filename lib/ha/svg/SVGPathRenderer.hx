package lib.ha.svg;
import lib.ha.svg.SVGPathBounds;
import lib.ha.aggx.color.GradientXY;
import lib.ha.aggx.color.GradientY;
import lib.ha.core.math.Calc;
import lib.ha.aggx.renderer.ScanlineRenderer;
import lib.ha.aggx.color.SpanGradient;
import lib.ha.aggxtest.AATest.ColorArray;
import lib.ha.aggx.color.SpanAllocator;
import lib.ha.aggx.color.SpanInterpolatorLinear;
import lib.ha.aggx.color.GradientX;
import lib.ha.aggx.vectorial.PathUtils;
import lib.ha.aggx.vectorial.PathCommands;
import lib.ha.aggx.vectorial.CubicCurve;
import lib.ha.aggx.vectorial.converters.ConvSegmentator;
import lib.ha.aggx.vectorial.converters.ConvContour;
import lib.ha.aggx.vectorial.QuadCurve;
import lib.ha.aggx.renderer.ClippingRenderer;
import lib.ha.aggx.vectorial.InnerJoin;
import lib.ha.aggx.renderer.SolidScanlineRenderer;
import lib.ha.aggx.rasterizer.FillingRule;
import lib.ha.aggx.renderer.IRenderer;
import lib.ha.aggx.rasterizer.IScanline;
import lib.ha.aggx.rasterizer.ScanlineRasterizer;
import lib.ha.aggx.vectorial.PathFlags;
import lib.ha.aggx.vectorial.converters.ConvTransform;
import lib.ha.aggx.vectorial.converters.ConvStroke;
import lib.ha.aggx.vectorial.VectorPath;
import lib.ha.aggx.vectorial.converters.ConvCurve;
import lib.ha.core.memory.Ref.FloatRef;
import lib.ha.core.memory.Ref.Ref;
import lib.ha.aggx.vectorial.IVertexSource;
import haxe.ds.Vector;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.aggx.vectorial.LineJoin;
import lib.ha.aggx.vectorial.LineCap;
import lib.ha.aggx.color.RgbaColor;

class PathAttributes
{
    public var index: UInt;
    public var fill_color: RgbaColor;
    public var stroke_color: RgbaColor;
    public var fill_flag: Bool;
    public var stroke_flag: Bool;
    public var even_odd_flag: Bool;
    public var line_join: Int; // ENUM CLASS
    public var line_cap: Int; // ENUM CLASS
    public var miter_limit: Float;
    public var stroke_width: Float;
    public var transform: AffineTransformer;
    public var id: String;
    public var gradientId: String;
    public var bounds: SVGPathBounds = new SVGPathBounds();

    private function new ()
    {
        index = 0;
        fill_color = new RgbaColor();
        stroke_color = new RgbaColor();
        fill_flag = true;
        stroke_flag = false;
        even_odd_flag = false;
        line_join = LineJoin.MITER;
        line_cap = LineCap.BUTT;
        miter_limit = 1.0;
        stroke_width = 1.0;
        transform = new AffineTransformer();
    }

    static public function create(): PathAttributes
    {
        return new PathAttributes();
    }

    static public function copy(attr: PathAttributes, ?idx: UInt): PathAttributes
    {
        var result: PathAttributes = new PathAttributes();
        result.index = idx != null ? idx : attr.index;
        result.fill_color.set(attr.fill_color);
        result.stroke_color.set(attr.stroke_color);
        result.fill_flag = attr.fill_flag;
        result.stroke_flag = attr.stroke_flag;
        result.even_odd_flag = attr.even_odd_flag;
        result.line_join = attr.line_join;
        result.line_cap = attr.line_cap;
        result.miter_limit = attr.miter_limit;
        result.stroke_width = attr.stroke_width;
        result.bounds = SVGPathBounds.clone(attr.bounds);
        result.transform = AffineTransformer.of(attr.transform);
        return result;
    }
}

class ConvCount implements IVertexSource
{
    private var _source:IVertexSource;
    private var _count:UInt;

    public var count(get, set): UInt;

    public function new(source:IVertexSource)
    {
        _source = source;
        _count = 0;
    }

    public function rewind(pathId:UInt):Void
    {
        _source.rewind(pathId);
    }

    public function getVertex(x:FloatRef, y:FloatRef): UInt
    {
        ++_count;
        return _source.getVertex(x,y);
    }

    function get_count():UInt
    {
        return _count;
    }

    function set_count(value:UInt) {
        return _count = value;
    }
}

class SVGPathRenderer
{
    private var _storage: VectorPath;
    private var _attr_storage: Array<PathAttributes>;
    private var _attr_stack: Array<PathAttributes>;
    private var _transform: AffineTransformer;

    private var _curved: ConvCurve;

    private var _curved_stroked: ConvStroke;
    private var _curved_stroked_trans: ConvTransform;

    private var _curved_trans: ConvTransform;
    private var _curved_trans_contour: ConvContour;

    private var _gradients: Map<String, SVGGradient>;

    public function new()
    {
        _storage = new VectorPath();
        _attr_storage = new Array();
        _attr_stack = new Array();
        _transform = new AffineTransformer();

        _curved = new ConvCurve(_storage);

        _curved_stroked = new ConvStroke(_curved);
        _curved_stroked_trans = new ConvTransform(_curved_stroked, _transform);

        _curved_trans = new ConvTransform(_curved, _transform);
        _curved_trans_contour = new ConvContour(_curved_trans);

        _curved_trans_contour.autoDetect = false;
        _gradients = new Map<String, SVGGradient>();
    }

    public function remove_all(): Void
    {
        _storage.removeAll();
        _attr_storage = new Array();
        _attr_stack = new Array();
        _transform.reset();
    }

    // Make all polygons CCW-oriented
    public function arrange_orientations(): Void
    {
        _storage.arrangeOrientationsAllPaths(PathFlags.CCW);
    }

    // Expand all polygons
    public function expand(value: Float): Void
    {
        _curved_trans_contour.width = value;
    }

    private function eachGradiendAncestor(id: String, callback: SVGGradient -> Bool): Void
    {
        var cur: SVGGradient = _gradients.get(id);
        while (cur != null)
        {
            if (!callback(cur))
            {
                break;
            }

            cur = _gradients.get(cur.link);
        }
    }

    private function getGradientColors(id: String): ColorArray
    {
        var colors: ColorArray;
        eachGradiendAncestor(id, function(grad: SVGGradient)
        {
            if (grad.gradientColors != null)
            {
                colors = grad.gradientColors;
                return false;
            }

            return true;
        });

        return colors;
    }


        public function render(ras:ScanlineRasterizer, sl:IScanline, ren:ClippingRenderer, mtx: AffineTransformer, alpha: Float): Void
        {
            for (attr in _attr_storage)
            {
                _transform.set(attr.transform.sx, attr.transform.shy, attr.transform.shx, attr.transform.sy, attr.transform.tx, attr.transform.ty);
                _transform.multiply(mtx);
                var scl: Float = _transform.scaling;
                _curved.approximationMethod = CubicCurve.CURVE_INC;
                _curved.approximationScale = scl;
                _curved.angleTolerance = 0.0;

                var color: RgbaColor = new RgbaColor();

                if (attr.fill_flag)
                {
                    ras.reset();
                    ras.fillingRule = attr.even_odd_flag ? FillingRule.FILL_EVEN_ODD : FillingRule.FILL_NON_ZERO;

                    if (Math.abs(_curved_trans_contour.width) < 0.0001)
                    {
                        ras.addPath(_curved_trans, attr.index);
                    }
                    else
                    {
                        _curved_trans_contour.miterLimit = attr.miter_limit;
                        ras.addPath(_curved_trans_contour, attr.index);
                    }

                    color.set(attr.fill_color);
                    color.opacity = color.opacity * alpha;
                    SolidScanlineRenderer.renderAASolidScanlines(ras, sl, ren, color);
                }

                if (attr.gradientId != null && _gradients.exists(attr.gradientId))
                {
                    ras.reset();
                    ras.fillingRule = attr.even_odd_flag ? FillingRule.FILL_EVEN_ODD : FillingRule.FILL_NON_ZERO;

                    if (Math.abs(_curved_trans_contour.width) < 0.0001)
                    {
                        ras.addPath(_curved_trans, attr.index);
                    }
                    else
                    {
                        _curved_trans_contour.miterLimit = attr.miter_limit;
                        ras.addPath(_curved_trans_contour, attr.index);
                    }

                    var gradientFunction = new GradientX();
                    var gradientMatrix = new AffineTransformer();
                    gradientMatrix.premultiply(_transform);
                    gradientMatrix.invert();
                    var spanInterpolator = new SpanInterpolatorLinear(gradientMatrix);
                    var spanAllocator = new SpanAllocator();

                    var gradientSpan = new SpanGradient(spanInterpolator, gradientFunction, getGradientColors(attr.gradientId), attr.bounds.minX, attr.bounds.maxX);
                    var gradientRenderer = new ScanlineRenderer(ren, spanAllocator, gradientSpan);

                    SolidScanlineRenderer.renderScanlines(ras, sl, gradientRenderer);
                }

                if (attr.stroke_flag)
                {
                    _curved_stroked.width = attr.stroke_width;
                    _curved_stroked.lineJoin = attr.line_join;
                    _curved_stroked.lineCap = attr.line_cap;
                    _curved_stroked.miterLimit = attr.miter_limit;
                    _curved_stroked.innerJoin = InnerJoin.ROUND;
                    _curved_stroked.approximationScale = scl;

                    // If the *visual* line width is considerable we
                    // turn on processing of curve cusps.
                    //---------------------
                    if(attr.stroke_width * scl > 1.0)
                    {
                        _curved.angleTolerance = 0.2;
                    }
                    ras.reset();
                    ras.fillingRule = FillingRule.FILL_NON_ZERO;
                    ras.addPath(_curved_stroked_trans, attr.index);
                    color.set(attr.stroke_color);
                    color.opacity = color.opacity * alpha;
                    SolidScanlineRenderer.renderAASolidScanlines(ras, sl, ren, color);
                }
            }
        }

    private function cur_attr(): PathAttributes
    {
        if (_attr_stack.length == 0)
        {
            throw "cur_attr : Attribute stack is empty";
        }
        return _attr_stack[_attr_stack.length - 1];
    }

    public function push_attr(): Void
    {
        if (_attr_stack.length == 0)
        {
            _attr_stack.push(PathAttributes.create());
        }
        else
        {
            var lastElement = _attr_stack[_attr_stack.length - 1];
            _attr_stack.push(PathAttributes.copy(lastElement));
        }
    }

    public function pop_attr(): Void
    {
        if (_attr_stack.length == 0)
        {
            throw "pop_attr : Attribute stack is empty";
        }
        _attr_stack.pop();
    }

    public function beginPath(): Void
    {
        push_attr();
        var idx: Int = _storage.startNewPath();
        _attr_storage.push(PathAttributes.copy(cur_attr(), idx));
    }

    public function addGradient(gradient: SVGGradient): Void
    {
        _gradients.set(gradient.id, gradient);
    }

    public function getGradient(id: String): SVGGradient
    {
        return _gradients.get(id);
    }

    public function endPath(): Void
    {
        if (_attr_storage.length == 0)
        {
            throw "end_path : The path was not begun";
        }

        var attr: PathAttributes = cur_attr();
        var idx: UInt = _attr_storage[_attr_storage.length - 1].index;
        attr.index = idx;
        _attr_storage[_attr_storage.length - 1] = attr;

        _storage.rewind(attr.index);
        var x: FloatRef = Ref.getFloat();
        var y: FloatRef = Ref.getFloat();
        var cmd: Int = 0;
        while ((cmd = _storage.getVertex(x, y)) != PathCommands.STOP)
        {
            if (!PathUtils.isVertex(cmd))
            {
                continue;
            }

            attr.bounds.add(x.value, y.value);
        }

        Ref.putFloat(x);
        Ref.putFloat(y);

        _storage.rewind(0);

        //trace('${attr.id}: ${attr.bounds}');
        pop_attr();

        debugBox(attr.bounds);
    }

    public function id(id: String)
    {
        cur_attr().id = id;
    }

    public function debugBox(bounds: SVGPathBounds)
    {
        push_attr();
        var idx: Int = _storage.startNewPath();
        _attr_storage.push(PathAttributes.copy(cur_attr(), idx));
        fill_none();
        this.stroke(new RgbaColor(255, 0, 0));
        move_to(bounds.minX, bounds.minY);
        line_to(bounds.maxX, bounds.minY);
        line_to(bounds.maxX, bounds.maxY);
        line_to(bounds.minX, bounds.maxY);
        close_subpath();

        var attr: PathAttributes = cur_attr();
        var idx: UInt = _attr_storage[_attr_storage.length - 1].index;
        attr.index = idx;
        _attr_storage[_attr_storage.length - 1] = attr;

        pop_attr();
    }

    public function parse_path(tok: SVGPathTokenizer): Void
    {
        var arg: Vector<Float> = new Vector(9);

        while (tok.hasNext())
        {
            var cmd = tok.last_command();
            switch (cmd)
            {
                case "M", "m":
                    {
                        arg[0] = tok.last_number();
                        arg[1] = tok.next(cmd);
                        move_to(arg[0], arg[1], cmd == "m");
                    }
                case "L", "l":
                    {
                        arg[0] = tok.last_number();
                        arg[1] = tok.next(cmd);
                        line_to(arg[0], arg[1], cmd == "l");
                    }
                case "V", "v":
                    {
                        vline_to(tok.last_number(), cmd == "v");
                    }
                case "H", "h":
                    {
                        hline_to(tok.last_number(), cmd == "h");
                    }
                case "Q", "q":
                    {
                        arg[0] = tok.last_number();
                        for (i in 1...4)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        curve3Q(arg[0], arg[1], arg[2], arg[3], cmd == "q");
                    }
                case "T", "t":
                    {
                        arg[0] = tok.last_number();
                        arg[1] = tok.next(cmd);
                        curve3(arg[0], arg[1], cmd == "t");
                    }
                case "C", "c":
                    {
                        arg[0] = tok.last_number();
                        for (i in 1...6)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        curve4C(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], cmd == "c");
                    }
                case "S", "s":
                    {
                        arg[0] = tok.last_number();
                        for (i in 1...4)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        curve4(arg[0], arg[1], arg[2], arg[3], cmd == "s");
                    }
                case "A", "a":
                    {
                        //throw "parse_path: Command A: NOT IMPLEMENTED YET";
                        trace("parse_path: Command A: NOT IMPLEMENTED YET");
                        for (i in 0...6)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        line_to(arg[5], arg[6], cmd == "a");
                    }
                case "Z", "z":
                    {
                        if (cmd == "Z") close_subpath();
                    }
                default:
                    {
                        throw 'parse_path: Invalid Command $cmd';
                    }
            }
        }
    }

    // The following functions are essentially a "reflection" of
    // the respective SVG path commands.

    // M, m
    public function move_to(x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.moveRel(x, y);
        }
        else
        {
            _storage.moveTo(x, y);
        }
    }

    // L, l
    public function line_to(x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.lineRel(x, y);
        }
        else
        {
            _storage.lineTo(x, y);
        }
    }

    // H, h
    public function hline_to(x: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.hlineRel(x);
        }
        else
        {
            _storage.hlineTo(x);
        }
    }

    // V, v
    public function vline_to(y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.vlineRel(y);
        }
        else
        {
            _storage.vlineTo(y);
        }
    }

    // Q, q
    public function curve3Q(x1: Float, y1: Float, x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve3Rel(x1, y1, x, y);
        }
        else
        {
            _storage.curve3(x1, y1, x, y);
        }
    }

    // T, t
    public function curve3(x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve3RelTo(x,y);
        }
        else
        {
            _storage.curve3To(x,y);
        }
    }

    // C, c
    public function curve4C(x1: Float, y1: Float, x2: Float, y2: Float, x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve4Rel(x1,y1,x2,y2,x,y);
        }
        else
        {
            _storage.curve4(x1,y1,x2,y2,x,y);
        }
    }

    // S, s
    public function curve4(x2: Float, y2: Float, x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve4RelTo(x2,y2,x,y);
        }
        else
        {
            _storage.curve4To(x2,y2,x,y);
        }
    }

    // Z, z
    public function close_subpath(): Void
    {
        _storage.endPoly(PathFlags.CLOSE);
    }

    public function fill_none(): Void
    {
        cur_attr().fill_flag = false;
    }

    public function fill(color: RgbaColor): Void
    {
        cur_attr().fill_color.set(color);
        cur_attr().fill_flag = true;
    }

    public function fill_opacity(opacity: Float): Void
    {
        cur_attr().fill_color.opacity = opacity;
    }

    public function fillGradient(id: String)
    {
        cur_attr().gradientId = id;
    }

    public function stroke_none(): Void
    {
        cur_attr().stroke_flag = false;
    }

    public function stroke(color: RgbaColor): Void
    {
        cur_attr().stroke_color.set(color);
        cur_attr().stroke_flag = true;
    }

    public function stroke_width(width: Float): Void
    {
        cur_attr().stroke_width = width;
    }

    public function line_cap(lineCap: Int): Void
    {
        cur_attr().line_cap = lineCap;
    }

    public function line_join(lineJoin: Int): Void
    {
        cur_attr().line_join = lineJoin;
    }

    public function miter_limit(miterLimit: Float): Void
    {
        cur_attr().miter_limit = miterLimit;
    }

    public function stroke_opacity(strokeOpacity: Float): Void
    {
        cur_attr().stroke_color.opacity = strokeOpacity;
    }

    public function transform(): AffineTransformer
    {
        return cur_attr().transform;
    }
}
