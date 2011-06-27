package lib.ha.rfpx;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.geometry.Coord;
//=======================================================================================================
class ContourSegment
{
	public static inline var MOVE = 0;
	public static inline var LINE = 1;
	public static inline var CURVE = 2;
	//---------------------------------------------------------------------------------------------------
	private var _points:Vector<Coord>;
	private var _numberOfPoints:UInt;
	private var _type:Int;
	//---------------------------------------------------------------------------------------------------
	private function new()
	{
		_points = new Vector();
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
	public inline var type(get_type, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfPoints():UInt { return _numberOfPoints; }
	public inline var numberOfPoints(get_numberOfPoints, null):UInt;
}