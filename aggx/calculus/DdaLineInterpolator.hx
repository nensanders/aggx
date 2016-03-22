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
class DdaLineInterpolator 
{
	private inline static var FRACTION_SHIFT = 0;
	private inline static var Y_SHIFT = 8;
	//---------------------------------------------------------------------------------------------------
	private var _y:Int;
	private var _inc:Int;
	private var _dy:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(y1:Int, y2:Int, count:Int) 
	{
		_y = y1;
		_inc = ((y2 - y1) << FRACTION_SHIFT) / count;
		_dy = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function y():Int { return _y + (_dy >> (FRACTION_SHIFT - Y_SHIFT)); }
	//---------------------------------------------------------------------------------------------------
	public function dy():Int { return _dy; }
	//---------------------------------------------------------------------------------------------------
	public function op_inc():Void
	{
		_dy += _inc;
	}
	//---------------------------------------------------------------------------------------------------
	public function op_dec():Void
	{
		_dy -= _inc;
	}
	//---------------------------------------------------------------------------------------------------
	public function op_minus_eq(n:Int):Void
	{
		_dy -= _inc * n;
	}
	//---------------------------------------------------------------------------------------------------
	public function op_plus_eq(n:Int):Void
	{
		_dy += _inc * n;
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_y():Int { return _y + (_dy >> (FRACTION_SHIFT - Y_SHIFT)); }
	public var y(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_dy():Int { return _dy; }
	public var dy(get, null):Int;
}