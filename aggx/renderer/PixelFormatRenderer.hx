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
import aggx.core.utils.Debug;
import types.Data;
import haxe.ds.Vector;
import aggx.color.GammaLookupTable;
import aggx.color.RgbaColor;
import aggx.color.RgbaColorStorage;
import aggx.RenderingBuffer;
import aggx.RowInfo;
import aggx.core.memory.Byte;
import aggx.core.memory.MemoryUtils;
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReader;
using aggx.core.memory.MemoryReader;

import aggx.core.memory.RgbaReaderWriter;
using aggx.core.memory.RgbaReaderWriter;
//=======================================================================================================
class PixelFormatRenderer
{
	var _rbuf:RenderingBuffer;
	//---------------------------------------------------------------------------------------------------
	public function new(?rbuf:RenderingBuffer) 
	{
		_rbuf = rbuf;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(pixf:PixelFormatRenderer, x1:Int, y1:Int, x2:Int, y2:Int):Bool
	{
		//var r = new RectI(x1, y1, x2, y2);
		//if (r.clip(new RectI(0, 0, pixf.width - 1, pixf.height - 1)))
		//{
			//var stride = pixf.stride;
			//var block = MemoryBlock.getSubBlock(pixf._
			//_rbuf.attach(pixf.getPixPtr(r.x1, stride < 0 ? r.y2 : r.y1), (r.x2 - r.x1) + 1, (r.y2 - r.y1) + 1);
			//return true;
		//}
		return false;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():UInt { return _rbuf.width; }
	public var width(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_height():UInt { return _rbuf.height; }
	public var height(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_stride():Int { return _rbuf.stride; }
	public var stride(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	public inline function getRowPtr(y:Int):Pointer { return _rbuf.getRowPtr(y); }
	//---------------------------------------------------------------------------------------------------
	public inline function getRow(y:Int):RowInfo { return _rbuf.getRow(y); }
	//---------------------------------------------------------------------------------------------------
	public inline function getPixPtr(x:Int, y:Int):Pointer { return _rbuf.getRowPtr(y) + x; }
	//---------------------------------------------------------------------------------------------------
	public static function makePix(p:Pointer, color:RgbaColor)
	{		
		p.setFull(color.r, color.g, color.b, color.a);
	}
	//--------------------------------------------------------------------
	public function getPixel(x:Int, y:Int):RgbaColor
	{
		var p = _rbuf.getRowPtr(y) + (x << 2);
		return new RgbaColor(p.getR(), p.getG(), p.getB(), p.getA());
	}
	//---------------------------------------------------------------------------------------------------
	public function copyPixel(x:Int, y:Int, color:RgbaColor):Void
	{
		var p = _rbuf.getRowPtr(y) + (x << 2);
		p.setFull(color.r, color.g, color.b, color.a);
	}
	//---------------------------------------------------------------------------------------------------
	public function blendPixel(x:Int, y:Int, color:RgbaColor, cover:Byte):Void
	{
		var ptr = _rbuf.getRowPtr(y) + (x << 2);
		copyOrBlendPix(ptr, color.r, color.g, color.b, color.a, cover);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function copyHLine(x:Int, y:Int, len:Int, color:RgbaColor):Void
	{
		var p = _rbuf.getRowPtr(y) + (x << 2);
		do
		{
			p.setFull(color.r, color.g, color.b, color.a);
			p += 4;
		}
		while(--len > 0);
	}
	//---------------------------------------------------------------------------------------------------
	public function copyVLine(x:Int, y:Int, len:Int, color:RgbaColor):Void
	{
		x = (x << 2);
		do
		{
			var p = _rbuf.getRowPtr(y++) + x;
			p.setFull(color.r, color.g, color.b, color.a);
			p += 4;
		}
		while(--len > 0);
	}
	//---------------------------------------------------------------------------------------------------
	public function blendHLine(x:Int, y:Int, len:Int, color:RgbaColor, cover:Byte):Void
	{
		if (color.a != 0)
		{
			var p = _rbuf.getRowPtr(y) + (x << 2);
			var alpha = (color.a * (cover + 1)) >> 8;
			if(alpha == RgbaColor.BASE_MASK)
			{				
				do
				{
					p.setFull(color.r, color.g, color.b, color.a);
					p += 4;
				}
				while(--len > 0);
			}
			else
			{
				if(cover == 255)
				{
					do
					{
						Blender.blendPix(p, color.r, color.g, color.b, alpha);
						p += 4;
					}
					while(--len > 0);
				}
				else
				{
					do
					{
						Blender.blendPix(p, color.r, color.g, color.b, alpha, cover);
						p += 4;
					}
					while(--len > 0);
				}
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendVLine(x:Int, y:Int, len:Int, color:RgbaColor, cover:Byte):Void
	{	
		if (color.a != 0)
		{
			x = (x << 2);
			var p:Pointer;
			var alpha = (color.a * (cover + 1)) >> 8;
			if(alpha == RgbaColor.BASE_MASK)
			{
				do
				{
					p = _rbuf.getRowPtr(y++) + x;
					p.setFull(color.r, color.g, color.b, color.a);
					p += 4;
				}
				while(--len > 0);
			}
			else
			{
				if(cover == 255)
				{
					do
					{
						p = _rbuf.getRowPtr(y++) + x;
						Blender.blendPix(p, color.r, color.g, color.b, alpha);
					}
					while(--len > 0);
				}
				else
				{
					do
					{
						p = _rbuf.getRowPtr(y++) + x;
						Blender.blendPix(p, color.r, color.g, color.b, alpha, cover);
					}
					while(--len > 0);
				}
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendSolidHSpan(x:Int, y:Int, len:Int, color:RgbaColor, covers:Data):Void
	{
		if (color.a != 0)
		{
			var p = _rbuf.getRowPtr(y) + (x << 2);
			do
			{
				var cover = covers.readUInt8();
				covers.offset++;
				var alpha:UInt = (color.a * (cover + 1)) >> 8;

				if(alpha == RgbaColor.BASE_MASK)
				{
					color.a = RgbaColor.BASE_MASK;
					p.setFull(color.r, color.g, color.b, color.a);
				}
				else
				{
					Blender.blendPix(p, color.r, color.g, color.b, alpha, cover);
				}
				p += 4;
			}
			while(--len > 0);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendSolidVSpan(x:Int, y:Int, len:Int, color:RgbaColor, covers:Data):Void
	{
		if (color.a != 0)
		{
			x = (x << 2);
			do
			{
				var p = _rbuf.getRowPtr(y++) + x;
				var cover = covers.readUInt8();
				covers.offset++;
				var alpha:UInt = (color.a * (cover + 1)) >> 8;
				if(alpha == RgbaColor.BASE_MASK)
				{
					color.a = RgbaColor.BASE_MASK;
					p.setFull(color.r, color.g, color.b, color.a);
				}
				else
				{
					Blender.blendPix(p, color.r, color.g, color.b, alpha, cover);
				}
				p += 4;
			}
			while(--len > 0);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function copyColorHSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage):Void
	{
		var p = _rbuf.getRowPtr(y) + (x << 2);
		var ci = colors.offset;
		do
		{
			var color = colors.data[ci];
			p.setFull(color.r, color.g, color.b, color.a);
			p += 4;
			++ci;
		}
		while(--len > 0);
	}
	//---------------------------------------------------------------------------------------------------
	public function copyColorVSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage):Void
	{
		var ci = colors.offset;
		x = (x << 2);
		do
		{
			var p = _rbuf.getRowPtr(y++) + x;
			var color = colors.data[ci];
			p.setFull(color.r, color.g, color.b, color.a);
			p += 4;
			++ci;
		}
		while(--len > 0);
	}
	//---------------------------------------------------------------------------------------------------
	public function blendColorHSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage, covers:Data, cover:Byte):Void
	{
		var ci = colors.offset;
		var color:RgbaColor;
		var p = _rbuf.getRowPtr(y) + (x << 2);
		if(covers != null)
		{
			do
			{
				color = colors.data[ci];
				copyOrBlendPix(p, color.r, color.g, color.b, color.a, covers.readUInt8());
				covers.offset++;
				p += 4;
				++ci;
			}
			while(--len > 0);
		}
		else
		{
			if(cover == 255)
			{
				do
				{
					color = colors.data[ci];
					copyOrBlendPix2(p, color.r, color.g, color.b, color.a);
					p += 4;
					++ci;
				}
				while(--len > 0);
			}
			else
			{
				do
				{
					color = colors.data[ci];
					copyOrBlendPix(p, color.r, color.g, color.b, color.a, cover);
					p += 4;
					++ci;
				}
				while(--len > 0);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendColorVSpan(x:Int, y:Int, len:Int, colors:RgbaColorStorage, covers:Data, cover:Byte):Void
	{
		var p:Pointer, color:RgbaColor;
		var ci = colors.offset;
		var cvi:Int = 0;
		x = (x << 2);
		if(covers != null)
		{
			do
			{
				color = colors.data[ci];
				p = _rbuf.getRowPtr(y++) + x;
				copyOrBlendPix(p, color.r, color.g, color.b, color.a, covers.readUInt8());
				covers.offset++;
				p += 4;
				++ci;
			}
			while(--len > 0);
		}
		else
		{
			if(cover == 255)
			{
				do
				{
					color = colors.data[ci];
					p = _rbuf.getRowPtr(y++) + x;
					copyOrBlendPix2(p, color.r, color.g, color.b, color.a);
					p += 4;
					++ci;
				}
				while(--len > 0);
			}
			else
			{
				do
				{
					p = _rbuf.getRowPtr(y++) + x;
					color = colors.data[ci];
					copyOrBlendPix(p, color.r, color.g, color.b, color.a, cover);
					p += 4;
					++ci;
				}
				while(--len > 0);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function forEachPixel(f:Pointer->Void):Void
	{
		var y:UInt = 0;
		var h = height;
		while (y < h)
		{
			var r = _rbuf.getRow(y);
			if (r.ptr != 0) 
			{
				var len = r.x2 - r.x1 + 1;
				var p = _rbuf.getRowPtr(y) + (r.x1 << 2);
				do
				{
					f(p);
					p += 4;
				}
				while(--len > 0);
			}
			y++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function premultiply():Void
	{
		forEachPixel(premultiplyPixel);
	}
	//---------------------------------------------------------------------------------------------------
	public function demultiply():Void
	{
		forEachPixel(demultiplyPixel);
	}
	//---------------------------------------------------------------------------------------------------
	public function applyGammaDir(g:GammaLookupTable):Void
	{
		var gamma = new DirectGammaApplier(g);
		forEachPixel(gamma.apply);
	}
	//---------------------------------------------------------------------------------------------------
	public function applyGammaInv(g:GammaLookupTable):Void
	{
		var gamma = new InverseGammaApplier(g);
		forEachPixel(gamma.apply);
	}

	//---------------------------------------------------------------------------------------------------
	public function blendFrom(from:PixelFormatRenderer, xdst:Int, ydst:Int, xsrc:Int, ysrc:Int, len:Int, cover:Byte):Void
	{
		var psrc = from.getRowPtr(ysrc);
		if(psrc != 0)
		{
			psrc += (xsrc << 2);
			var pdst = _rbuf.getRowPtr(ydst) + (xdst << 2);
			var incp = 4;
			if(xdst > xsrc)
			{
				psrc += (len-1);
				pdst += (len-1);
				incp = -4;
			}

			if(cover == 255)
			{
				do
				{
					copyOrBlendPix2(pdst, psrc.getR(), psrc.getG(), psrc.getB(), psrc.getA());
					psrc += incp;
					pdst += incp;
				}
				while(--len > 0);
			}
			else
			{
				do
				{
					copyOrBlendPix(pdst, psrc.getR(), psrc.getG(), psrc.getB(), psrc.getA(), cover);
					psrc += incp;
					pdst += incp;
				}
				while(--len > 0);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendFromColor(from:PixelFormatRenderer, color:RgbaColor, xdst:Int, ydst:Int, xsrc:Int, ysrc:Int, len:Int, cover:Byte):Void
	{
		var psrc = from.getRowPtr(ysrc);
		if(psrc != 0)
		{
			var pdst = _rbuf.getRowPtr(ydst) + (xdst << 2);
			do
			{
				copyOrBlendPix2(pdst, color.r, color.g, color.b, (psrc.getByte() * cover + RgbaColor.BASE_MASK) >> RgbaColor.BASE_SHIFT);
				++psrc;
				pdst += 4;
			}
			while(--len > 0);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function blendFromLut(from:PixelFormatRenderer, colorLut:Vector<RgbaColor>, xdst:Int, ydst:Int, xsrc:Int, ysrc:Int, len:Int, cover:Int):Void
	{
		var psrc = from.getRowPtr(ysrc);
		if(psrc != 0)
		{
			var pdst = _rbuf.getRowPtr(ydst) + (xdst << 2);

			if(cover == 255)
			{
				do
				{
					var color = colorLut[psrc.getByte()];
					copyOrBlendPix2(pdst, color.r, color.g, color.b, color.a);
					++psrc;
					pdst += 4;
				}
				while(--len > 0);
			}
			else
			{
				do
				{
					var color = colorLut[psrc.getByte()];
					copyOrBlendPix(pdst, color.r, color.g, color.b, color.a, cover);
					++psrc;
					pdst += 4;
				}
				while(--len > 0);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function copyOrBlendPix(p:Pointer, cr:Byte, cg:Byte, cb:Byte, alpha:Byte, cover:Byte):Void
	{
		if (cover != 255) 
		{
			if (alpha != 0)			
			{
				alpha = (alpha * (cover + 1)) >> 8;
				if(alpha == RgbaColor.BASE_MASK)
				{
					p.setFull(cr, cg, cb, RgbaColor.BASE_MASK);
				}
				else
				{
					Blender.blendPix(p, cr, cg, cb, alpha, cover);
				}
			}
		}
		else 
		{
			if(alpha != 0)
			{
				if(alpha == RgbaColor.BASE_MASK)
				{
					p.setFull(cr, cg, cb, RgbaColor.BASE_MASK);
				}
				else
				{
					Blender.blendPix(p, cr, cg, cb, alpha, cover);
				}
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function copyOrBlendPix2(p:Pointer, cr:Byte, cg:Byte, cb:Byte, alpha:Byte):Void
	{
		if(alpha != 0)
		{
			if(alpha == RgbaColor.BASE_MASK)
			{
				p.setFull(cr, cg, cb, RgbaColor.BASE_MASK);
			}
			else
			{
				Blender.blendPix(p, cr, cg, cb, alpha);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public static function premultiplyPixel(p:Pointer)
	{
		var r = p.getR();
		var g = p.getG();
		var b = p.getB();
		var a = p.getA();	
		
		if(a < RgbaColor.BASE_MASK)
		{
			if(a == 0)
			{
				r = g = b = 0;
			}
			else 
			{
				r = (r * a + RgbaColor.BASE_MASK) >> RgbaColor.BASE_SHIFT;
				g = (g * a + RgbaColor.BASE_MASK) >> RgbaColor.BASE_SHIFT;
				b = (b * a + RgbaColor.BASE_MASK) >> RgbaColor.BASE_SHIFT;
			}
			p.setFull(r, g, b, a);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public static function demultiplyPixel(p:Pointer):Void
	{
		var r = p.getR();
		var g = p.getG();
		var b = p.getB();
		var a = p.getA();
		
		if(a < RgbaColor.BASE_MASK)
		{
			if(a == 0)
			{
				r = g = b = 0;
			}
			else 
			{
				var rr:Byte = Std.int((r * RgbaColor.BASE_MASK) / a);
				var gg:Byte = Std.int((g * RgbaColor.BASE_MASK) / a);
				var bb:Byte = Std.int((b * RgbaColor.BASE_MASK) / a);
				
				r = (rr > RgbaColor.BASE_MASK) ? RgbaColor.BASE_MASK : rr;
				g = (gg > RgbaColor.BASE_MASK) ? RgbaColor.BASE_MASK : gg;
				b = (bb > RgbaColor.BASE_MASK) ? RgbaColor.BASE_MASK : bb;
			}
			p.setFull(r, g, b, a);
		}
	}	
}