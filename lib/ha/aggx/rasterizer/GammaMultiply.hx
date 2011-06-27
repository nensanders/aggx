package lib.ha.aggx.rasterizer;
//=======================================================================================================
class GammaMultiply implements IGammaFunction
{
	private var _mul:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(m:Float = 1.0)
	{
		_mul = m;
	}	
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		var y = x * _mul;
		if (y > 1.0) y = 1.0;
		return y;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_value():Float { return _mul; }
	private inline function set_value(val:Float):Float { return _mul = val; }
	public inline var value(get_value, set_value):Float;
}