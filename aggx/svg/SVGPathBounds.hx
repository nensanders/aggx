package aggx.svg;

class SVGPathBounds
{
    public var minX(default, null): Float;
    public var minY(default, null): Float;
    public var maxX(default, null): Float;
    public var maxY(default, null): Float;

    public function new()
    {
        reset();
    }

    public static function clone(source: SVGPathBounds): SVGPathBounds
    {
        var temp = new SVGPathBounds();
        temp.minX = source.minX;
        temp.maxX = source.maxX;
        temp.minY = source.minY;
        temp.maxY = source.maxY;
        return temp;
    }

    public function toString(): String
    {
        return '{[$minX, $minY] - [$maxX, $maxY]}';
    }

    public function reset()
    {
        minX = Math.POSITIVE_INFINITY;
        minY = Math.POSITIVE_INFINITY;
        maxX = Math.NEGATIVE_INFINITY;
        maxY = Math.NEGATIVE_INFINITY;
    }

    public function add(x: Float, y: Float)
    {
        if (x < minX)
        {
            minX = x;
        }

        if (x > maxX)
        {
            maxX = x;
        }

        if (y < minY)
        {
            minY = y;
        }

        if (y > maxY)
        {
            maxY = y;
        }
    }
}