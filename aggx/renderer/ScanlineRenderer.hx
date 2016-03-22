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
import aggx.core.memory.MemoryUtils;
import haxe.ds.Vector;
import aggx.color.ISpanAllocator;
import aggx.color.ISpanGenerator;
import aggx.rasterizer.IRasterizer;
import aggx.rasterizer.IScanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.core.memory.MemoryReader;
using aggx.core.memory.MemoryReader;
//=======================================================================================================
class ScanlineRenderer implements IRenderer
{
	private var _ren:ClippingRenderer;
	private var _alloc:ISpanAllocator;
	private var _spanGen:ISpanGenerator;
	//---------------------------------------------------------------------------------------------------
	public function new(ren:ClippingRenderer, alloc:ISpanAllocator, gen:ISpanGenerator) 
	{
		_ren = ren;
		_alloc = alloc;
		_spanGen = gen;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(ren:ClippingRenderer, alloc:ISpanAllocator, gen:ISpanGenerator)
	{
		_ren = ren;
		_alloc = alloc;
		_spanGen = gen;
	}
	//---------------------------------------------------------------------------------------------------
	public function prepare():Void { _spanGen.prepare(); }
	//---------------------------------------------------------------------------------------------------
	public function render(sl:IScanline):Void
	{
		renderAAScanline(sl, _ren, _alloc, _spanGen);
	}
	//---------------------------------------------------------------------------------------------------
	public static function renderAAScanline(sl:IScanline, ren:ClippingRenderer, alloc:ISpanAllocator, spanGen:ISpanGenerator):Void
	{
		var y = sl.y;
		var numSpans = sl.spanCount;
		var spanIter = sl.spanIterator;

		while(true)
		{
			var span = spanIter.current;
			var x = span.x;
			var len = span.len;
			var covers = span.getCovers();

			if(len < 0) len = -len;
			var colors = alloc.allocate(len);
			spanGen.generate(colors, x, y, len);
			ren.blendColorHSpan(x, y, len, colors, (span.len < 0) ? null : covers, covers.readUInt8());

			if (--numSpans == 0) break;
			spanIter.next();
		}
	}
	//---------------------------------------------------------------------------------------------------
	public static function renderAAScanlines(ras:ScanlineRasterizer, sl:IScanline, ren:ClippingRenderer, alloc:ISpanAllocator, spanGen:ISpanGenerator):Void
	{
		if(ras.rewindScanlines())
		{
			sl.reset(ras.minX, ras.maxX);
			spanGen.prepare();
			while(ras.sweepScanline(sl))
			{
				renderAAScanline(sl, ren, alloc, spanGen);
			}
		}
	}	
	//---------------------------------------------------------------------------------------------------
	public static function renderScanlines(ras:IRasterizer, sl:IScanline, ren:IRenderer):Void
	{
		if(ras.rewindScanlines())
		{
			sl.reset(ras.minX, ras.maxX);
			ren.prepare();
			while(ras.sweepScanline(sl))
			{
				ren.render(sl);
			}
		}
	}
}