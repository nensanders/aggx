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

package aggx.color;
//=======================================================================================================
class GradientLinearColor implements IColorFunction
{
	public var _c1:RgbaColor;
	public var _c2:RgbaColor;
	private var _size:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(c1:RgbaColor, c2:RgbaColor, size:Int = 256)
	{
		_c1 = c1;
		_c2 = c2;
		_size = size;
	}
	//---------------------------------------------------------------------------------------------------
	public function colors(c1:RgbaColor, c2:RgbaColor, size:Int = 256)
	{
		_c1 = c1;
		_c2 = c2;
		_size = size;
	}
	//---------------------------------------------------------------------------------------------------
	public function at(idx:Int):RgbaColor
	{
		return _c1.gradient(_c2, v / _size - 1);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_size():Int { return _size; }
	public var size(get, null):Int;
}