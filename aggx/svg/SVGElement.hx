package aggx.svg;

import aggx.vectorial.VectorPath;
import aggx.vectorial.PathUtils;
import aggx.vectorial.PathCommands;
import aggx.core.memory.Ref;
import aggx.core.memory.Ref.FloatRef;
import aggx.vectorial.LineCap;
import aggx.vectorial.LineJoin;
import aggx.core.geometry.AffineTransformer;
import aggx.color.RgbaColor;

class SVGElement
{
    public var id: String;
    public var index: UInt;
    public var transform: AffineTransformer;
    public var gradientId: String;

    public var fill_flag: Bool;
    public var fill_color: RgbaColor;
    public var fill_opacity: Null<Float>;

    public var stroke_flag: Bool;
    public var stroke_color: RgbaColor;
    public var stroke_width: Float;

    public var even_odd_flag: Bool;

    public var line_join: Int; // ENUM CLASS
    public var line_cap: Int; // ENUM CLASS

    public var miter_limit: Float;

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

    static public function create(): SVGElement
    {
        return new SVGElement();
    }

    static public function copy(attr: SVGElement, ?idx: UInt): SVGElement
    {
        var result: SVGElement = new SVGElement();
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

    public function fill_none(): Void
    {
        fill_flag = false;
    }

    public function fill(color: RgbaColor): Void
    {
        fill_color.set(color);
        fill_flag = true;
    }

    public function fillGradient(id: String)
    {
        fill_none();
        gradientId = id;
    }

    public function stroke_none(): Void
    {
        stroke_flag = false;
    }

    public function stroke(color: RgbaColor): Void
    {
        stroke_color.set(color);
        stroke_flag = true;
    }

    public function stroke_opacity(strokeOpacity: Float): Void
    {
        stroke_color.opacity = strokeOpacity;
    }

    public function calculateBoundingBox(storage: VectorPath): Void
    {
        bounds.reset();
        storage.rewind(index);

        var x: FloatRef = Ref.getFloat();
        var y: FloatRef = Ref.getFloat();

        var cmd: Int = 0;

        while ((cmd = storage.getVertex(x, y)) != PathCommands.STOP)
        {
            if (!PathUtils.isVertex(cmd))
            {
                continue;
            }

            bounds.add(x.value, y.value);
        }

        Ref.putFloat(x);
        Ref.putFloat(y);

        storage.rewind(0);
    }
}