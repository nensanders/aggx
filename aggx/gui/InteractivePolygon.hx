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

package aggx.gui;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.Ellipse;
import aggx.vectorial.IVertexSource;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathUtils;
import aggx.vectorial.SimplePolygonVertexSource;
import aggx.core.memory.Ref;
//=======================================================================================================
class InteractivePolygon implements IVertexSource
{
	private var _polygon:Vector<Float>;
	private var _numberOfPoints:UInt;
	private var _node:Int;
	private var _edge:Int;
	private var _vs:SimplePolygonVertexSource;
	private var _stroke:ConvStroke;
	private var _ellipse:Ellipse;
	private var _pointRadius:Float;
	private var _status:UInt;
	private var _dx:Float;
	private var _dy:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(numPoints:UInt, pointRadius:Float) 
	{
		_polygon = new Vector(numPoints * 2);
        for (i in 0...polygon.length) polygon[i] = 0.0; // TODO Needed for Javascript
		_numberOfPoints = numPoints;
		_edge = -1;
		_node = -1;
		_ellipse = new Ellipse();
		_vs = new SimplePolygonVertexSource(_polygon, numPoints, false);
		_stroke = new ConvStroke(_vs);
		_status = 0;
		_pointRadius = pointRadius;
		_dx = 0.0;
		_dy = 0.0;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void 
	{
		_status = 0;
		_stroke.rewind(0);
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt 
	{
		var cmd = PathCommands.STOP;
		var r = _pointRadius;
		if(_status == 0)
		{
			cmd = _stroke.getVertex(x, y);
			if(!PathUtils.isStop(cmd)) return cmd;
			if(_node >= 0 && _node == cast _status) r *= 1.2;
			_ellipse.init(xn(_status), yn(_status), r, r, 32);
			++_status;
		}
		cmd = _ellipse.getVertex(x, y);
		if(!PathUtils.isStop(cmd)) return cmd;
		if(_status >= _numberOfPoints) return PathCommands.STOP;
		if(_node >= 0 && _node == cast _status) r *= 1.2;
		_ellipse.init(xn(_status), yn(_status), r, r, 32);
		++_status;
		return _ellipse.getVertex(x, y);
	}
	//---------------------------------------------------------------------------------------------------
	private function checkEdge(i:UInt, x:Float, y:Float):Bool
	{
		var ret = false;

		var n1 = i;
		var n2 = (i + _numberOfPoints - 1) % _numberOfPoints;
		var x1 = xn(n1);
		var y1 = yn(n1);
		var x2 = xn(n2);
		var y2 = yn(n2);

		var dx = x2 - x1;
		var dy = y2 - y1;

		if (Math.sqrt(dx * dx + dy * dy) > 0.0000001)
		{
			var x3 = x;
			var y3 = y;
			var x4 = x3 - dy;
			var y4 = y3 + dx;

			var den = (y4-y3) * (x2-x1) - (x4-x3) * (y2-y1);
			var u1 = ((x4-x3) * (y1-y3) - (y4-y3) * (x1-x3)) / den;

			var xi = x1 + u1 * (x2 - x1);
			var yi = y1 + u1 * (y2 - y1);

			dx = xi - x;
			dy = yi - y;

			if (u1 > 0.0 && u1 < 1.0 && Math.sqrt(dx * dx + dy * dy) <= _pointRadius)
			{
				ret = true;
			}
		}
		return ret;
	}
	//---------------------------------------------------------------------------------------------------
	private function pointInPolygon(tx:Float, ty:Float):Bool
	{
		if(_numberOfPoints < 3) return false;

		var yflag0:Bool, yflag1:Bool, insideFlag:Int;
		var vtx0:Float, vty0:Float, vtx1:Float, vty1:Float;

		vtx0 = xn(_numberOfPoints - 1);
		vty0 = yn(_numberOfPoints - 1);

		// get test bit for above/below X axis
		yflag0 = (vty0 >= ty);

		vtx1 = xn(0);
		vty1 = yn(0);

		insideFlag = 0;
		var j:UInt = 1;
		while (j <= _numberOfPoints)
		{
			yflag1 = (vty1 >= ty);
			// Check if endpoints straddle (are on opposite sides) of X axis
			// (i.e. the Y's differ); if so, +X ray could intersect this edge.
			// The old test also checked whether the endpoints are both to the
			// right or to the left of the test point.  However, given the faster
			// intersection point computation used below, this test was found to
			// be a break-even proposition for most polygons and a loser for
			// triangles (where 50% or more of the edges which survive this test
			// will cross quadrants and so have to have the X intersection computed
			// anyway).  I credit Joseph Samosky with inspiring me to try dropping
			// the "both left or both right" part of my code.
			if (yflag0 != yflag1) 
			{
				// Check intersection of pgon segment with +X ray.
				// Note if >= point's X; if so, the ray hits it.
				// The division operation is avoided for the ">=" test by checking
				// the sign of the first vertex wrto the test point; idea inspired
				// by Joseph Samosky's and Mark Haigh-Hutchinson's different
				// polygon inclusion tests.
				if (((vty1 - ty) * (vtx0 - vtx1) >= (vtx1 - tx) * (vty0 - vty1)) == yflag1)
				{
					insideFlag ^= 1;
				}
			}

			// Move to the next pair of vertices, retaining info as possible.
			yflag0 = yflag1;
			vtx0 = vtx1;
			vty0 = vty1;

			var k = (j >= _numberOfPoints) ? j - _numberOfPoints : j;
			vtx1 = xn(k);
			vty1 = yn(k);
			++j;
		}
		return insideFlag != 0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function xn(n:UInt, ?val:Float):Float
	{
		if (val != null) 
		{
			_polygon[n * 2] = val;
		}
		return _polygon[n * 2];
	}
	//---------------------------------------------------------------------------------------------------
	public inline function yn(n:UInt, ?val:Float):Float
	{
		if (val != null) 
		{
			_polygon[n * 2 + 1] = val;
		}
		return _polygon[n * 2 + 1];
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_node():Int { return _node; }
	private inline function set_node(value:Int):Int { return _node = value; }
	public var node(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_close():Bool { return _vs.close; }
	private inline function set_close(value:Bool):Bool { return _vs.close = value; }
	public var close(get, set):Bool;
	//---------------------------------------------------------------------------------------------------
	private inline function get_polygon():Vector<Float> { return _polygon; }
	public var polygon(get, null):Vector<Float>;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfPoints():UInt { return _numberOfPoints; }
	public var numberOfPoints(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
}