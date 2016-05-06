package aggx.core.geometry;

class Vector2D
{
    public var x: Float;
    public var y: Float;

    public function new()
    {

    }

    public function set(other: Vector2D): Void
    {
        x = other.x;
        y = other.y;
    }

    public function setXY(x: Float, y: Float): Void
    {
        this.x = x;
        this.y = y;
    }

    public function subtract(right : Vector2D) : Void
    {
        x = x - right.x;
        y = y - right.y;
    }

    public static function length(vector : Vector2D) : Float
    {
        return Math.sqrt(Vector2D.lengthSquared(vector));
    }

    public static function lengthSquared(vector : Vector2D) : Float
    {
        return vector.x * vector.x + vector.y * vector.y;
    }

    public static function dotProduct(left: Vector2D, right: Vector2D) : Float
    {
        return left.x * right.x + left.y * right.y;
    }

    static private var distanceVector2 : Vector2D = new Vector2D();

    public static function distance(start : Vector2D, end : Vector2D) : Float
    {
        distanceVector2.set(end);
        distanceVector2.subtract(start);

        return Vector2D.length(distanceVector2);
    }

}