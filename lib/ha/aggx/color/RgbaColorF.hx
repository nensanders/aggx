package lib.ha.aggx.color;
//=======================================================================================================
class RgbaColorF 
{
	public var r:Float;
	public var g:Float;
	public var b:Float;
	public var a:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(r_:Float, g_:Float, b_:Float, a_:Float=1.0)
	{
		r = r_;
		g = g_;
		b = b_;
		a = a_;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function toRgbaColor():RgbaColor
	{
		return new RgbaColor(Std.int(r * RgbaColor.BASE_MASK), Std.int(g * RgbaColor.BASE_MASK), Std.int(b * RgbaColor.BASE_MASK), Std.int(a * RgbaColor.BASE_MASK));
	}
}