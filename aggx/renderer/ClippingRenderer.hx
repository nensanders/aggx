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

package aggx.renderer;
//=======================================================================================================
import types.Data;
import haxe.ds.Vector;
import aggx.color.RgbaColor;
import aggx.color.RgbaColorStorage;
import aggx.RenderingBuffer;
import aggx.core.geometry.RectBoxI;
import aggx.core.memory.Byte;
import aggx.core.memory.Pointer;
//=======================================================================================================
class ClippingRenderer
{
	private var _pixelFormatRenderer:PixelFormatRenderer;
	private var _clippingBox:RectBoxI;
	//---------------------------------------------------------------------------------------------------
	public function new(pfren:PixelFormatRenderer) 
	{
		_pixelFormatRenderer = pfren;
		_clippingBox = new RectBoxI(0, 0, pfren.width - 1, pfren.height - 1);
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(pfren:PixelFormatRenderer)
	{
		_pixelFormatRenderer = pfren;
		_clippingBox = new RectBoxI(0, 0, pfren.width - 1, pfren.height - 1);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():UInt { return _pixelFormatRenderer.width; }
	public var width(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_height():UInt { return _pixelFormatRenderer.height; }
	public var height(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_pixelFormatRenderer():PixelFormatRenderer { return _pixelFormatRenderer; }
	public var pixelFormatRenderer(get, null):PixelFormatRenderer;
	//---------------------------------------------------------------------------------------------------
	private inline function get_clippingBox():RectBoxI { return _clippingBox; }
	public var clippingBox(get, null):RectBoxI;
	//---------------------------------------------------------------------------------------------------
	private inline function get_minX():Int { return _clippingBox.x1; }
	public var minX(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_minY():Int { return _clippingBox.y1; }
	public var minY(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxX():Int { return _clippingBox.x2; }
	public var maxX(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxY():Int { return _clippingBox.y2; }
	public var maxY(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	public function setClippingBounds(x1:Int, y1:Int, x2:Int, y2:Int):Bool
	{
		var cb = new RectBoxI(x1, y1, x2, y2);
		cb.normalize();
		if(cb.clip(new RectBoxI(0, 0, width - 1, height - 1)))
		{
			_clippingBox = cb;
			return true;
		}
		_clippingBox.x1 = 1;
		_clippingBox.y1 = 1;
		_clippingBox.x2 = 0;
		_clippingBox.y2 = 0;
		return false;
	}
	//---------------------------------------------------------------------------------------------------
	public function resetClipping(visibility:Bool):Void
	{
		if(visibility)
		{
			_clippingBox.x1 = 0;
			_clippingBox.y1 = 0;
			_clippingBox.x2 = width - 1;
			_clippingBox.y2 = height - 1;
		}
		else
		{
			_clippingBox.x1 = 1;
			_clippingBox.y1 = 1;
			_clippingBox.x2 = 0;
			_clippingBox.y2 = 0;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function forceClippingBounds(x1:Int, y1:Int, x2:Int, y2:Int):Void
	{
		_clippingBox.x1 = x1;
		_clippingBox.y1 = y1;
		_clippingBox.x2 = x2;
		_clippingBox.y2 = y2;
	}
	//---------------------------------------------------------------------------------------------------
	public function isInbox(x:Int, y:Int):Bool
	{
		return x >= _clippingBox.x1 && y >= _clippingBox.y1 && x <= _clippingBox.x2 && y <= _clippingBox.y2;
	}
	//---------------------------------------------------------------------------------------------------
	public function clear(color:RgbaColor):Void
	{
		var y:UInt = 0;
		if (width != 0)		
		{
			var h = height;
			while (y < h)
			{
				_pixelFormatRenderer.copyHLine(0, y, width, color);
				++y;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function copyPixel(x:Int, y:Int, color:RgbaColor)
	{
		if(isInbox(x, y))
		{
			_pixelFormatRenderer.copyPixel(x, y, color);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendPixel(x:Int, y:Int, color:RgbaColor, cover:Byte):Void
	{
		if(isInbox(x, y))
		{
			_pixelFormatRenderer.blendPixel(x, y, color, cover);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function pixel(x:Int, y:Int):RgbaColor
	{
		return isInbox(x, y) ? _pixelFormatRenderer.getPixel(x, y) : RgbaColor.empty();
	}
	//---------------------------------------------------------------------------------------------------
	public function copyHLine(x1:Int, y:Int, x2:Int, color:RgbaColor):Void
	{
		if (x1 > x2) { var t = x2; x2 = x1; x1 = t; }		
		if (y > maxY) return;
		if (y < minY) return;
		if (x1 > maxX) return;
		if (x2 < minX) return;

		if (x1 < minX) x1 = minX;
		if (x2 > maxX) x2 = maxX;

		_pixelFormatRenderer.copyHLine(x1, y, x2 - x1 + 1, color);
	}
	//---------------------------------------------------------------------------------------------------
	public function copyVLine(x:Int, y1:Int, y2:Int, color:RgbaColor):Void
	{
		if (y1 > y2) { var t = y2; y2 = y1; y1 = t; }		
		if (x > maxX) return;
		if (x < minX) return;
		if (y1 > maxY) return;
		if (y2 < minY) return;

		if (y1 < minY) y1 = minY;
		if (y2 > maxY) y2 = maxY;

		_pixelFormatRenderer.copyVLine(x, y1, y2 - y1 + 1, color);
	}
	//---------------------------------------------------------------------------------------------------
	public function blendHLine(x1:Int, y:Int, x2:Int, c:RgbaColor, cover:Byte):Void
	{
		if (x1 > x2) { var t = x2; x2 = x1; x1 = t; }		
		if (y > maxY) return;
		if (y < minY) return;
		if (x1 > maxX) return;
		if (x2 < minX) return;
		
		if (x1 < minX) x1 = minX;
		if (x2 > maxX) x2 = maxX;

		_pixelFormatRenderer.blendHLine(x1, y, x2 - x1 + 1, c, cover);
	}
	//---------------------------------------------------------------------------------------------------
	public function blendVLine(x:Int, y1:Int, y2:Int, color:RgbaColor, cover:Byte):Void
	{
		if (y1 > y2) { var t = y2; y2 = y1; y1 = t; }		
		if (x > maxX) return;
		if (x < minX) return;
		if (y1 > maxY) return;
		if (y2 < minY) return;

		if (y1 < minY) y1 = minY;
		if (y2 > maxY) y2 = maxY;

		_pixelFormatRenderer.blendVLine(x, y1, y2 - y1 + 1, color, cover);
	}
	//---------------------------------------------------------------------------------------------------
	public function copyBar(x1:Int, y1:Int, x2:Int, y2:Int, color:RgbaColor):Void
	{
		var rc = new RectBoxI(x1, y1, x2, y2);
		rc.normalize();
		if(rc.clip(_clippingBox))
		{
			var y = rc.y1;
			var z = rc.y2;
			while (y <= z)
			{
				_pixelFormatRenderer.copyHLine(rc.x1, y, (rc.x2 - rc.x1 + 1), color);
				y++;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendBar(x1:Int, y1:Int, x2:Int, y2:Int, color:RgbaColor, cover:Byte):Void
	{
		var rc = new RectBoxI(x1, y1, x2, y2);
		rc.normalize();
		if(rc.clip(_clippingBox))
		{
			var y = rc.y1;
			var z = rc.y2;
			while (y <= z)	
			{
				_pixelFormatRenderer.blendHLine(rc.x1, y, rc.x2 - rc.x1 + 1, color, cover);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendSolidHSpan(x:Int, y:Int, len:Int, color:RgbaColor, covers:Data):Void
	{
		if(y > maxY) return;
		if(y < minY) return;

        var offset = covers.offset;

		if(x < minX)
		{
			len -= (minX - x);
			if(len <= 0) return;
			covers.offset += (minX - x);
			x = minX;
		}
		if((x + len) > maxX)
		{
			len = maxX - x + 1;
			if (len <= 0) return;
		}
		_pixelFormatRenderer.blendSolidHSpan(x, y, len, color, covers);
        covers.offset = offset;
	}
	//---------------------------------------------------------------------------------------------------
	public function blendSolidVSpan(x:Int, y:Int, len:Int, color:RgbaColor, covers:Data):Void
	{
		if(x > maxX) return;
		if(x < minX) return;

        var offset = covers.offset;

		if(y < minY)
		{
			len -= (minY - y);
			if(len <= 0) return;
			covers.offset += (minY - y);
			y = minY;
		}
		if((y + len) > maxY)
		{
			len = maxY - y + 1;
			if(len <= 0) return;
		}
		_pixelFormatRenderer.blendSolidVSpan(x, y, len, color, covers);

        covers.offset = offset;
	}
	//---------------------------------------------------------------------------------------------------
	public function copyColorHSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage):Void
	{
		if(y > maxY) return;
		if(y < minY) return;

		if(x < minX)
		{
			var d = minX - x;
			len -= d;
			if(len <= 0) return;
			colors.offset += d;
			x = minX;
		}
		if((x + len) > maxX)
		{
			len = maxX - x + 1;
			if(len <= 0) return;
		}
		_pixelFormatRenderer.copyColorHSpan(x, y, len, colors);
	}
	//---------------------------------------------------------------------------------------------------
	public function copyColorVSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage):Void
	{
		if(x > maxX) return;
		if(x < minX) return;

		if(y < minY)
		{
			var d = minY - y;
			len -= d;
			if(len <= 0) return;
			colors.offset += d;
			y = minY;
		}
		if((y + len) > maxY)
		{
			len = maxY - y + 1;
			if(len <= 0) return;
		}
		_pixelFormatRenderer.copyColorVSpan(x, y, len, colors);
	}
	//---------------------------------------------------------------------------------------------------
	public function blendColorHSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage, covers:Data, cover:Byte = 255):Void
	{
		if(y > maxY) return;
		if(y < minY) return;

		if(x < minX)
		{
			var d = minX - x;
			len -= d;
			if(len <= 0) return;
			if (covers != null)
			{
				covers.offset += d;
			}
			colors.offset += d;
			x = minX;
		}
		if((x + len) > maxX)
		{
			len = maxX - x + 1;
			if(len <= 0) return;
		}
		_pixelFormatRenderer.blendColorHSpan(x, y, len, colors, covers, cover);
	}
	//---------------------------------------------------------------------------------------------------
	public function blendColorVSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage, covers:Data, cover:Byte = 255):Void
	{
		if(x > maxX) return;
		if(x < minX) return;

		if(y < minY)
		{
			var d = minY - y;
			len -= d;
			if(len <= 0) return;
            trace('minX: $minY x: $y');
			if (covers != null)
			{
				covers.offset += d;
			}
			colors.offset += d;
			y = minY;
		}
		if((y + len) > maxY)
		{
			len = maxY - y + 1;
			if(len <= 0) return;
		}
		_pixelFormatRenderer.blendColorVSpan(x, y, len, colors, covers, cover);
	}
	//---------------------------------------------------------------------------------------------------
	public function clipRectArea(dst:RectBoxI, src:RectBoxI, wsrc:Int, hsrc:Int):RectBoxI
	{
		var rc = new RectBoxI(0,0,0,0);
		var cb = _clippingBox;
		++cb.x2;
		++cb.y2;

		if(src.x1 < 0)
		{
			dst.x1 -= src.x1;
			src.x1 = 0;
		}
		if(src.y1 < 0)
		{
			dst.y1 -= src.y1;
			src.y1 = 0;
		}

		if(src.x2 > wsrc) src.x2 = wsrc;
		if(src.y2 > hsrc) src.y2 = hsrc;

		if(dst.x1 < cb.x1)
		{
			src.x1 += cb.x1 - dst.x1;
			dst.x1 = cb.x1;
		}
		if(dst.y1 < cb.y1)
		{
			src.y1 += cb.y1 - dst.y1;
			dst.y1 = cb.y1;
		}

		if(dst.x2 > cb.x2) dst.x2 = cb.x2;
		if(dst.y2 > cb.y2) dst.y2 = cb.y2;

		rc.x2 = dst.x2 - dst.x1;
		rc.y2 = dst.y2 - dst.y1;

		if(rc.x2 > src.x2 - src.x1) rc.x2 = src.x2 - src.x1;
		if(rc.y2 > src.y2 - src.y1) rc.y2 = src.y2 - src.y1;
		return rc;
	}

	//---------------------------------------------------------------------------------------------------
	public function blendFrom(src:PixelFormatRenderer, rectSrc:RectBoxI = null, dx:Int = 0, dy:Int = 0, cover:Byte = 255):Void
	{
		var rsrc = new RectBoxI(0, 0, src.width, src.height);
		if (rectSrc != null)
		{
			rsrc.x1 = rectSrc.x1;
			rsrc.y1 = rectSrc.y1;
			rsrc.x2 = rectSrc.x2 + 1;
			rsrc.y2 = rectSrc.y2 + 1;
		}

		var rdst = new RectBoxI(rsrc.x1 + dx, rsrc.y1 + dy, rsrc.x2 + dx, rsrc.y2 + dy);

		var rc = clipRectArea(rdst, rsrc, src.width, src.height);

		if(rc.x2 > 0)
		{
			var incy = 1;
			if(rdst.y1 > rsrc.y1)
			{
				rsrc.y1 += rc.y2 - 1;
				rdst.y1 += rc.y2 - 1;
				incy = -1;
			}
			while(rc.y2 > 0)
			{
				var rw = src.getRow(rsrc.y1);
				if(rw.ptr != 0)
				{
					var x1src = rsrc.x1;
					var x1dst = rdst.x1;
					var len = rc.x2;
					if(rw.x1 > x1src)
					{
						x1dst += rw.x1 - x1src;
						len -= rw.x1 - x1src;
						x1src = rw.x1;
					}
					if(len > 0)
					{
						if(x1src + len-1 > rw.x2)
						{
							len -= x1src + len - rw.x2 - 1;
						}
						if(len > 0)
						{
							_pixelFormatRenderer.blendFrom(src, x1dst, rdst.y1, x1src, rsrc.y1, len, cover);
						}
					}
				}
				rdst.y1 += incy;
				rsrc.y1 += incy;
				--rc.y2;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendFromColor(src:PixelFormatRenderer, color:RgbaColor, rectSrc:RectBoxI = null, dx:Int = 0, dy:Int = 0, cover:Byte = 255):Void
	{
		var rsrc = new RectBoxI(0, 0, src.width, src.height);
		if (rectSrc != null)		
		{
			rsrc.x1 = rectSrc.x1;
			rsrc.y1 = rectSrc.y1;
			rsrc.x2 = rectSrc.x2 + 1;
			rsrc.y2 = rectSrc.y2 + 1;
		}

		var rdst = new RectBoxI(rsrc.x1 + dx, rsrc.y1 + dy, rsrc.x2 + dx, rsrc.y2 + dy);

		var rc = clipRectArea(rdst, rsrc, src.width, src.height);

		if(rc.x2 > 0)
		{
			var incy = 1;
			if(rdst.y1 > rsrc.y1)
			{
				rsrc.y1 += rc.y2 - 1;
				rdst.y1 += rc.y2 - 1;
				incy = -1;
			}
			while(rc.y2 > 0)
			{
				var rw = src.getRow(rsrc.y1);
				
				if(rw.ptr != 0)
				{
					var x1src = rsrc.x1;
					var x1dst = rdst.x1;
					var len = rc.x2;
					if(rw.x1 > x1src)
					{
						x1dst += rw.x1 - x1src;
						len -= rw.x1 - x1src;
						x1src = rw.x1;
					}
					if(len > 0)
					{
						if(x1src + len-1 > rw.x2)
						{
							len -= x1src + len - rw.x2 - 1;
						}
						if(len > 0)
						{
							_pixelFormatRenderer.blendFromColor(src, color, x1dst, rdst.y1, x1src, rsrc.y1, len, cover);
						}
					}
				}
				rdst.y1 += incy;
				rsrc.y1 += incy;
				--rc.y2;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendFromLut(src:PixelFormatRenderer, colorLut:Vector<RgbaColor>, rectSrc:RectBoxI = null, dx:Int = 0, dy:Int = 0, cover:Byte = 255):Void
	{
		var rsrc = new RectBoxI(0, 0, src.width, src.height);
		if (rectSrc != null)		
		{
			rsrc.x1 = rectSrc.x1;
			rsrc.y1 = rectSrc.y1;
			rsrc.x2 = rectSrc.x2 + 1;
			rsrc.y2 = rectSrc.y2 + 1;
		}

		var rdst = new RectBoxI(rsrc.x1 + dx, rsrc.y1 + dy, rsrc.x2 + dx, rsrc.y2 + dy);

		var rc = clipRectArea(rdst, rsrc, src.width, src.height);

		if(rc.x2 > 0)
		{
			var incy = 1;
			if(rdst.y1 > rsrc.y1)
			{
				rsrc.y1 += rc.y2 - 1;
				rdst.y1 += rc.y2 - 1;
				incy = -1;
			}
			while(rc.y2 > 0)
			{
				var rw = src.getRow(rsrc.y1);
				
				if(rw.ptr != 0)
				{
					var x1src = rsrc.x1;
					var x1dst = rdst.x1;
					var len = rc.x2;
					if(rw.x1 > x1src)
					{
						x1dst += rw.x1 - x1src;
						len -= rw.x1 - x1src;
						x1src = rw.x1;
					}
					if(len > 0)
					{
						if(x1src + len-1 > rw.x2)
						{
							len -= x1src + len - rw.x2 - 1;
						}
						if(len > 0)
						{
							_pixelFormatRenderer.blendFromLut(src, colorLut, x1dst, rdst.y1, x1src, rsrc.y1, len, cover);
						}
					}
				}
				rdst.y1 += incy;
				rsrc.y1 += incy;
				--rc.y2;
			}
		}
	}	
}