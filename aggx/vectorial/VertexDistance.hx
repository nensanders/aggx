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
import aggx.core.math.Calc;
//=======================================================================================================
class VertexDistance implements IDistanceProvider
{
	public var x:Float;
	public var y:Float;
	public var dist:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(?x_:Float, ?y_:Float)
	{
		x = x_;
		y = y_;
		dist = 0.0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function calc(val:IDistanceProvider):Bool
	{
		var ret = (dist = Calc.distance(x, y, val.x, val.y)) > Calc.VERTEX_DIST_EPSILON;
		if(!ret) dist = 1.0 / Calc.VERTEX_DIST_EPSILON;
		return ret;
	}
}