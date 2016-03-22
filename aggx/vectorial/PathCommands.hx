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
class PathCommands 
{
	public inline static var STOP = 0;
	public inline static var MOVE_TO = 1;
	public inline static var LINE_TO = 2;
	public inline static var CURVE3 = 3;
	public inline static var CURVE4 = 4;
	public inline static var CURVEN = 5;
	public inline static var CATROM = 6;
	public inline static var UBSPLINE = 7;
	public inline static var END_POLY = 0x0F;
	public inline static var MASK = 0x0F;
}