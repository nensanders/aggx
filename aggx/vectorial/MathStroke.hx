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
import aggx.core.geometry.Coord;
import aggx.core.memory.Ref;
import aggx.core.math.Calc;
import aggx.core.utils.ArrayUtil;
using aggx.core.utils.ArrayUtil;
//=======================================================================================================

class MathStroke 
{
	private var _width:Float;
	private var _widthAbs:Float;
	private var _widthEps:Float;
	private var _widthSign:Int;
	private var _miterLimit:Float;
	private var _innerMiterLimit:Float;
	private var _approximationScale:Float;
	private var _lineCap:Int;
	private var _lineJoin:Int;
	private var _innerJoin:Int;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_width = 0.5;
		_widthAbs = 0.5;
		_widthEps = 0.5 / 1024.0;
		_widthSign = 1;
		_miterLimit = 4.0;
		_innerMiterLimit = 1.01;
		_approximationScale = 1.0;
		_lineCap = LineCap.BUTT;
		_lineJoin = LineJoin.MITER;
		_innerJoin = InnerJoin.MITER;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():Float { return _width * 2.0; }
	private inline function set_width(value:Float):Float
	{
		_width = value * 0.5;
		if(_width < 0)
		{
			_widthAbs = -_width;
			_widthSign = -1;
		}
		else
		{
			_widthAbs = _width;
			_widthSign = 1;
		}
		_widthEps = _width / 1024.0;
		return _width;
	}
	public var width(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineCap():Int { return _lineCap; }
	private inline function set_lineCap(value:Int):Int { return _lineCap = value; }
	public var lineCap(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineJoin():Int { return _lineJoin; }
	private inline function set_lineJoin(value:Int):Int { return _lineJoin = value; }
	public var lineJoin(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerJoin():Int { return _innerJoin; }
	private inline function set_innerJoin(value:Int):Int { return _innerJoin = value; }
	public var innerJoin(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_miterLimit():Float { return _miterLimit; }
	private inline function set_miterLimit(value:Float):Float { return _miterLimit = value; }
	public var miterLimit(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerMiterLimit():Float { return _innerMiterLimit; }
	private inline function set_innerMiterLimit(value:Float):Float { return _innerMiterLimit = value; }
	public var innerMiterLimit(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return _approximationScale; }
	private inline function set_approximationScale(value:Float):Float { return _approximationScale = value; }
	public var approximationScale(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function set_miterLimitTheta(value:Float):Float { _miterLimit = 1.0 / Math.sin(value * 0.5); return value; }
	public var miterLimitTheta(null, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function addVertex(vc:Array<Coord>, x:Float, y:Float):Void
	{
		vc[vc.length] = new Coord(x, y);
	}	
	//---------------------------------------------------------------------------------------------------
	private function calcArc(vc:Array<Coord>, x:Float, y:Float, dx1:Float, dy1:Float, dx2:Float, dy2:Float):Void
	{
		var a1 = Math.atan2(dy1 * _widthSign, dx1 * _widthSign);
		var a2 = Math.atan2(dy2 * _widthSign, dx2 * _widthSign);
		var da = a1 - a2;
		var i:Int, n:Int;

		da = Math.acos(_widthAbs / (_widthAbs + 0.125 / _approximationScale)) * 2;

		addVertex(vc, x + dx1, y + dy1);
		if(_widthSign > 0)
		{
			if (a1 > a2) a2 += Calc.PI2;
			n = Std.int((a2 - a1) / da);
			da = (a2 - a1) / (n + 1);
			a1 += da;
			i = 0;
			while (i < n)
			{
				addVertex(vc, x + Math.cos(a1) * _width, y + Math.sin(a1) * _width);
				a1 += da;
				i++;
			}
		}
		else
		{
			if (a1 < a2) a2 -= Calc.PI2;
			n = Std.int((a1 - a2) / da);
			da = (a1 - a2) / (n + 1);
			a1 -= da;
			i = 0;
			while (i < n)
			{
				addVertex(vc, x + Math.cos(a1) * _width, y + Math.sin(a1) * _width);
				a1 -= da;
				i++;
			}
		}
		addVertex(vc, x + dx2, y + dy2);
	}
	//---------------------------------------------------------------------------------------------------
	private function calcMiter(vc:Array<Coord>, v0:IDistanceProvider, v1:IDistanceProvider, v2:IDistanceProvider, dx1:Float, dy1:Float, dx2:Float, dy2:Float, lj:Int, mlimit:Float, dbevel:Float):Void
	{
		var xi = v1.x;
		var yi = v1.y;
		var di = 1.0;
		var lim = _widthAbs * mlimit;
		var miter_limit_exceeded = true;
		var intersection_failed  = true;

		var rxi = Ref.getFloat().set(xi);
		var ryi = Ref.getFloat().set(xi);
		if(Calc.intersection(v0.x + dx1, v0.y - dy1, v1.x + dx1, v1.y - dy1, v1.x + dx2, v1.y - dy2, v2.x + dx2, v2.y - dy2, rxi, ryi))
		{
			di = Calc.distance(v1.x, v1.y, xi = Ref.putFloat(rxi).value, yi = Ref.putFloat(ryi).value);
			if(di <= lim)
			{
				addVertex(vc, xi, yi);
				miter_limit_exceeded = false;
			}
			intersection_failed = false;
		}
		else
		{
			var x2 = v1.x + dx1;
			var y2 = v1.y - dy1;
			if ((Calc.crossProduct(v0.x, v0.y, v1.x, v1.y, x2, y2) < 0.0) == (Calc.crossProduct(v1.x, v1.y, v2.x, v2.y, x2, y2) < 0.0))			
			{
				addVertex(vc, v1.x + dx1, v1.y - dy1);
				miter_limit_exceeded = false;
			}
		}

		if(miter_limit_exceeded)
		{
			switch(lj)
			{
			case LineJoin.MITER_REVERT:
				addVertex(vc, v1.x + dx1, v1.y - dy1);
				addVertex(vc, v1.x + dx2, v1.y - dy2);

			case  LineJoin.MITER_ROUND:
				calcArc(vc, v1.x, v1.y, dx1, -dy1, dx2, -dy2);

			default:
				if(intersection_failed)
				{
					mlimit *= _widthSign;
					addVertex(vc, v1.x + dx1 + dy1 * mlimit, v1.y - dy1 + dx1 * mlimit);
					addVertex(vc, v1.x + dx2 - dy2 * mlimit, v1.y - dy2 - dx2 * mlimit);
				}
				else
				{
					var x1 = v1.x + dx1;
					var y1 = v1.y - dy1;
					var x2 = v1.x + dx2;
					var y2 = v1.y - dy2;
					di = (lim - dbevel) / (di - dbevel);
					addVertex(vc, x1 + (xi - x1) * di, y1 + (yi - y1) * di);
					addVertex(vc, x2 + (xi - x2) * di,	y2 + (yi - y2) * di);
				}
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function calcCap(vc:Array<Coord>, v0:IDistanceProvider, v1:IDistanceProvider, len:Float):Void
	{
        vc.shrink(0); // TODO Warning just works for as,js,cpp

		var dx1 = (v1.y - v0.y) / len;
		var dy1 = (v1.x - v0.x) / len;
		var dx2 = 0.0;
		var dy2 = 0.0;

		dx1 *= _width;
		dy1 *= _width;

		if(_lineCap != LineCap.ROUND)
		{
			if(_lineCap == LineCap.SQUARE)
			{
				dx2 = dy1 * _widthSign;
				dy2 = dx1 * _widthSign;
			}
			addVertex(vc, v0.x - dx1 - dx2, v0.y + dy1 - dy2);
			addVertex(vc, v0.x + dx1 - dx2, v0.y - dy1 - dy2);
		}
		else
		{
			var da = Math.acos(_widthAbs / (_widthAbs + 0.125 / _approximationScale)) * 2;
			var a1:Float;
			var i:Int;
			var n = Std.int(Calc.PI / da);

			da = Calc.PI / (n + 1);
			addVertex(vc, v0.x - dx1, v0.y + dy1);
			if (_widthSign > 0)			
			{
				a1 = Math.atan2(dy1, -dx1);
				a1 += da;
				i = 0;
				while (i < n)				
				{
					addVertex(vc, v0.x + Math.cos(a1) * _width, v0.y + Math.sin(a1) * _width);					
					a1 += da;
					i++;
				}
			}
			else
			{
				a1 = Math.atan2(-dy1, dx1);
				i = 0;
				while (i < n)
				{
					addVertex(vc, v0.x + Math.cos(a1) * _width, v0.y + Math.sin(a1) * _width);					
					a1 -= da;
					i++;
				}
			}
			addVertex(vc, v0.x + dx1, v0.y - dy1);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function calcJoin(vc:Array<Coord>, v0:IDistanceProvider, v1:IDistanceProvider, v2:IDistanceProvider, len1:Float, len2:Float):Void
	{
		var dx1 = _width * (v1.y - v0.y) / len1;
		var dy1 = _width * (v1.x - v0.x) / len1;
		var dx2 = _width * (v2.y - v1.y) / len2;
		var dy2 = _width * (v2.x - v1.x) / len2;

		vc.shrink(0); // TODO Warning just works for as,js,cpp

		var cp = Calc.crossProduct(v0.x, v0.y, v1.x, v1.y, v2.x, v2.y);
		if(cp != 0 && (cp > 0) == (_width > 0))
		{
			var limit = ((len1 < len2) ? len1 : len2) / _widthAbs;
			if(limit < _innerMiterLimit)
			{
				limit = _innerMiterLimit;
			}

			switch(_innerJoin)
			{
			default:
				addVertex(vc, v1.x + dx1, v1.y - dy1);
				addVertex(vc, v1.x + dx2, v1.y - dy2);

			case InnerJoin.MITER:
				calcMiter(vc, v0, v1, v2, dx1, dy1, dx2, dy2, LineJoin.MITER_REVERT, limit, 0);

			case InnerJoin.JAG, InnerJoin.ROUND:
				cp = (dx1 - dx2) * (dx1 - dx2) + (dy1 - dy2) * (dy1 - dy2);
				if (cp < len1 * len1 && cp < len2 * len2)				
				{
					calcMiter(vc, v0, v1, v2, dx1, dy1, dx2, dy2, LineJoin.MITER_REVERT, limit, 0);
				}
				else
				{
					if(_innerJoin == InnerJoin.JAG)
					{
						addVertex(vc, v1.x + dx1, v1.y - dy1);
						addVertex(vc, v1.x, v1.y );
						addVertex(vc, v1.x + dx2, v1.y - dy2);
					}
					else
					{
						addVertex(vc, v1.x + dx1, v1.y - dy1);
						addVertex(vc, v1.x, v1.y );
						calcArc(vc, v1.x, v1.y, dx2, -dy2, dx1, -dy1);
						addVertex(vc, v1.x, v1.y );
						addVertex(vc, v1.x + dx2, v1.y - dy2);
					}
				}
			}
		}
		else
		{
			var dx = (dx1 + dx2) / 2;
			var dy = (dy1 + dy2) / 2;
			var dbevel = Math.sqrt(dx * dx + dy * dy);

			if(_lineJoin == LineJoin.ROUND || _lineJoin == LineJoin.BEVEL)
			{
				if (_approximationScale * (_widthAbs - dbevel) < _widthEps)				
				{
					var rdx = Ref.getFloat().set(dx);
					var rdy = Ref.getFloat().set(dy);
					if(Calc.intersection(v0.x + dx1, v0.y - dy1, v1.x + dx1, v1.y - dy1, v1.x + dx2, v1.y - dy2, v2.x + dx2, v2.y - dy2, rdx, rdy))
					{
						addVertex(vc, Ref.putFloat(rdx).value, Ref.putFloat(rdy).value);
					}
					else
					{
						addVertex(vc, v1.x + dx1, v1.y - dy1);
					}
					return;
				}
			}

			switch(_lineJoin)
			{
			case LineJoin.MITER, LineJoin.MITER_REVERT, LineJoin.MITER_ROUND:
				calcMiter(vc, v0, v1, v2, dx1, dy1, dx2, dy2, _lineJoin, _miterLimit, dbevel);

			case LineJoin.ROUND:
				calcArc(vc, v1.x, v1.y, dx1, -dy1, dx2, -dy2);

			default:
				addVertex(vc, v1.x + dx1, v1.y - dy1);
				addVertex(vc, v1.x + dx2, v1.y - dy2);
			}
		}
	}
}