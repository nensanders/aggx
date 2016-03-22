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
import aggx.core.geometry.Coord;
//=======================================================================================================
class ContourSegment
{
	public static inline var MOVE = 0;
	public static inline var LINE = 1;
	public static inline var CURVE = 2;
	//---------------------------------------------------------------------------------------------------
	private var _points:Array<Coord>;
	private var _numberOfPoints:UInt;
	private var _type:Int;
	//---------------------------------------------------------------------------------------------------
	private function new()
	{
		_points = new Array();
		_numberOfPoints = 0;
		_type = -1;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function createFirst():ContourSegment
	{
		var seg = new ContourSegment();
		seg._type = MOVE;
		return seg;
	}
	//---------------------------------------------------------------------------------------------------
	public function createNext():ContourSegment
	{		
		return new ContourSegment();
	}
	//---------------------------------------------------------------------------------------------------
	public function addPoint(x:Float, y:Float)
	{
		var newPoint = new Coord(x, y);
		_points[_numberOfPoints] = newPoint;
		++_numberOfPoints;
		if (_type != MOVE)
		{
			_type = _numberOfPoints > 1 ? CURVE : LINE;
		}		
	}
	//---------------------------------------------------------------------------------------------------
	public function getPoint(idx:UInt):Coord
	{
		return _points[idx];
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_type():Int { return _type; }
	public var type(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfPoints():UInt { return _numberOfPoints; }
	public var numberOfPoints(get, null):UInt;
}