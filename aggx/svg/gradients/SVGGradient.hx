package aggx.svg.gradients;

import aggx.color.SpanGradient.SpreadMethod;
import haxe.ds.Vector;
import aggx.core.memory.Ref.FloatRef;
import aggx.core.geometry.AffineTransformer;
import aggx.color.ColorArray;
import aggx.color.RgbaColor;

enum GradientType
{
    Linear;
    Radial;
}

class SVGStop
{
    public var color: RgbaColor;
    public var offset: Float;
    public function new()
    {

    }
    public function toString(): String
    {
        return '{$offset: $color}';
    }
}

class SVGGradient
{
    public var id: String = "";
    public var gradientColors: ColorArray;
    public var link: String;
    public var transform: AffineTransformer;
    public var userSpace: Null<Bool>;
    public var spreadMethod: Null<SpreadMethod>;
    public var type: GradientType;
    public var gradientVector: Vector<FloatRef> = new Vector<FloatRef>(4);
    public var focalGradientParameters: Vector<FloatRef> = new Vector<FloatRef>(5);
    public var stops: Array<SVGStop> = [];

    public function new()
    {

    }

    public function calculateColorArray(stops: Array<SVGStop>): Void
    {
        this.stops = [];
        this.stops.concat(stops);

        if (stops.length < 1)
        {
            return;
        }

        gradientColors = new ColorArray(256);

        stops.sort(function (a, b)
        {
            if (a.offset == b.offset)
            {
                return 0;
            }

            return a.offset - b.offset > 0 ? 1 : -1;
        });

        var currentStop: Int = -1;
        var lastStop: Int = stops.length - 1;

        for (i in 0 ... 256)
        {
            var percent: Float = i / 256.0;
            if (currentStop == lastStop)
            {
                gradientColors.set(stops[lastStop].color, i);
                continue;
            }

            var nextStop: Int = currentStop + 1;
            if (percent > stops[nextStop].offset)
            {
                currentStop = nextStop;
                nextStop = currentStop + 1;

                if (currentStop == lastStop)
                {
                    gradientColors.set(stops[lastStop].color, i);
                    continue;
                }
            }

            if (currentStop < 0)
            {
                gradientColors.set(stops[nextStop].color, i);
                continue;
            }
            
            var distance: Float = stops[nextStop].offset - stops[currentStop].offset;
            var pos: Float = percent - stops[currentStop].offset;

            var begin: RgbaColor = stops[currentStop].color;
            var end: RgbaColor = stops[nextStop].color;
            gradientColors.set(begin.gradient(end, pos / distance), i);
        }

        /*for (i in 0 ... 256)
        {
            trace(gradientColors.get(i));
        }*/
    }
}