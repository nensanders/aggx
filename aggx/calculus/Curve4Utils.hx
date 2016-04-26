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

package aggx.calculus;
//=======================================================================================================
import haxe.ds.Vector;
//=======================================================================================================
class Curve4Utils 
{
	public static function catromToBezier(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):Vector<Float>
	{
		// Trans. matrix Catmull-Rom to Bezier
		//
		//  0       1       0       0
		//  -1/6    1       1/6     0
		//  0       1/6     1       -1/6
		//  0       0       1       0
		//
		var ret = new Vector<Float>(8);
		
		ret[0] = x2;
		ret[1] = y2;
		ret[2] = (-x1 + 6 * x2 + x3) / 6;
		ret[3] = (-y1 + 6 * y2 + y3) / 6;
		ret[4] = (x2 + 6 * x3 - x4) / 6;
		ret[5] = (y2 + 6 * y3 - y4) / 6;
		ret[6] = x3;
		ret[7] = y3;
		
		return ret;
	}
	//---------------------------------------------------------------------------------------------------
	public static function catromToBezierP(pnts:Vector<Float>):Vector<Float>
	{
		return catromToBezier(pnts[0], pnts[1], pnts[2], pnts[3], pnts[4], pnts[5], pnts[6], pnts[7]);
	}
	//---------------------------------------------------------------------------------------------------
	public static function uBSplineToBezier(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):Vector<Float>
	{
		// Trans. matrix Uniform BSpline to Bezier
		//
		//  1/6     4/6     1/6     0
		//  0       4/6     2/6     0
		//  0       2/6     4/6     0
		//  0       1/6     4/6     1/6
		//
		var ret = new Vector<Float>(8);

		ret[0] = (x1 + 4 * x2 + x3) / 6;
		ret[1] = (y1 + 4 * y2 + y3) / 6;
		ret[2] = (4 * x2 + 2 * x3) / 6;
		ret[3] = (4 * y2 + 2 * y3) / 6;
		ret[4] = (2 * x2 + 4 * x3) / 6;
		ret[5] = (2 * y2 + 4 * y3) / 6;
		ret[6] = (x2 + 4 * x3 + x4) / 6;
		ret[7] = (y2 + 4 * y3 + y4) / 6;
		
		return ret;
	}
	//---------------------------------------------------------------------------------------------------
	public static function uBSplineToBezierP(pnts:Vector<Float>):Vector<Float>
	{
		return uBSplineToBezier(pnts[0], pnts[1], pnts[2], pnts[3], pnts[4], pnts[5], pnts[6], pnts[7]);
	}
	//---------------------------------------------------------------------------------------------------
	public static function hermiteToBezier(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):Vector<Float>
	{
		// Trans. matrix Hermite to Bezier
		//
		//  1       0       0       0
		//  1       0       1/3     0
		//  0       1       0       -1/3
		//  0       1       0       0
		//
		var ret = new Vector<Float>(8);
		
		ret[0] = x1;
		ret[1] = y1;
		ret[2] = (3 * x1 + x3) / 3;
		ret[3] = (3 * y1 + y3) / 3;
		ret[4] = (3 * x2 - x4) / 3;
		ret[5] = (3 * y2 - y4) / 3;
		ret[6] = x2;
		ret[7] = y2;
		
		return ret;
	}
	//---------------------------------------------------------------------------------------------------
	public static function hermiteToBezierP(pnts:Vector<Float>):Vector<Float>
	{
		return hermiteToBezier(pnts[0], pnts[1], pnts[2], pnts[3], pnts[4], pnts[5], pnts[6], pnts[7]);
	}	
}