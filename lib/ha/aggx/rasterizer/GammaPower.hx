package lib.ha.aggx.rasterizer;
//=======================================================================================================
class GammaPower implements IGammaFunction
{
	private var _gamma:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(g:Float = 1.0)
	{
		_gamma = g;
	}
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		return Math.pow(x, _gamma);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_gamma():Float { return _gamma; }
	private inline function set_gamma(value:Float):Float { return _gamma = value; }
	public inline var gamma(get_gamma, set_gamma):Float;
}