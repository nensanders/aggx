package tests.aggxtest;
//=======================================================================================================
import aggx.core.memory.MemoryUtils;
import haxe.ds.Vector;
import aggx.color.RgbaColor;
import aggx.rasterizer.GammaNone;
import aggx.rasterizer.GammaPower;
import aggx.rasterizer.IScanline;
import aggx.rasterizer.Scanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.IRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.renderer.SolidScanlineRenderer;
import aggx.RenderingBuffer;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.VectorPath;
import aggx.core.memory.MemoryReader;
using aggx.core.memory.MemoryReader;
//=======================================================================================================
class AADemo
{
	private var _renderingBuffer:RenderingBuffer;
	private var _pixelFormatRenderer:PixelFormatRenderer;
	private var _clippingRenderer:ClippingRenderer;
	private var _scanline:Scanline;
	private var _rasterizer:ScanlineRasterizer;
	private var _enlargingRenderer:EnlargedRenderer;
	private var _x:Vector<Float>;
	private var _y:Vector<Float>;
	//---------------------------------------------------------------------------------------------------
	public static var PIXEL_SIZE:Float = 18;//1...32
	public static var GAMMA:Float = 1.0;//0...3
	//---------------------------------------------------------------------------------------------------
	public function new(rbuf:RenderingBuffer)
	{
		_x = new Vector(3);
		_y = new Vector(3);
		_x[0] = 57; _y[0] = 100;
		_x[1] = 369; _y[1] = 170;
		_x[2] = 143; _y[2] = 310;
		
		_renderingBuffer = rbuf;
		_pixelFormatRenderer = new PixelFormatRenderer(_renderingBuffer);
		_clippingRenderer = new ClippingRenderer(_pixelFormatRenderer);
		_scanline = new Scanline();
		_rasterizer = new ScanlineRasterizer();
		_enlargingRenderer = new EnlargedRenderer(_clippingRenderer, PIXEL_SIZE);
	}
	//---------------------------------------------------------------------------------------------------
	public function run():Void 
	{
		_rasterizer.gamma(new GammaPower(GAMMA));
		
		_rasterizer.reset();
		_rasterizer.moveToD(_x[0] / PIXEL_SIZE, _y[0] / PIXEL_SIZE);
		_rasterizer.lineToD(_x[1] / PIXEL_SIZE, _y[1] / PIXEL_SIZE);
		_rasterizer.lineToD(_x[2] / PIXEL_SIZE, _y[2] / PIXEL_SIZE);
		_enlargingRenderer.color(new RgbaColor(0, 0, 0, 255));
		
		SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _enlargingRenderer);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, new RgbaColor(0, 0, 0));
		
		_rasterizer.gamma(new GammaNone());
		
		var ps = new VectorPath();
		var pg = new ConvStroke(ps);
		pg.width = 2.0;

		ps.removeAll();
		ps.moveTo(_x[0], _y[0]);
		ps.lineTo(_x[1], _y[1]);
		_rasterizer.addPath(pg);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, new RgbaColor(0, 150, 160, 200));

		ps.removeAll();
		ps.moveTo(_x[1], _y[1]);
		ps.lineTo(_x[2], _y[2]);
		_rasterizer.addPath(pg);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, new RgbaColor(0, 150, 160, 200));

		ps.removeAll();
		ps.moveTo(_x[2], _y[2]);
		ps.lineTo(_x[0], _y[0]);
		_rasterizer.addPath(pg);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, new RgbaColor(0, 150, 160, 200));
	}
}
//=======================================================================================================
class Square
{
	private var _size:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(size:Float)
	{
		_size = size;
	}
	//---------------------------------------------------------------------------------------------------
	public function draw(ras:ScanlineRasterizer, sl:IScanline, ren:ClippingRenderer, color:RgbaColor, x:Float, y:Float):Void
	{
		ras.reset();
		ras.moveToD(x * _size, y * _size);
		ras.lineToD(x * _size + _size, y * _size);
		ras.lineToD(x * _size + _size, y * _size + _size);
		ras.lineToD(x * _size, y * _size + _size);
		SolidScanlineRenderer.renderAASolidScanlines(ras, sl, ren, color);
	}	
}
//=======================================================================================================
class EnlargedRenderer implements IRenderer
{
	private var _ras:ScanlineRasterizer;
	private var _sl:Scanline;
	private var _ren:ClippingRenderer;
	private var _square:Square;
	private var _color:RgbaColor;
	private var _size:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(ren:ClippingRenderer, size:Float)
	{
		_ren = ren;
		_square = new Square(size);
		_ras = new ScanlineRasterizer();
		_sl = new Scanline();
		_size = size;
	}
	//---------------------------------------------------------------------------------------------------
	public function color(?c:RgbaColor):RgbaColor { return _color = c; }
	//---------------------------------------------------------------------------------------------------
	public function prepare():Void { }
	//---------------------------------------------------------------------------------------------------
	public function render(sl:IScanline):Void
	{
		var y = sl.y;

		var num_spans = sl.spanCount;
		var spanIterator = sl.spanIterator;

		do
		{
			var s = spanIterator.current;//spanIterator.data[span.offset];
			var x = s.x;
			var covers = s.getCovers();
			var num_pix = s.len;

			do
			{
				var a = (covers.readUInt8() * _color.a) >> 8;
				covers.offset++;
				_square.draw(_ras, _sl, _ren, new RgbaColor(_color.r, _color.g, _color.b, a), x, y);
				++x;
			}
			while (--num_pix != 0);
			//span.offset++;
			spanIterator.next();
		}
		while(--num_spans != 0);
	}
}