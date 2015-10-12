package lib.ha.svg;

class SVGPathBounds
{
    public var minX(default, null): Float = Math.POSITIVE_INFINITY;
    public var minY(default, null): Float = Math.POSITIVE_INFINITY;
    public var maxX(default, null): Float = Math.NEGATIVE_INFINITY;
    public var maxY(default, null): Float = Math.NEGATIVE_INFINITY;

    public function new()
    {

    }

    public function toString(): String
    {
        return '{[$minX, $minY] - [$maxX, $maxY]}';
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