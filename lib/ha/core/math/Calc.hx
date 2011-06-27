package lib.ha.core.math;
//=======================================================================================================
import lib.ha.core.memory.Ref;
//=======================================================================================================
class Calc 
{
	public inline static var VERTEX_DIST_EPSILON = 1e-14;
	public inline static var INTERSECTION_EPSILON = 1.0e-30;
	public inline static var PI = 3.14159265358979323846;
	public inline static var PI2 = 6.28318530717958647692;
	//---------------------------------------------------------------------------------------------------
	public static inline function min(value1:Int, value2:Int):Int
	{
		return (value1 < value2) ? value1 : value2;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function umin(value1:UInt, value2:UInt):UInt
	{
		return (value1 < value2) ? value1 : value2;
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function max(value1:Int, value2:Int):Int
	{
		return (value1 > value2) ? value1 : value2;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function umax(value1:UInt, value2:UInt):UInt
	{
		return (value1 > value2) ? value1 : value2;
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function int(value:Bool):Int
	{
		return value ? 1 : 0;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function abs(value:Int):Int
	{
		return value >= 0 ? value: -value;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function uabs(value:UInt):UInt
	{
		return value >= 0 ? value: -value;
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function fabs(value:Float):Float
	{
		return value < 0 ? -value : value;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function iround(value:Float):Int
	{
		return Std.int((value < 0.0) ? value - 0.5 : value + 0.5);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function sbyte(value:Int):Int
	{
		return (value << 24) >> 24;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function sshort(value:Int):Int
	{
		return (value << 16) >> 16;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function distance(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		var __dx = x2 - x1;
		var __dy = y2 - y1;
		return Math.sqrt(__dx * __dx + __dy * __dy);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function squaredDistance(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		var __dx = x2 - x1;
		var __dy = y2 - y1;
		return __dx * __dx + __dy * __dy;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function crossProduct(x1:Float, y1:Float, x2:Float, y2:Float, x:Float, y:Float):Float
	{
		return (x - x2) * (y2 - y1) - (y - y2) * (x2 - x1);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function intersection(ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float, dx:Float, dy:Float, x:FloatRef, y:FloatRef):Bool
	{
		var __res = false;
		var __num = (ay - cy) * (dx - cx) - (ax - cx) * (dy - cy);
		var __den = (bx - ax) * (dy - cy) - (by - ay) * (dx - cx);
		if (!(fabs(__den) < INTERSECTION_EPSILON))
		{
			var r = __num / __den;
			x.value = ax + r * (bx - ax);
			y.value = ay + r * (by - ay);
			__res = true;
		}		
		return __res;
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function isEqualEps(v1:Float, v2:Float, epsilon:Float):Bool
	{
		return Calc.fabs(v1 - v2) <= epsilon;
	}	
}