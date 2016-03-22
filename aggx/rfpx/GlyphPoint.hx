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

package aggx.rfpx;
//=======================================================================================================
class GlyphPoint 
{
	public static var FT_CURVE_TAG_ON = 1;
	public static var FT_CURVE_TAG_CONIC = 0;
	public static var FT_CURVE_TAG_CUBIC = 2;
	public static function FT_CURVE_TAG(flag:UInt):Bool { return (flag & 3) != 0; }
	//---------------------------------------------------------------------------------------------------
	public var x:Int;
	public var y:Int;
	public var tag:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(_x:Int, _y:Int, _tag:Int)
	{
		x = _x;
		y = _y;
		tag = _tag;
	}
}