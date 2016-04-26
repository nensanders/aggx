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
class RectBox
{
	public var x1:Float;
	public var y1:Float;
	public var x2:Float;
	public var y2:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(?x1_:Float, ?y1_:Float, ?x2_:Float, ?y2_:Float)
	{
		x1 = x1_;
		y1 = y1_;
		x2 = x2_;
		y2 = y2_;
	}
	//---------------------------------------------------------------------------------------------------
	public static function create():RectBox
	{
		return new RectBox(0., 0., 0., 0.);
	}	
	//---------------------------------------------------------------------------------------------------
	public function init(x1_:Float, y1_:Float, x2_:Float, y2_:Float):Void
	{
		x1 = x1_;
		y1 = y1_;
		x2 = x2_;
		y2 = y2_;
	}
	//---------------------------------------------------------------------------------------------------
	public function normalize():RectBox
	{
		var t:Float;
		if (x1 > x2) { t = x1; x1 = x2; x2 = t; }		
		if (y1 > y2) { t = y1; y1 = y2; y2 = t; }		
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function clip(r:RectBox):Bool
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
	public function hitTest(x:Float, y:Float):Bool
	{
		return (x >= x1 && x <= x2 && y >= y1 && y <= y2);
	}
}