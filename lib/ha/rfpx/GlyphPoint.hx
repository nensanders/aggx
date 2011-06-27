package lib.ha.rfpx;
//=======================================================================================================
class GlyphPoint 
{
	public static var FT_CURVE_TAG_ON = 1;
	public static var FT_CURVE_TAG_CONIC = 0;
	public static var FT_CURVE_TAG_CUBIC = 2;
	public static function FT_CURVE_TAG(flag:UInt):Bool { return (flag & 3) != 0; }
	//---------------------------------------------------------------------------------------------------
	public var x:Int;
	public var y:Int;
	public var tag:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(_x:Int, _y:Int, _tag:Int)
	{
		x = _x;
		y = _y;
		tag = _tag;
	}
}