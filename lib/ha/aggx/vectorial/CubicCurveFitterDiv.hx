package lib.ha.aggx.vectorial;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.geometry.Coord;
import lib.ha.core.memory.Ref;
import lib.ha.core.math.Calc;
//=======================================================================================================
class CubicCurveFitterDiv implements IVertexSource
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
	private var _cuspLimit:Float;
	private var _points:Vector<Coord>;
	//---------------------------------------------------------------------------------------------------
	public function new(?x1:Float, ?y1:Float, ?x2:Float, ?y2:Float, ?x3:Float, ?y3:Float, ?x4:Float, ?y4:Float) 
	{
		_angleTolerance = 0.0;
		_approximationScale = 1.0;
		_cuspLimit = 0.0;
		_count = 0;
		if (x1 != null && y1 != null && x2 != null && y2 != null && x3 != null && y3 != null && x4 != null && y4 != null) 
		{
			init(x1, y1, x2, y2, x3, y3, x4, y4);
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
	private inline function get_cuspLimit():Float { return _cuspLimit; }
	private inline function set_cuspLimit(value:Float):Float { return _cuspLimit = value; }
	public inline var cuspLimit(get_cuspLimit, set_cuspLimit):Float;	
	//---------------------------------------------------------------------------------------------------
	public function init(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):Void
	{
		_points = new Vector();
		_distanceToleranceSquare = 0.5 / _approximationScale;
		_distanceToleranceSquare *= _distanceToleranceSquare;
		bezier(x1, y1, x2, y2, x3, y3, x4, y4);
		_count = 0;
	}		
	//---------------------------------------------------------------------------------------------------
	private function recursiveBezier(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float, level:Int):Void
	{
		if(level > CURVE_RECURSION_LIMIT)
		{
			return;
		}

		var x12 = (x1 + x2) / 2;
		var y12 = (y1 + y2) / 2;
		var x23 = (x2 + x3) / 2;
		var y23 = (y2 + y3) / 2;
		var x34 = (x3 + x4) / 2;
		var y34 = (y3 + y4) / 2;
		var x123 = (x12 + x23) / 2;
		var y123 = (y12 + y23) / 2;
		var x234 = (x23 + x34) / 2;
		var y234 = (y23 + y34) / 2;
		var x1234 = (x123 + x234) / 2;
		var y1234 = (y123 + y234) / 2;

		var dx = x4-x1;
		var dy = y4-y1;

		var d2 = Calc.fabs(((x2 - x4) * dy - (y2 - y4) * dx));
		var d3 = Calc.fabs(((x3 - x4) * dy - (y3 - y4) * dx));
		var da1, da2, k;

		var c0 = (d2 > CURVE_COLLINEARITY_EPSILON ? 1 : 0) << 1;
		var c1 = d3 > CURVE_COLLINEARITY_EPSILON ? 1 : 0;
		
		switch(c0 + c1)
		{
		case 0:
			k = dx * dx + dy * dy;
			if(k == 0)
			{
				d2 = Calc.squaredDistance(x1, y1, x2, y2);
				d3 = Calc.squaredDistance(x4, y4, x3, y3);
			}
			else
			{
				k = 1 / k;
				da1 = x2 - x1;
				da2 = y2 - y1;
				d2 = k * (da1 * dx + da2 * dy);
				da1 = x3 - x1;
				da2 = y3 - y1;
				d3 = k * (da1 * dx + da2 * dy);
				if (d2 > 0 && d2 < 1 && d3 > 0 && d3 < 1)				
				{
					return;
				}
				if (d2 <= 0) d2 = Calc.squaredDistance(x2, y2, x1, y1);
				else if (d2 >= 1) d2 = Calc.squaredDistance(x2, y2, x4, y4);
				else d2 = Calc.squaredDistance(x2, y2, x1 + d2 * dx, y1 + d2 * dy);

				if (d3 <= 0) d3 = Calc.squaredDistance(x3, y3, x1, y1);
				else if (d3 >= 1) d3 = Calc.squaredDistance(x3, y3, x4, y4);
				else d3 = Calc.squaredDistance(x3, y3, x1 + d3 * dx, y1 + d3 * dy);
			}
			if(d2 > d3)
			{
				if(d2 < _distanceToleranceSquare)
				{
					_points[_points.length] = new Coord(x2, y2);
					return;
				}
			}
			else
			{
				if(d3 < _distanceToleranceSquare)
				{
					_points[_points.length] = new Coord(x3, y3);
					return;
				}
			}

		case 1:
			if (d3 * d3 <= _distanceToleranceSquare * (dx * dx + dy * dy))			
			{
				if(_angleTolerance < CURVE_ANGLE_TOLERANCE_EPSILON)
				{
					_points[_points.length] = new Coord(x23, y23);
					return;
				}

				da1 = Calc.fabs(Math.atan2(y4 - y3, x4 - x3) - Math.atan2(y3 - y2, x3 - x2));
				if(da1 >= Calc.PI) da1 = Calc.PI2 - da1;

				if(da1 < _angleTolerance)
				{
					_points[_points.length] = new Coord(x2, y2);
					_points[_points.length] = new Coord(x3, y3);
					return;
				}

				if(_cuspLimit != 0.0)
				{
					if(da1 > _cuspLimit)
					{
						_points[_points.length] = new Coord(x3, y3);
						return;
					}
				}
			}

		case 2:
			if (d2 * d2 <= _distanceToleranceSquare * (dx * dx + dy * dy))			
			{
				if(_angleTolerance < CURVE_ANGLE_TOLERANCE_EPSILON)
				{
					_points[_points.length] = new Coord(x23, y23);
					return;
				}

				da1 = Calc.fabs(Math.atan2(y3 - y2, x3 - x2) - Math.atan2(y2 - y1, x2 - x1));
				if(da1 >= Calc.PI) da1 = Calc.PI2 - da1;

				if(da1 < _angleTolerance)
				{
					_points[_points.length] = new Coord(x2, y2);
					_points[_points.length] = new Coord(x3, y3);
					return;
				}

				if(_cuspLimit != 0.0)
				{
					if(da1 > _cuspLimit)
					{
						_points[_points.length] = new Coord(x2, y2);
						return;
					}
				}
			}

		case 3:
			if ((d2 + d3) * (d2 + d3) <= _distanceToleranceSquare * (dx * dx + dy * dy))			
			{
				if(_angleTolerance < CURVE_ANGLE_TOLERANCE_EPSILON)
				{
					_points[_points.length] = new Coord(x23, y23);
					return;
				}

				k = Math.atan2(y3 - y2, x3 - x2);
				da1 = Calc.fabs(k - Math.atan2(y2 - y1, x2 - x1));
				da2 = Calc.fabs(Math.atan2(y4 - y3, x4 - x3) - k);
				if(da1 >= Calc.PI) da1 = Calc.PI2 - da1;
				if(da2 >= Calc.PI) da2 = Calc.PI2 - da2;

				if(da1 + da2 < _angleTolerance)
				{
					_points[_points.length] = new Coord(x23, y23);
					return;
				}

				if(_cuspLimit != 0.0)
				{
					if(da1 > _cuspLimit)
					{
						_points[_points.length] = new Coord(x2, y2);
						return;
					}

					if(da2 > _cuspLimit)
					{
						_points[_points.length] = new Coord(x3, y3);
						return;
					}
				}
			}
		}

		recursiveBezier(x1, y1, x12, y12, x123, y123, x1234, y1234, level + 1);
		recursiveBezier(x1234, y1234, x234, y234, x34, y34, x4, y4, level + 1);
	}
	//---------------------------------------------------------------------------------------------------
	private function bezier(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):Void
	{
		_points[_points.length] = new Coord(x1, y1);
		recursiveBezier(x1, y1, x2, y2, x3, y3, x4, y4, 0);
		_points[_points.length] = new Coord(x4, y4);
	}
	//---------------------------------------------------------------------------------------------------
	public function reset()
	{
		_points = new Vector();
		_count = 0;
	}	
	//---------------------------------------------------------------------------------------------------
	public function rewind(i:UInt):Void
	{
		_count = 0;
	}	
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		var cmd:UInt = PathCommands.STOP;
		if (_count < _points.length) 
		{
			var p = _points[_count++];
			x.value = p.x;
			y.value = p.y;
			cmd = (_count == 1) ? PathCommands.MOVE_TO : PathCommands.LINE_TO;
		}
		return cmd;
	}	
}