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
class RgbaColorF 
{
	public var r:Float;
	public var g:Float;
	public var b:Float;
	public var a:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(r_:Float, g_:Float, b_:Float, a_:Float=1.0)
	{
		r = r_;
		g = g_;
		b = b_;
		a = a_;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function toRgbaColor():RgbaColor
	{
		return new RgbaColor(Std.int(r * RgbaColor.BASE_MASK), Std.int(g * RgbaColor.BASE_MASK), Std.int(b * RgbaColor.BASE_MASK), Std.int(a * RgbaColor.BASE_MASK));
	}
}