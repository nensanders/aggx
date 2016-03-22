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
class LineBresenhamInterpolator 
{
	public static var SUBPIXEL_SHIFT = 8;
	public static var SUBPIXEL_SCALE = 1 << SUBPIXEL_SHIFT;
	public static var SUBPIXEL_MASK = SUBPIXEL_SCALE-1;
	//---------------------------------------------------------------------------------------------------
	private var _x1LR:Int;
	private var _y1LR:Int;
	private var _x2LR:Int;
	private var _y2LR:Int;
	private var _ver:Bool;
	private var _length:UInt;
	private var _increment:Int;
	private var _interpolator:Dda2LineInterpolator;
	//---------------------------------------------------------------------------------------------------
	public function new(x1:Int, y1:Int, x2:Int, y2:Int) 
	{
		_x1LR = lineLR(x1);
		_y1LR = lineLR(y1);
		_x2LR = lineLR(x2);
		_y2LR = lineLR(y2);
		_ver = Math.abs(_x2LR - _x1LR) < Math.abs(_y2LR - _y1LR);		
		_length = _ver ? Math.abs(_y2LR - _y1LR) : Math.abs(_x2LR - _x1LR);
		_increment = _ver ? ((y2 > y1) ? 1 : -1) : ((x2 > x1) ? 1 : -1);
		_interpolator = new Dda2LineInterpolator(_ver ? x1 : y1, _ver ? x2 : y2, _length);
	}
	var _x2HR:Int;
	//---------------------------------------------------------------------------------------------------
	public static function lineLR(v:Int) { return v >> SUBPIXEL_SHIFT; }
	//---------------------------------------------------------------------------------------------------
	public function hstep():Void
	{
		++_interpolator;
		_x1LR += _increment;
	}
	//---------------------------------------------------------------------------------------------------
	public function vstep():Void
	{
		++_interpolator;
		_y1LR += _increment;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_isVertical():Bool { return _ver; }
	public var isVertical(get, null):Bool;
	//---------------------------------------------------------------------------------------------------
	private inline function get_length():UInt { return _length; }
	public var length(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_increment():Int { return _increment; }
	public var increment(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_x1():Int { return _x1LR; }
	public var x1(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_y1():Int { return _y1LR; }
	public var y1(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_x2():Int { return lineLR(_interpolator.y); }
	public var x2(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_y2():Int { return lineLR(_interpolator.y); }
	public var y2(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_x2HR():Int { return _interpolator.y; }
	public var x2HR(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_y2HR():Int { return _interpolator.y; }
	public var y2HR(get, null):Int;
}