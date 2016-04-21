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

import haxe.ds.Vector;

//=======================================================================================================
class ColorArray implements IColorFunction
{
	private var _colors:Vector<RgbaColor>;
	//---------------------------------------------------------------------------------------------------
	public function new(sz:UInt)
	{
		_colors = new Vector(sz);
	}
	//---------------------------------------------------------------------------------------------------
	public function get(idx:UInt):RgbaColor
	{
		if (idx >= _colors.length)
		{
			idx = _colors.length - 1;
		}
		return RgbaColor.fromRgbaColor(_colors[idx]);
	}
	//---------------------------------------------------------------------------------------------------
	public function set(c:RgbaColor, idx:Int):Void
	{
		_colors[idx] = c;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_size():UInt { return _colors.length; }
	public var size(get, null):UInt;
}
