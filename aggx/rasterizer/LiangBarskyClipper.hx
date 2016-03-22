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

package aggx.rasterizer;
//=======================================================================================================
import aggx.core.geometry.RectBox;
import aggx.core.memory.FloatStorage;
import aggx.core.memory.Ref;
import aggx.core.math.Calc;
//=======================================================================================================
class LiangBarskyClipper
{
	public static inline var CLIPPING_FLAGS_X1_CLIPPED = 4;
	public static inline var CLIPPING_FLAGS_X2_CLIPPED = 1;
	public static inline var CLIPPING_FLAGS_Y1_CLIPPED = 8;
	public static inline var CLIPPING_FLAGS_Y2_CLIPPED = 2;
	public static inline var CLIPPING_FLAGS_X_CLIPPED = CLIPPING_FLAGS_X1_CLIPPED | CLIPPING_FLAGS_X2_CLIPPED;
	public static inline var CLIPPING_FLAGS_Y_CLIPPED = CLIPPING_FLAGS_Y1_CLIPPED | CLIPPING_FLAGS_Y2_CLIPPED;
	//---------------------------------------------------------------------------------------------------
	public static inline function getClippingFlags(x:Float, y:Float, clippingBox:RectBox):Int
    {
        return  Calc.int(x > clippingBox.x2) | (Calc.int(y > clippingBox.y2) << 1) | (Calc.int(x < clippingBox.x1) << 2) | (Calc.int(y < clippingBox.y1) << 3);
    }
	//---------------------------------------------------------------------------------------------------
	public static inline function getClippingFlagsX(x:Float, clippingBox:RectBox):Int
	{
		return  Calc.int(x > clippingBox.x2) | (Calc.int(x < clippingBox.x1) << 2);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getClippingFlagsY(y:Float, clippingBox:RectBox):Int
	{
		return (Calc.int(y > clippingBox.y2) << 1) | (Calc.int(y < clippingBox.y1) << 3);
	}
	//---------------------------------------------------------------------------------------------------
	public static function clip(x1:Float, y1:Float, x2:Float, y2:Float, clippingBox:RectBox, x:FloatStorage, y:FloatStorage):Int
	{		
		var nearzero = 1e-30;

		var deltax:Float = x2 - x1;
		var deltay:Float = y2 - y1;
		var xin:Float;
		var xout:Float;
		var yin:Float;
		var yout:Float;
		var tinx:Float;
		var tiny:Float;
		var toutx:Float;
		var touty:Float;
		var tin1:Float;
		var tin2:Float;
		var tout1:Float;
		
		var np:Int = 0;

		if(deltax == 0.0)
		{
			deltax = (x1 > clippingBox.x1) ? -nearzero : nearzero;
		}

		if(deltay == 0.0)
		{
			deltay = (y1 > clippingBox.y1) ? -nearzero : nearzero;
		}

		if(deltax > 0.0)
		{
			xin  = clippingBox.x1;
			xout = clippingBox.x2;
		}
		else
		{
			xin  = clippingBox.x2;
			xout = clippingBox.x1;
		}

		if(deltay > 0.0)
		{
			yin  = clippingBox.y1;
			yout = clippingBox.y2;
		}
		else
		{
			yin  = clippingBox.y2;
			yout = clippingBox.y1;
		}

		tinx = (xin - x1) / deltax;
		tiny = (yin - y1) / deltay;

		if (tinx < tiny)
		{
			tin1 = tinx;
			tin2 = tiny;
		}
		else
		{
			tin1 = tiny;
			tin2 = tinx;
		}

		if(tin1 <= 1.0)
		{
			if(0.0 < tin1)
			{
				x.data[x.offset++] = xin;
				y.data[y.offset++] = yin;
				++np;
			}

			if(tin2 <= 1.0)
			{
				toutx = (xout - x1) / deltax;
				touty = (yout - y1) / deltay;

				tout1 = (toutx < touty) ? toutx : touty;

				if(tin2 > 0.0 || tout1 > 0.0)
				{
					if(tin2 <= tout1)
					{
						if(tin2 > 0.0)
						{
							if(tinx > tiny)
							{
								x.data[x.offset++] = xin;
								y.data[y.offset++] = y1 + tinx * deltay;
							}
							else
							{
								x.data[x.offset++] = x1 + tiny * deltax;
								y.data[y.offset++] = yin;
							}
							++np;
						}

						if(tout1 < 1.0)
						{
							if(toutx < touty)
							{
								x.data[x.offset++] = xout;
								y.data[y.offset++] = y1 + toutx * deltay;
							}
							else
							{
								x.data[x.offset++] = x1 + touty * deltax;
								y.data[y.offset++] = yout;
							}
						}
						else
						{
							x.data[x.offset++] = x2;
							y.data[y.offset++] = y2;
						}
						++np;
					}
					else
					{
						if(tinx > tiny)
						{
							x.data[x.offset++] = xin;
							y.data[y.offset++] = yout;
						}
						else
						{
							x.data[x.offset++] = xout;
							y.data[y.offset++] = yin;
						}
						++np;
					}
				}
			}
		}
		
		return np;
	}
	//---------------------------------------------------------------------------------------------------
	public static function clipMovePoint(x1:Float, y1:Float, x2:Float, y2:Float, clippingBox:RectBox, x:FloatRef, y:FloatRef, flags:Int):Bool
	{
		var bound:Float;
		
		if ((flags & CLIPPING_FLAGS_X_CLIPPED) != 0)		
		{
			if(x1 == x2)
			{
				return false;
			}
			bound = ((flags & CLIPPING_FLAGS_X1_CLIPPED)!=0) ? clippingBox.x1 : clippingBox.x2;
			y.value = (bound - x1) * (y2 - y1) / (x2 - x1) + y1;
			x.value = bound;
		}

		flags = getClippingFlagsY(y.value, clippingBox);
		if ((flags & CLIPPING_FLAGS_Y_CLIPPED) != 0)		
		{
			if(y1 == y2)
			{			
				return false;
			}
			bound = ((flags & CLIPPING_FLAGS_Y1_CLIPPED)!=0) ? clippingBox.y1 : clippingBox.y2;
			x.value = (bound - y1) * (x2 - x1) / (y2 - y1) + x1;
			y.value = bound;
		}
		return true;
	}
	//---------------------------------------------------------------------------------------------------
	public static function clipLineSegment(x1:FloatRef , y1:FloatRef, x2:FloatRef, y2:FloatRef, clippingBox:RectBox):Int
	{
		var f1 = getClippingFlags(x1.value, y1.value, clippingBox);
		var f2 = getClippingFlags(x2.value, y2.value, clippingBox);
		var ret = 0;

		if((f2 | f1) == 0)
		{
			return 0;
		}

		if((f1 & CLIPPING_FLAGS_X_CLIPPED) != 0 &&
		(f1 & CLIPPING_FLAGS_X_CLIPPED) == (f2 & CLIPPING_FLAGS_X_CLIPPED))
		{
			return 4;
		}

		if((f1 & CLIPPING_FLAGS_Y_CLIPPED) != 0 &&
		(f1 & CLIPPING_FLAGS_Y_CLIPPED) == (f2 & CLIPPING_FLAGS_Y_CLIPPED))
		{
			return 4;
		}

		var tx1 = x1.value;
		var ty1 = y1.value;
		var tx2 = x2.value;
		var ty2 = y2.value;

		if(f1 != 0)
		{
			if(!clipMovePoint(tx1, ty1, tx2, ty2, clippingBox, x1, y1, f1))
			{
				return 4;
			}
			if(x1.value == x2.value && y1.value == y2.value)
			{
				return 4;
			}
			ret |= 1;
		}
		if(f2 != 0)
		{
			if(!clipMovePoint(tx1, ty1, tx2, ty2, clippingBox, x2, y2, f2))
			{			
				return 4;
			}
			if(x1.value == x2.value && y1.value == y2.value)
			{
				return 4;
			}
			ret |= 2;
		}
		return ret;
	}	
}