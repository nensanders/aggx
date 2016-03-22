//----------------------------------------------------------------------------
// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)
//
// Permission to copy, use, modify, sell and distribute this software 
// is granted provided this copyright notice appears in all copies. 
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//
// Haxe port by: Hypeartist hypeartist@gmail.com
// Copyright (C) 2011 https://code.google.com/p/aggx
//
//----------------------------------------------------------------------------
// Contact: mcseem@antigrain.com
//          mcseemagg@yahoo.com
//          http://www.antigrain.com
//----------------------------------------------------------------------------

package aggx.calculus;
//=======================================================================================================
import haxe.ds.Vector;
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
	public var lft(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_rem():Int { return _rem; }
	public var rem(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_mod():Int { return _mod; }
	public var mod(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_y():Int { return _y; }
	public var y(get, null):Int;
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