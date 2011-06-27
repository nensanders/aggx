package lib.ha.aggx.color;
//=======================================================================================================
interface IColorFunction 
{
	public var size(get_size, null):UInt;
	public function get(idx:UInt):RgbaColor;
}