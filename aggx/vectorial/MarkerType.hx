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

package aggx.vectorial;
//=======================================================================================================
class MarkerType 
{
	public static inline var SQUARE = 0;
	public static inline var DIAMOND = 1;
	public static inline var CIRCLE = 2;
	public static inline var CROSSED_CIRCLE = 3;
	public static inline var SEMIELLIPSE_LEFT = 4;
	public static inline var SEMIELLIPSE_RIGHT = 5;
	public static inline var SEMIELLIPSE_UP = 6;
	public static inline var SEMIELLIPSE_DOWN = 7;
	public static inline var TRIANGLE_LEFT = 8;
	public static inline var TRIANGLE_RIGHT = 9;
	public static inline var TRIANGLE_UP = 10;
	public static inline var TRIANGLE_DOWN = 11;
	public static inline var FOUR_RAYS = 12;
	public static inline var CROSS = 13;
	public static inline var X = 14;
	public static inline var DASH = 15;
	public static inline var DOT = 16;
	public static inline var PIXEL = 17;

	public static inline var END_OF_MARKERS = -1;
}