package lib.ha.aggx.rasterizer;
//=======================================================================================================
class GammaThreshold implements IGammaFunction
{
	private var _threshold:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(t:Float = 0.5)
	{
		_threshold = t;
	}
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		return (x < _threshold) ? 0.0 : 1.0;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_threshold():Float { return _threshold; }
	private inline function set_threshold(value:Float):Float { return _threshold = value; }
	public inline var threshold(get_threshold, set_threshold):Float;
}