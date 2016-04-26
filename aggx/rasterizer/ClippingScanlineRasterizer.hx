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
import aggx.core.math.Calc;
//=======================================================================================================
class ClippingScanlineRasterizer
{
	private var _clippingBox:RectBox;
	private var _x1:Float;
	private var _y1:Float;
	private var _f1:Int;
	private var _isClipping:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_x1 = 0;
		_y1 = 0;
		_f1 = 0;
		_clippingBox = new RectBox();
		_isClipping = false;
	}
	//---------------------------------------------------------------------------------------------------
	private static inline function mulDiv(a:Float, b:Float, c:Float):Float
	{	
		return a * b / c;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function xi(v:Float):Int { return Calc.iround(v * PolySubpixelScale.POLY_SUBPIXEL_SCALE); }
	//---------------------------------------------------------------------------------------------------
	public static inline function yi(v:Float):Int { return Calc.iround(v * PolySubpixelScale.POLY_SUBPIXEL_SCALE); }
	//---------------------------------------------------------------------------------------------------
	public static inline function upscale(v:Float):Float
	{
		return v;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function downscale(v:Int):Float { return v / PolySubpixelScale.POLY_SUBPIXEL_SCALE; }	
	//---------------------------------------------------------------------------------------------------
	public function resetClipping():Void
	{
		_isClipping = false;
	}
	//--------------------------------------------------------------------
	public function setClippingBounds(x1:Float, y1:Float, x2:Float, y2:Float):Void
	{
		_clippingBox.init(x1, y1, x2, y2);
		_clippingBox.normalize();
		_isClipping = true;
	}

	//--------------------------------------------------------------------
	public inline function moveTo(x1:Float, y1:Float):Void
	{
		_x1 = x1;
		_y1 = y1;
		if(_isClipping) _f1 = LiangBarskyClipper.getClippingFlags(x1, y1, _clippingBox);
	}
	//---------------------------------------------------------------------------------------------------
	public function lineTo(ras:PixelCellRasterizer, x2:Float, y2:Float):Void
	{
		if(_isClipping)
		{
			var f2 = LiangBarskyClipper.getClippingFlags(x2, y2, _clippingBox);

			if((_f1 & 10) == (f2 & 10) && (_f1 & 10) != 0)
			{
				_x1 = x2;
				_y1 = y2;
				_f1 = f2;
				return;
			}

			var x1 = _x1;
			var y1 = _y1;
			var f1 = _f1;
			var y3, y4;
			var f3, f4;

			switch(((f1 & 5) << 1) | (f2 & 5))
			{
			case 0:
				lineClipY(ras, x1, y1, x2, y2, f1, f2);

			case 1:
				y3 = y1 + mulDiv(_clippingBox.x2 - x1, y2 - y1, x2 - x1);
				f3 = LiangBarskyClipper.getClippingFlagsY(y3, _clippingBox);
				lineClipY(ras, x1, y1, _clippingBox.x2, y3, f1, f3);
				lineClipY(ras, _clippingBox.x2, y3, _clippingBox.x2, y2, f3, f2);

			case 2:
				y3 = y1 + mulDiv(_clippingBox.x2 - x1, y2 - y1, x2 - x1);
				f3 = LiangBarskyClipper.getClippingFlagsY(y3, _clippingBox);
				lineClipY(ras, _clippingBox.x2, y1, _clippingBox.x2, y3, f1, f3);
				lineClipY(ras, _clippingBox.x2, y3, x2, y2, f3, f2);

			case 3:
				lineClipY(ras, _clippingBox.x2, y1, _clippingBox.x2, y2, f1, f2);

			case 4:
				y3 = y1 + mulDiv(_clippingBox.x1 - x1, y2 - y1, x2 - x1);
				f3 = LiangBarskyClipper.getClippingFlagsY(y3, _clippingBox);
				lineClipY(ras, x1, y1, _clippingBox.x1, y3, f1, f3);
				lineClipY(ras, _clippingBox.x1, y3, _clippingBox.x1, y2, f3, f2);

			case 6:
				y3 = y1 + mulDiv(_clippingBox.x2 - x1, y2 - y1, x2 - x1);
				y4 = y1 + mulDiv(_clippingBox.x1 - x1, y2 - y1, x2 - x1);
				f3 = LiangBarskyClipper.getClippingFlagsY(y3, _clippingBox);
				f4 = LiangBarskyClipper.getClippingFlagsY(y4, _clippingBox);
				lineClipY(ras, _clippingBox.x2, y1, _clippingBox.x2, y3, f1, f3);
				lineClipY(ras, _clippingBox.x2, y3, _clippingBox.x1, y4, f3, f4);
				lineClipY(ras, _clippingBox.x1, y4, _clippingBox.x1, y2, f4, f2);

			case 8:
				y3 = y1 + mulDiv(_clippingBox.x1 - x1, y2 - y1, x2 - x1);
				f3 = LiangBarskyClipper.getClippingFlagsY(y3, _clippingBox);
				lineClipY(ras, _clippingBox.x1, y1, _clippingBox.x1, y3, f1, f3);
				lineClipY(ras, _clippingBox.x1, y3, x2, y2, f3, f2);

			case 9:
				y3 = y1 + mulDiv(_clippingBox.x1 - x1, y2 - y1, x2 - x1);
				y4 = y1 + mulDiv(_clippingBox.x2 - x1, y2 - y1, x2 - x1);
				f3 = LiangBarskyClipper.getClippingFlagsY(y3, _clippingBox);
				f4 = LiangBarskyClipper.getClippingFlagsY(y4, _clippingBox);
				lineClipY(ras, _clippingBox.x1, y1, _clippingBox.x1, y3, f1, f3);
				lineClipY(ras, _clippingBox.x1, y3, _clippingBox.x2, y4, f3, f4);
				lineClipY(ras, _clippingBox.x2, y4, _clippingBox.x2, y2, f4, f2);

			case 12:
				lineClipY(ras, _clippingBox.x1, y1, _clippingBox.x1, y2, f1, f2);
			}
			_f1 = f2;
		}
		else
		{
			ras.line(xi(_x1), yi(_y1), xi(x2), yi(y2));
		}
		_x1 = x2;
		_y1 = y2;
	}
	//---------------------------------------------------------------------------------------------------
	private function lineClipY(ras:PixelCellRasterizer, x1:Float, y1:Float, x2:Float, y2:Float, f1:Int, f2:Int):Void
	{
		f1 &= 10;
		f2 &= 10;
		if((f1 | f2) == 0)
		{
			ras.line(xi(x1), yi(y1), xi(x2), yi(y2));
		}
		else
		{
			if(f1 == f2)
			{
				return;
			}

			var tx1 = x1;
			var ty1 = y1;
			var tx2 = x2;
			var ty2 = y2;

			if((f1 & 8)!=0)
			{
				tx1 = x1 + mulDiv(_clippingBox.y1-y1, x2-x1, y2-y1);
				ty1 = _clippingBox.y1;
			}

			if((f1 & 2)!=0)
			{
				tx1 = x1 + mulDiv(_clippingBox.y2-y1, x2-x1, y2-y1);
				ty1 = _clippingBox.y2;
			}

			if((f2 & 8)!=0)
			{
				tx2 = x1 + mulDiv(_clippingBox.y1-y1, x2-x1, y2-y1);
				ty2 = _clippingBox.y1;
			}

			if((f2 & 2)!=0)
			{
				tx2 = x1 + mulDiv(_clippingBox.y2-y1, x2-x1, y2-y1);
				ty2 = _clippingBox.y2;
			}
			ras.line(xi(tx1), yi(ty1), xi(tx2), yi(ty2));
		}
	}
}