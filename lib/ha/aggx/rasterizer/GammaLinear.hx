package lib.ha.aggx.rasterizer;
//=======================================================================================================
class GammaLinear implements IGammaFunction
{
	private var _start:Float;
	private var _end:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(s:Float = 0.0, e:Float = 1.0)
	{
		_start = s;
		_end = e;
	}
	//---------------------------------------------------------------------------------------------------
	public function set(s:Float, e:Float):Void
	{
		_start = s;
		_end = e;
	}
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		if (x < _start) return 0.0;
		if (x > _end) return 1.0;
		return (x - _start) / (_end - _start);		
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_start():Float { return _start; }
	private inline function set_start(value:Float):Float { return _start = value; }
	public inline var start(get_start, set_start):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_end():Float { return _end; }
	private inline function set_end(value:Float):Float { return _end = value; }
	public inline var end(get_end, set_end):Float;
}