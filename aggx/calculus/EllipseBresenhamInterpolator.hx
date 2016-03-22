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
class EllipseBresenhamInterpolator 
{
	private var _rx2:Int;
	private var _ry2:Int;
	private var _twoRx2:Int;
	private var _twoRy2:Int;
	private var _dx:Int;
	private var _dy:Int;
	private var _incX:Int;
	private var _incY:Int;
	private var _curF:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(rx:Int, ry:Int) 
	{
		_rx2 = rx * rx;
		_ry2 = ry * ry;
		_twoRx2 = _rx2 << 1;
		_twoRy2 = _ry2 << 1;
		_dx = 0;
		_dy = 0;
		_incX = 0;
		_incY = -ry * _twoRx2;
		_curF = 0;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_dx():Int { return _dx; }
	public var dx(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_dy():Int { return _dy; }
	public var dy(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	public function op_inc():Void
	{
		var  mx, my, mxy, min_m;
		var  fx, fy, fxy;

		mx = fx = _curF + _incX + _ry2;
		if(mx < 0) mx = -mx;

		my = fy = _curF + _incY + _rx2;
		if(my < 0) my = -my;

		mxy = fxy = _curF + _incX + _ry2 + _incY + _rx2;
		if(mxy < 0) mxy = -mxy;

		min_m = mx;
		var flag = true;

		if(min_m > my)
		{
			min_m = my;
			flag = false;
		}

		_dx = _dy = 0;

		if(min_m > mxy)
		{
			_incX += _twoRy2;
			_incY += _twoRx2;
			_curF = fxy;
			_dx = 1;
			_dy = 1;
			return;
		}

		if(flag)
		{
			_incX += _twoRy2;
			_curF = fx;
			_dx = 1;
			return;
		}

		_incY += _twoRx2;
		_curF = fy;
		_dy = 1;
	}
}