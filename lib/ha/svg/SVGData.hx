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

class SVGData
{
    private var _storage: VectorPath;
    private var _elementStorage: Array<SVGElement>;
    private var _gradientManager: GradientManager = new GradientManager();

    private var _elementStack: Array<SVGElement>;
    private var _transform: AffineTransformer;
    private var _pathParser: SVGPathParser;

    private var _expandValue: Float = 0;

    public function new()
    {
        _storage = new VectorPath();
        _elementStorage = new Array();
        _elementStack = new Array();
        _transform = new AffineTransformer();
        _pathParser = new SVGPathParser(_storage);
    }

    public function getVertexStorage(): VectorPath
    {
        return _storage;
    }

    public function getElementStorage(): Array<SVGElement>
    {
        return _elementStorage;
    }

    public function getGradientManager(): GradientManager
    {
        return _gradientManager;
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
        //_curved_trans_contour.width = value;
        _expandValue = value;
    }

    public function getExpandValue(): Float
    {
        return _expandValue;
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

    public function addGradient(gradient: SVGGradient): Void
    {
        _gradientManager.addGradient(gradient);
    }

    public function beginPath(): Void
    {
        pushElement();
        var idx: Int = _storage.startNewPath();
        _elementStorage.push(SVGElement.copy(curElement(), idx));
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
        _pathParser.move_to(bounds.minX, bounds.minY);
        _pathParser.line_to(bounds.maxX, bounds.minY);
        _pathParser.line_to(bounds.maxX, bounds.maxY);
        _pathParser.line_to(bounds.minX, bounds.maxY);
        _pathParser.close_subpath();

        var element: SVGElement = curElement();
        var idx: UInt = _elementStorage[_elementStorage.length - 1].index;
        element.index = idx;
        _elementStorage[_elementStorage.length - 1] = element;

        popElement();
    }

    public function path(tok: SVGPathTokenizer): Void
    {
        _pathParser.parsePath(tok);
    }

    public function rect(x: Float, y: Float, width: Float, height: Float)
    {
        _pathParser.move_to(x,y);
        _pathParser.line_to(x + width, y);
        _pathParser.line_to(x + width, y + height);
        _pathParser.line_to(x,y + height);
        _pathParser.close_subpath();
    }

    public function line(x1: Float, y1: Float, x2: Float, y2: Float)
    {
        _pathParser.move_to(x1, y1);
        _pathParser.line_to(x2, y2);
    }

    public function poly(tok: SVGPathTokenizer, close: Bool)
    {
        _pathParser.parsePoly(tok, close);
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
        curElement().fill_opacity = opacity;
    }

    public function fillGradient(id: String)
    {
        fill_none();
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
