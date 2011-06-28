package lib.ha.aggx.renderer;
//=======================================================================================================
import lib.ha.aggx.color.RgbaColor;
import lib.ha.aggx.rasterizer.IScanline;
import lib.ha.aggx.rasterizer.ScanlineRasterizer;
import lib.ha.core.memory.MemoryReader;
using lib.ha.core.memory.MemoryReader;
//=======================================================================================================
class SolidScanlineRenderer implements IRenderer
{
	private var _clippingRenderer:ClippingRenderer;
	private var _color:RgbaColor;
	//---------------------------------------------------------------------------------------------------
	public function new(clipRen:ClippingRenderer) 
	{
		_clippingRenderer = clipRen;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(clipRen:ClippingRenderer)
	{
		_clippingRenderer = clipRen;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_color():RgbaColor { return _color; }
	private inline function set_color(value:RgbaColor):RgbaColor { return _color = value; }
	public inline var color(get_color, set_color):RgbaColor;
	//---------------------------------------------------------------------------------------------------
	public function prepare():Void { }
	//---------------------------------------------------------------------------------------------------
	public inline function render(sl:IScanline):Void
	{
		renderAASolidScanline(sl, _clippingRenderer, _color);
	}
	//---------------------------------------------------------------------------------------------------
	public static function renderAASolidScanline(sl:IScanline, render:ClippingRenderer, color:RgbaColor):Void
	{
		var y = sl.y;
		var numSpans = sl.spanCount;
		var spanIterator = sl.spanIterator;

		while(true)
		{
			var span = spanIterator.current;
			var x = span.x;
			if(span.len > 0)
			{
				render.blendSolidHSpan(x, y, span.len, color, span.covers);
			}
			else
			{
				render.blendHLine(x, y, (x - span.len - 1), color, span.covers.getByte());
			}
			if(--numSpans == 0) break;
			spanIterator.next();
		}
	}
	//---------------------------------------------------------------------------------------------------
	public static function renderAASolidScanlines(ras:ScanlineRasterizer, sl:IScanline, ren:ClippingRenderer, color:RgbaColor):Void
	{
		if(ras.rewindScanlines())
		{
			var renColor = color;

			sl.reset(ras.minX, ras.maxX);
			while(ras.sweepScanline(sl))
			{
				var y = sl.y;
				var num_spans = sl.spanCount;
				var spanIterator = sl.spanIterator;

				while(true)
				{
					var span = spanIterator.current;
					var x = span.x;
					if(span.len > 0)
					{
						ren.blendSolidHSpan(x, y, span.len, renColor, span.covers);
					}
					else
					{
						ren.blendHLine(x, y, (x - span.len - 1), renColor, span.covers.getByte());
					}
					if (--num_spans == 0) break;
					spanIterator.next();
				}
			}
		}
	}	
	//---------------------------------------------------------------------------------------------------
	public static function renderScanlines(ras:ScanlineRasterizer, sl:IScanline, ren:IRenderer):Void
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