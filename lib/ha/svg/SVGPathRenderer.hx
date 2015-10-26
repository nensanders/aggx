package lib.ha.svg;
import lib.ha.svg.SVGElement;
import lib.ha.aggx.color.GradientRadialFocus;
import lib.ha.svg.gradients.GradientManager;
import lib.ha.svg.gradients.SVGGradient;
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
    private var _elementStorage: Array<SVGElement>;
    private var _elementStack: Array<SVGElement>;
    private var _transform: AffineTransformer;

    private var _curved: ConvCurve;

    private var _curved_stroked: ConvStroke;
    private var _curved_stroked_trans: ConvTransform;

    private var _curved_trans: ConvTransform;
    private var _curved_trans_contour: ConvContour;
    private var _gradientManager: GradientManager = new GradientManager();

    private var _gradientFunction: GradientX = new GradientX();
    private var _gradientRadialFocus: GradientRadialFocus = new GradientRadialFocus();
    private var _gradientMatrix: AffineTransformer = new AffineTransformer();
    private var _spanInterpolator: SpanInterpolatorLinear;
    private var _spanAllocator: SpanAllocator = new SpanAllocator();

    public function new()
    {
        _storage = new VectorPath();
        _elementStorage = new Array();
        _elementStack = new Array();
        _transform = new AffineTransformer();

        _curved = new ConvCurve(_storage);

        _curved_stroked = new ConvStroke(_curved);
        _curved_stroked_trans = new ConvTransform(_curved_stroked, _transform);

        _curved_trans = new ConvTransform(_curved, _transform);
        _curved_trans_contour = new ConvContour(_curved_trans);

        _curved_trans_contour.autoDetect = false;
        _spanInterpolator = new SpanInterpolatorLinear(_gradientMatrix);
    }

    public function remove_all(): Void
    {
        _storage.removeAll();
        _elementStorage = new Array();
        _elementStack = new Array();
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

    private function renderElement(element: SVGElement, ras:ScanlineRasterizer, sl:IScanline, ren:ClippingRenderer, mtx: AffineTransformer, alpha: Float)
    {
        _transform.set(element.transform.sx, element.transform.shy, element.transform.shx, element.transform.sy, element.transform.tx, element.transform.ty);
        _transform.multiply(mtx);
        var scl: Float = _transform.scaling;
        _curved.approximationMethod = CubicCurve.CURVE_INC;
        _curved.approximationScale = scl;
        _curved.angleTolerance = 0.0;

        var color: RgbaColor = new RgbaColor();

        if (element.fill_flag)
        {
            ras.reset();
            ras.fillingRule = element.even_odd_flag ? FillingRule.FILL_EVEN_ODD : FillingRule.FILL_NON_ZERO;

            if (Math.abs(_curved_trans_contour.width) < 0.0001)
            {
                ras.addPath(_curved_trans, element.index);
            }
            else
            {
                _curved_trans_contour.miterLimit = element.miter_limit;
                ras.addPath(_curved_trans_contour, element.index);
            }

            color.set(element.fill_color);
            color.opacity = color.opacity * alpha;
            SolidScanlineRenderer.renderAASolidScanlines(ras, sl, ren, color);
        }

        var gradient: SVGGradient;
        if (element.gradientId != null && (gradient = _gradientManager.getGradient(element.gradientId)) != null)
        {
            ras.reset();
            ras.fillingRule = element.even_odd_flag ? FillingRule.FILL_EVEN_ODD : FillingRule.FILL_NON_ZERO;

            if (Math.abs(_curved_trans_contour.width) < 0.0001)
            {
                ras.addPath(_curved_trans, element.index);
            }
            else
            {
                _curved_trans_contour.miterLimit = element.miter_limit;
                ras.addPath(_curved_trans_contour, element.index);
            }

            var gradientSpan: SpanGradient;
            if (gradient.type == GradientType.Linear)
            {
                _gradientManager.calculateLinearGradientTransform(element.gradientId, element.bounds, _transform, _gradientMatrix);
                gradientSpan = new SpanGradient(_spanInterpolator, _gradientFunction, _gradientManager.getGradientColors(element.gradientId), 0, 100);
            }
            else
            {
                _gradientManager.calculateRadialGradientParameters(element.gradientId, element.bounds, _transform, _gradientMatrix, _gradientRadialFocus);
                gradientSpan = new SpanGradient(_spanInterpolator, _gradientRadialFocus, _gradientManager.getGradientColors(element.gradientId), 0, 100);
            }

            gradientSpan.spread = _gradientManager.getSpreadMethod(element.gradientId);

            var gradientRenderer = new ScanlineRenderer(ren, _spanAllocator, gradientSpan);

            SolidScanlineRenderer.renderScanlines(ras, sl, gradientRenderer);
        }

        if (element.stroke_flag)
        {
            _curved_stroked.width = element.stroke_width;
            _curved_stroked.lineJoin = element.line_join;
            _curved_stroked.lineCap = element.line_cap;
            _curved_stroked.miterLimit = element.miter_limit;
            _curved_stroked.innerJoin = InnerJoin.ROUND;
            _curved_stroked.approximationScale = scl;

            // If the *visual* line width is considerable we
            // turn on processing of curve cusps.
            if(element.stroke_width * scl > 1.0)
            {
                _curved.angleTolerance = 0.2;
            }
            ras.reset();
            ras.fillingRule = FillingRule.FILL_NON_ZERO;
            ras.addPath(_curved_stroked_trans, element.index);
            color.set(element.stroke_color);
            color.opacity = color.opacity * alpha;
            SolidScanlineRenderer.renderAASolidScanlines(ras, sl, ren, color);
        }
    }

    public function render(ras:ScanlineRasterizer, sl:IScanline, ren:ClippingRenderer, mtx: AffineTransformer, alpha: Float): Void
    {
        for (elem in _elementStorage)
        {
            renderElement(elem, ras, sl, ren, mtx, alpha);
        }
    }

    private function curElement(): SVGElement
    {
        if (_elementStack.length == 0)
        {
            throw "curElement : elementibute stack is empty";
        }
        return _elementStack[_elementStack.length - 1];
    }

    public function pushElement(): Void
    {
        if (_elementStack.length == 0)
        {
            _elementStack.push(SVGElement.create());
        }
        else
        {
            var lastElement = _elementStack[_elementStack.length - 1];
            _elementStack.push(SVGElement.copy(lastElement));
        }
    }

    public function popElement(): Void
    {
        if (_elementStack.length == 0)
        {
            throw "pop_element : elementibute stack is empty";
        }
        _elementStack.pop();
    }

    public function beginPath(): Void
    {
        pushElement();
        var idx: Int = _storage.startNewPath();
        _elementStorage.push(SVGElement.copy(curElement(), idx));
    }

    public function addGradient(gradient: SVGGradient): Void
    {
        _gradientManager.addGradient(gradient);
    }

    public function endPath(): Void
    {
        if (_elementStorage.length == 0)
        {
            throw "end_path : The path was not begun";
        }

        var element: SVGElement = curElement();
        var idx: UInt = _elementStorage[_elementStorage.length - 1].index;
        element.index = idx;
        _elementStorage[_elementStorage.length - 1] = element;

        _storage.rewind(element.index);
        var x: FloatRef = Ref.getFloat();
        var y: FloatRef = Ref.getFloat();
        var cmd: Int = 0;
        while ((cmd = _storage.getVertex(x, y)) != PathCommands.STOP)
        {
            if (!PathUtils.isVertex(cmd))
            {
                continue;
            }

            element.bounds.add(x.value, y.value);
        }

        Ref.putFloat(x);
        Ref.putFloat(y);

        _storage.rewind(0);

        //trace('${element.id}: ${element.bounds}');
        popElement();

        //debugBox(element.bounds);
    }

    public function id(id: String)
    {
        curElement().id = id;
    }

    public function debugBox(bounds: SVGPathBounds)
    {
        pushElement();
        var idx: Int = _storage.startNewPath();
        _elementStorage.push(SVGElement.copy(curElement(), idx));
        fill_none();
        this.stroke(new RgbaColor(255, 0, 0));
        move_to(bounds.minX, bounds.minY);
        line_to(bounds.maxX, bounds.minY);
        line_to(bounds.maxX, bounds.maxY);
        line_to(bounds.minX, bounds.maxY);
        close_subpath();

        var element: SVGElement = curElement();
        var idx: UInt = _elementStorage[_elementStorage.length - 1].index;
        element.index = idx;
        _elementStorage[_elementStorage.length - 1] = element;

        popElement();
    }

    public function parse_path(tok: SVGPathTokenizer): Void
    {
        var arg: Vector<Float> = new Vector(7);

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
                        arg[0] = tok.last_number();
                        for (i in 1...7)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        trace(arg);
                        arc(arg[0], arg[1], arg[2], arg[3] != 0, arg[4] != 0, arg[5], arg[6], cmd == 'a');
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

    //A, a
    public function arc(rx: Float, ry: Float, angle: Float, isLargeArc: Bool, isSweep: Bool, x: Float, y: Float, rel: Bool = false)
    {
        if (rel)
        {
            _storage.arcRel(rx, ry, angle, isLargeArc, isSweep, x, y);
        }
        else
        {
            _storage.arc(rx, ry, angle, isLargeArc, isSweep, x, y);
        }
    }

    // Z, z
    public function close_subpath(): Void
    {
        _storage.endPoly(PathFlags.CLOSE);
    }

    public function fill_none(): Void
    {
        curElement().fill_flag = false;
    }

    public function fill(color: RgbaColor): Void
    {
        curElement().fill_color.set(color);
        curElement().fill_flag = true;
    }

    public function fill_opacity(opacity: Float): Void
    {
        curElement().fill_color.opacity = opacity;
    }

    public function fillGradient(id: String)
    {
        curElement().gradientId = id;
    }

    public function stroke_none(): Void
    {
        curElement().stroke_flag = false;
    }

    public function stroke(color: RgbaColor): Void
    {
        curElement().stroke_color.set(color);
        curElement().stroke_flag = true;
    }

    public function stroke_width(width: Float): Void
    {
        curElement().stroke_width = width;
    }

    public function line_cap(lineCap: Int): Void
    {
        curElement().line_cap = lineCap;
    }

    public function line_join(lineJoin: Int): Void
    {
        curElement().line_join = lineJoin;
    }

    public function miter_limit(miterLimit: Float): Void
    {
        curElement().miter_limit = miterLimit;
    }

    public function stroke_opacity(strokeOpacity: Float): Void
    {
        curElement().stroke_color.opacity = strokeOpacity;
    }

    public function transform(): AffineTransformer
    {
        return curElement().transform;
    }
}
