package lib.ha.aggx.vectorial;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.geometry.Coord;
import lib.ha.core.memory.Ref;
import lib.ha.core.math.Calc;
//=======================================================================================================
class QuadCurveFitterDiv implements IVertexSource
{
	private static var CURVE_DISTANCE_EPSILON = 1e-30;
	private static var CURVE_COLLINEARITY_EPSILON = 1e-30;
	private static var CURVE_ANGLE_TOLERANCE_EPSILON = 0.01;
	private static var CURVE_RECURSION_LIMIT = 32;
	//---------------------------------------------------------------------------------------------------
	private var _approximationScale:Float;
	private var _distanceToleranceSquare:Float;
	private var _angleTolerance:Float;
	private var _count:UInt;
	private var _points:Vector<Coord>;
	//---------------------------------------------------------------------------------------------------
	public function new(?x1:Float, ?y1:Float, ?x2:Float, ?y2:Float, ?x3:Float, ?y3:Float) 
	{
		_angleTolerance = 0.0;
		_approximationScale = 1.0;
		_count = 0;
		if (x1 != null && y1 != null && x2 != null && y2 != null && x3 != null && y3 != null) 
		{
			init(x1, y1, x2, y2, x3, y3);
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return _approximationScale; }
	private inline function set_approximationScale(value:Float):Float { return _approximationScale = value; }
	public inline var approximationScale(get_approximationScale, set_approximationScale):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_angleTolerance():Float { return _angleTolerance; }
	private inline function set_angleTolerance(value:Float):Float { return _angleTolerance = value; }
	public inline var angleTolerance(get_angleTolerance, set_angleTolerance):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_cuspLimit():Float { return 0.0; }
	private inline function set_cuspLimit(value:Float):Float { return value; }
	public inline var cuspLimit(get_cuspLimit, set_cuspLimit):Float;		
	//---------------------------------------------------------------------------------------------------
	public function init(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Void
	{
		_points = new Vector();
		_distanceToleranceSquare = 0.5 / _approximationScale;
		_distanceToleranceSquare *= _distanceToleranceSquare;
		bezier(x1, y1, x2, y2, x3, y3);
		_count = 0;	
	}
	//---------------------------------------------------------------------------------------------------
	private function bezier(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float)
	{
		_points[_points.length] = new Coord(x1, y1);
		recursiveBezier(x1, y1, x2, y2, x3, y3, 0);
		_points[_points.length] = new Coord(x3, y3);
	}
	//---------------------------------------------------------------------------------------------------
	private function recursiveBezier(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, level:Int):Void 
	{
		if(level > CURVE_RECURSION_LIMIT)
		{
			return;
		}

		var x12   = (x1 + x2) / 2;
		var y12   = (y1 + y2) / 2;
		var x23   = (x2 + x3) / 2;
		var y23   = (y2 + y3) / 2;
		var x123  = (x12 + x23) / 2;
		var y123  = (y12 + y23) / 2;

		var dx = x3-x1;
		var dy = y3-y1;
		var d = Calc.fabs(((x2 - x3) * dy - (y2 - y3) * dx));
		var da:Float;

		if(d > CURVE_COLLINEARITY_EPSILON)
		{
			if (d * d <= _distanceToleranceSquare * (dx * dx + dy * dy))			
			{
				if(_angleTolerance < CURVE_ANGLE_TOLERANCE_EPSILON)
				{
					_points[_points.length] = new Coord(x123, y123);
					return;
				}

				da = Calc.fabs(Math.atan2(y3 - y2, x3 - x2) - Math.atan2(y2 - y1, x2 - x1));
				if (da >= Calc.PI) da = Calc.PI2 - da;

				if(da < _angleTolerance)
				{
					_points[_points.length] = new Coord(x123, y123);
					return;
				}
			}
		}
		else
		{
			da = dx * dx + dy * dy;
			if(da == 0)
			{
				d = Calc.squaredDistance(x1, y1, x2, y2);
			}
			else
			{
				d = ((x2 - x1) * dx + (y2 - y1) * dy) / da;
				if(d > 0 && d < 1)
				{
					return;
				}
				if (d <= 0) d = Calc.squaredDistance(x2, y2, x1, y1);
				else if (d >= 1) d = Calc.squaredDistance(x2, y2, x3, y3);
				else d = Calc.squaredDistance(x2, y2, x1 + d * dx, y1 + d * dy);
			}
			if(d < _distanceToleranceSquare)
			{
				_points[_points.length] = new Coord(x2, y2);
				return;
			}
		}

		recursiveBezier(x1, y1, x12, y12, x123, y123, level + 1);
		recursiveBezier(x123, y123, x23, y23, x3, y3, level + 1);
	}
	//---------------------------------------------------------------------------------------------------
	public function reset()
	{
		_points = new Vector();
		_count = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void
	{
		_count = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		if(_count >= _points.length) return PathCommands.STOP;
		var p = _points[_count++];
		x.value = p.x;
		y.value = p.y;
		return (_count == 1) ? PathCommands.MOVE_TO : PathCommands.LINE_TO;		
	}
}