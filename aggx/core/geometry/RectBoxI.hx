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

package aggx.core.geometry;
//=======================================================================================================
class RectBoxI
{
	public var x1:Int;
	public var y1:Int;
	public var x2:Int;
	public var y2:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(?x1_:Int, ?y1_:Int, ?x2_:Int, ?y2_:Int)
	{
		x1 = x1_;
		y1 = y1_;
		x2 = x2_;
		y2 = y2_;
	}
	//---------------------------------------------------------------------------------------------------
	public static function create():RectBoxI
	{
		return new RectBoxI(0, 0, 0, 0);
	}
	//---------------------------------------------------------------------------------------------------
	public function init(x1_:Int, y1_:Int, x2_:Int, y2_:Int):Void
	{
		x1 = x1_;
		y1 = y1_;
		x2 = x2_;
		y2 = y2_;
	}
	//---------------------------------------------------------------------------------------------------
	public function normalize():RectBoxI
	{
		var t:Int;
		if (x1 > x2) { t = x1; x1 = x2; x2 = t; }		
		if (y1 > y2) { t = y1; y1 = y2; y2 = t; }		
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function clip(r:RectBoxI):Bool
	{
		if (x2 > r.x2) x2 = r.x2;
		if (y2 > r.y2) y2 = r.y2;
		if (x1 < r.x1) x1 = r.x1;
		if (y1 < r.y1) y1 = r.y1;
		return x1 <= x2 && y1 <= y2;
	}
	//---------------------------------------------------------------------------------------------------
	public function isValid():Bool
	{
		return x1 <= x2 && y1 <= y2;
	}
	//---------------------------------------------------------------------------------------------------
	public function hitTest(x:Int, y:Int):Bool
	{
		return (x >= x1 && x <= x2 && y >= y1 && y <= y2);
	}
}