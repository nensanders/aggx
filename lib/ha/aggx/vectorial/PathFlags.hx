package lib.ha.aggx.vectorial;
//=======================================================================================================
class PathFlags 
{
	public inline static var NONE:Int = 0;
	public inline static var CCW:Int = 0x10;
	public inline static var CW:Int = 0x20;
	public inline static var CLOSE:Int = 0x40;
	public inline static var MASK:Int = 0xF0;
}