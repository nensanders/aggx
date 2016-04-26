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

package aggx.core.math;
//=======================================================================================================
import haxe.macro.Expr;
import haxe.macro.Context;
import aggx.vectorial.VertexSequence;
import aggx.core.memory.Ref;
//=======================================================================================================
class Calc 
{
	public inline static var VERTEX_DIST_EPSILON: Float = 1.0e-14;
	public inline static var INTERSECTION_EPSILON: Float = 1.0e-30;
	public inline static var PI = 3.14159265358979323846;
	public inline static var PI2 = 6.28318530717958647692;
    public inline static var PI180 = 0.01745329251994329576; // PI / 180
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
		return Math.abs(value);
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
		var dx = x2 - x1;
		var dy = y2 - y1;
		return dx * dx + dy * dy;
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

    public static inline function calcPolygonArea(st: VertexSequence): Float
    {
        var sum: Float = 0.0;
        var x: Float = st.get(0).x;
        var y: Float = st.get(0).y;
        var xs = x;
        var ys = y;

        for (i in 1...st.size)
        {
            var v = st.get(i);
            sum += x * v.y - y * v.x;
            x = v.x;
            y = v.y;
        }
        return (sum + x * ys - y * xs) * 0.5;
    }

    public static inline function deg2rad(degree: Float): Float
    {
        return degree * PI180;
    }

	inline static function intAbs(x : Int) {return ((x) < 0 ? ~(x)+1 : (x));}

	private static inline function posIntDiv(num : Int, denom : Int) : Int
	{
		var a : Int=0;
		var b : Int=0;
		var i : Int = 31; // TODO: CAREFUL: works only on int=32-bit machine!
/* Work from leftmost to rightmost bit in numerator */
		while (i >= 0)
		{
/* appends one bit from numerator to a */
			a = (a << 1) + ((num & (1 << i)) >> i);
			b = b << 1;
			if (a >= denom)
			{
				a -= denom;
				b++;
			}
			i--;
		}
		return b;
	}

	public static inline function intDivDynamic(a : Int, b : Int) : Int
	{
		var dividend = intAbs(a);
		var divisor = intAbs(b);

		if (divisor==0) return 0;

		else if (divisor > dividend)
		{
			return 0;
		}

		else if (divisor == dividend)
		{
			return 1;
		}

		else
		{
			var quotient = posIntDiv(dividend,divisor);
			if (a<0) { if (b>0) return ~quotient+1; else return quotient; }
			else { if (b<0) return ~quotient+1; else return quotient; }
		}
	}

	macro public static function intDiv(a : Expr, b : Expr) : Expr
	{

		var constA = { val : 0, isConst : false };
		var constB = { val : 0, isConst : false };

		switch(a.expr)
		{
			case EConst(c):
				{
					switch(c)
					{
						case CInt(i):
							{
								constA.val = Std.parseInt(i);
								constA.isConst = true;
							}
						case CIdent(name):
							{
								var fields = Context.getLocalClass().get().statics.get();
								var myField = fields.filter( function(f) { return f.name == name; }).shift();
								if (myField != null)
								{
									if (myField.expr() == null) throw 'Field $name had no initialization value...';
									var expr = Context.getTypedExpr(myField.expr());
									var fieldVal = switch(expr.expr)
									{
										case EConst(CInt(v)): Std.parseInt(v);
										case _: throw 'Was expecting $name to be initialized as an Int';
									}
									constA.val = fieldVal;
									constA.isConst = true;
								}
								else
								{
									constA.isConst = false;
								}
							}
						default:
					}
				}
			default:
		};

		switch(b.expr)
		{
			case EConst(c):
				{
					switch(c)
					{
						case CInt(i):
							{
								constB.val = Std.parseInt(i);
								constB.isConst = true;
							}
						case CIdent(name):
							{
								var fields = Context.getLocalClass().get().statics.get();
								var myField = fields.filter( function(f) { return f.name == name; }).shift();
								if (myField != null)
								{
									if (myField.expr() == null) throw 'Field $name had no initialization value...';
									var expr = Context.getTypedExpr(myField.expr());
									var fieldVal = switch(expr.expr)
									{
										case EConst(CInt(v)): Std.parseInt(v);
										case _: throw 'Was expecting $name to be initialized as an Int';
									}
									constB.val = fieldVal;
									constB.isConst = true;
								}
								else
								{
									constB.isConst = false;
								}
							}
						default:
					}
				}
			default:
		};

		if (constA.isConst && constB.isConst)
		{
			var returnVal : Int = cast(constA.val / constB.val);
			var e : Expr =
			{
				expr : EConst(CInt(Std.string(returnVal))),
				pos : Context.currentPos()
			};
			return e;
		}
		else
		{
			return macro Calc.intDivDynamic($a, $b);
		}

	}
}