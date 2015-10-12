package lib.ha.svg;

import lib.ha.aggxtest.AATest.ColorArray;
import lib.ha.aggx.color.RgbaColor;

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
    public var gradientColors(default, null): ColorArray;
    public var type: GradientType;
    public var link: String;

    public function new()
    {

    }

    public function calculateColorArray(stops: Array<SVGStop>): Void
    {
        if (stops.length < 1)
        {
            return;
        }

        gradientColors = new ColorArray(256);

        stops.sort(function (a, b) {return a.offset - b.offset < 0 ? 1 : 0;});
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

        trace(gradientColors.get(255));
    }
}