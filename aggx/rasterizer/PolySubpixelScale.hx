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

package aggx.rasterizer;
//=======================================================================================================
class PolySubpixelScale 
{
	public static inline var POLY_SUBPIXEL_SHIFT = 8;
	public static inline var POLY_SUBPIXEL_SCALE = 1 << POLY_SUBPIXEL_SHIFT;
	public static inline var POLY_SUBPIXEL_MASK = POLY_SUBPIXEL_SCALE-1;
}