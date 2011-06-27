package lib.ha.aggx.vectorial.generators;
//=======================================================================================================
import lib.ha.aggx.vectorial.PathCommands;
import lib.ha.core.memory.Ref;
//=======================================================================================================
class VpgenSegmentator implements IPolygonGenerator
{
	private var _approximationScale:Float;
	private var _x1:Float;
	private var _y1:Float;
	private var _dx:Float;
	private var _dy:Float;
	private var _dl:Float;
	private var _ddl:Float;
	private var _cmd:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_approximationScale = 1.0;
	}
	//---------------------------------------------------------------------------------------------------
	public function reset():Void 
	{
		_cmd = PathCommands.STOP;
	}
	var _autoUnclose:Bool;
	var _autoClose:Bool;
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt 
	{
		if(_cmd == PathCommands.STOP) return PathCommands.STOP;

		var cmd = _cmd;
		_cmd = PathCommands.LINE_TO;
		if(_dl >= 1.0 - _ddl)
		{
			_dl = 1.0;
			_cmd = PathCommands.STOP;
			x.value = _x1 + _dx;
			y.value = _y1 + _dy;
			return cmd;
		}
		x.value = _x1 + _dx * _dl;
		y.value = _y1 + _dy * _dl;
		_dl += _ddl;
		return cmd;
	}
	//---------------------------------------------------------------------------------------------------
	public function moveTo(x:Float, y:Float):Void 
	{
		_x1 = x;
		_y1 = y;
		_dx = 0.0;
		_dy = 0.0;
		_dl = 2.0;
		_ddl = 2.0;
		_cmd = PathCommands.MOVE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public function lineTo(x:Float, y:Float):Void 
	{
		_x1 += _dx;
		_y1 += _dy;
		_dx = x - _x1;
		_dy = y - _y1;
		var len = Math.sqrt(_dx * _dx + _dy * _dy) * _approximationScale;
		if(len < 1e-30) len = 1e-30;
		_ddl = 1.0 / len;
		_dl = (_cmd == PathCommands.MOVE_TO) ? 0.0 : _ddl;
		if(_cmd == PathCommands.STOP) _cmd = PathCommands.LINE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximation_scale():Float { return _approximationScale; }
	private inline function set_approximation_scale(value:Float):Float { return _approximationScale = value; }
	public inline var approximationScale(get_approximation_scale, set_approximation_scale):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_autoUnclose():Bool { return false; }
	public inline var autoUnclose(get_autoUnclose, null):Bool;
	//---------------------------------------------------------------------------------------------------
	private inline function get_autoClose():Bool { return false; }
	public inline var autoClose(get_autoClose, null):Bool;
	
}