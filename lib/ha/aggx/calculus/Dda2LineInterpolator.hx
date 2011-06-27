package lib.ha.aggx.calculus;
//=======================================================================================================
import flash.Vector;
//=======================================================================================================
class Dda2LineInterpolator 
{
	private static var SAVE_SIZE = 2;
	//---------------------------------------------------------------------------------------------------
	private var _cnt:Int;
	private var _lft:Int;
	private var _rem:Int;
	private var _mod:Int;
	private var _y:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(y1:Int, y2:Int, count:Int, back:Bool = false) 
	{
		_cnt = count <= 0 ? 1 : count;
		_lft = Std.int((y2 - y1) / _cnt);
		_rem = (y2 - y1) % _cnt;
		_mod = _rem;
		_y = y1;
		if(_mod <= 0)
		{
			_mod += count;
			_rem += count;
			_lft--;
		}
		if (!back) 
		{
			_mod -= count;
		}		
	}
	//---------------------------------------------------------------------------------------------------
	public static function backAdjusted(y:Int, count:Int):Dda2LineInterpolator
	{
		return new Dda2LineInterpolator(0, y, count);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_lft():Int { return _lft; }
	public inline var lft(get_lft, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_rem():Int { return _rem; }
	public inline var rem(get_rem, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_mod():Int { return _mod; }
	public inline var mod(get_mod, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_y():Int { return _y; }
	public inline var y(get_y, null):Int;
	//---------------------------------------------------------------------------------------------------
	public function op_inc():Void
	{
		_mod += _rem;
		_y += _lft;
		if(_mod > 0)
		{
			_mod -= _cnt;
			_y++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function op_dec():Void
	{
		if(_mod <= _rem)
		{
			_mod += _cnt;
			_y--;
		}
		_mod -= _rem;
		_y -= _lft;
	}
	//---------------------------------------------------------------------------------------------------
	public function save(data:Vector<Int>):Void
	{
		data[0] = _mod;
		data[1] = _y;
	}
	//---------------------------------------------------------------------------------------------------
	public function load(data:Vector<Int>):Void
	{
		_mod = data[0];
		_y = data[1];
	}	
	//---------------------------------------------------------------------------------------------------
	public function adjustForward():Void
	{
		_mod -= _cnt;
	}
	//---------------------------------------------------------------------------------------------------
	public function adjustBackward():Void
	{
		_mod += _cnt;
	}	
}