package lib.ha.aggx.color;
//=======================================================================================================
class GradientLinearColor implements IColorFunction
{
	public var _c1:RgbaColor;
	public var _c2:RgbaColor;
	private var _size:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(c1:RgbaColor, c2:RgbaColor, size:Int = 256)
	{
		_c1 = c1;
		_c2 = c2;
		_size = size;
	}
	//---------------------------------------------------------------------------------------------------
	public function colors(c1:RgbaColor, c2:RgbaColor, size:Int = 256)
	{
		_c1 = c1;
		_c2 = c2;
		_size = size;
	}
	//---------------------------------------------------------------------------------------------------
	public function at(idx:Int):RgbaColor
	{
		return _c1.gradient(_c2, v / _size - 1);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_size():Int { return _size; }
	public inline var size(get_size, null):Int;
}