package ;
//=======================================================================================================
import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import flash.Vector;
import lib.ha.aggx.color.RgbaColor;
import lib.ha.aggx.gui.InteractivePolygon;
import lib.ha.aggx.rasterizer.Scanline;
import lib.ha.aggx.rasterizer.ScanlineRasterizer;
import lib.ha.aggx.renderer.ClippingRenderer;
import lib.ha.aggx.renderer.PixelFormatRenderer;
import lib.ha.aggx.renderer.SolidScanlineRenderer;
import lib.ha.aggx.typography.FontEngine;
import lib.ha.aggx.vectorial.converters.ConvBSpline;
import lib.ha.aggx.vectorial.converters.ConvCurve;
import lib.ha.aggx.vectorial.converters.ConvDash;
import lib.ha.aggx.vectorial.converters.ConvSegmentator;
import lib.ha.aggx.vectorial.converters.ConvStroke;
import lib.ha.aggx.vectorial.converters.ConvTransform;
import lib.ha.aggx.vectorial.LineCap;
import lib.ha.aggx.vectorial.SimplePolygonVertexSource;
import lib.ha.aggx.vectorial.TransSinglePath;
import lib.ha.aggx.vectorial.VectorPath;
import lib.ha.aggxtest.AADemo;
import lib.ha.aggxtest.AATest;
import lib.ha.aggxtest.AlphaGradient;
import lib.ha.aggxtest.Circles;
import lib.ha.aggxtest.TransCurve1;
import lib.ha.core.geometry.RectBox;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.MemoryManager;
import lib.ha.core.memory.RgbaReaderWriter;
import lib.ha.rfpx.TrueTypeCollection;
import lib.ha.rfpx.TrueTypeLoader;
using lib.ha.core.memory.RgbaReaderWriter;
import lib.ha.core.utils.PerfCounter;
import lib.ha.aggx.RenderingBuffer;
//=======================================================================================================
class Main
{
	//---------------------------------------------------------------------------------------------------
	static var pixelBufferWidth:UInt = 800;
	static var pixelBufferHeight:UInt = 600;
	static var pixelBufferSize:UInt = pixelBufferWidth * pixelBufferHeight * 4;
	//---------------------------------------------------------------------------------------------------
	static var pixelBuffer:MemoryBlock = MemoryManager.malloc(pixelBufferSize);
	static var renderingBuffer = new RenderingBuffer(pixelBuffer, pixelBufferWidth, pixelBufferHeight, pixelBufferWidth * 4);
	static var pixelFormatRenderer = new PixelFormatRenderer(renderingBuffer);
	static var clippingRenderer = new ClippingRenderer(pixelFormatRenderer);
	static var scanline = new Scanline();
	static var rasterizer = new ScanlineRasterizer();
	static var scanlineRenderer = new SolidScanlineRenderer(clippingRenderer);
	//---------------------------------------------------------------------------------------------------
	static var bitmapRectangle = new Rectangle(0, 0, pixelBufferWidth, pixelBufferHeight);
	static var bitmapData = new BitmapData(pixelBufferWidth, pixelBufferHeight);
	static var bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER, false);
	//---------------------------------------------------------------------------------------------------
	static function main() 
	{
		clippingRenderer.clear(new RgbaColor(255, 255, 255));

		//t0();
		//t4();
		//t5();
		//t6();
		//t7();
		//t8();
		t9();
		
		Lib.current.addChild(bitmap);
	}
	//---------------------------------------------------------------------------------------------------
	static inline function blit():Void
	{
		MemoryBlock.blit(pixelBuffer, bitmapData, bitmapRectangle);
	}
	//---------------------------------------------------------------------------------------------------
	static function t0():Void
	{
		var loader = new TrueTypeLoader("c:\\times.ttf");
		loader.load(t1);
		//loader.load(t2);
	}
	//---------------------------------------------------------------------------------------------------
	static function t1(ttc:TrueTypeCollection):Void
	{
		var string1 = "ABCDEFGHJIKLMNOPQRSTUVWXYZ";
		var string2 = "abcdefghjiklmnopqrstuvwxyz";
		var string3 = "1234567890";
		var string4 = "!@#$%^&*()_+|{}:?><~`';/.,";
		var string5 = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦШЩЭЮЯ";
		var string6 = "абвгдеёжзийклмнопрстуфхцшщэюя";
		
		var fontEngine = new FontEngine(ttc);
		var fontSize = 18;

		scanlineRenderer.color = new RgbaColor(240, 27, 106);

		var x = 10;
		var y = 50;
		
		fontEngine.renderString(string1, fontSize, x, y, scanlineRenderer);
		
		scanlineRenderer.color = new RgbaColor(27, 106, 240);

		var x = 10;
		var y = 70;
		
		fontEngine.renderString(string2, fontSize, x, y, scanlineRenderer);
		
		scanlineRenderer.color = new RgbaColor(227, 200, 26);

		var x = 10;
		var y = 90;
		
		fontEngine.renderString(string3, fontSize, x, y, scanlineRenderer);
		
		scanlineRenderer.color = new RgbaColor(106, 27, 240);

		var x = 10;
		var y = 110;
		
		fontEngine.renderString(string4, fontSize, x, y, scanlineRenderer);
		
		scanlineRenderer.color = new RgbaColor(136, 207, 100);

		var x = 10;
		var y = 130;
		
		fontEngine.renderString(string5, fontSize, x, y, scanlineRenderer);
		
		scanlineRenderer.color = new RgbaColor(136, 20, 50);

		var x = 10;
		var y = 150;
	
		fontEngine.renderString(string6, fontSize, x, y, scanlineRenderer);
		
		blit();
	}
	//---------------------------------------------------------------------------------------------------
	static function t2(ttc:TrueTypeCollection):Void
	{
		var t = new TransCurve1(renderingBuffer, ttc);
		t.run();
		
		Lib.current.addEventListener(Event.ENTER_FRAME, function(e:Event) {
			clippingRenderer.clear(new RgbaColor(255, 255, 255));
			t.animate();
			blit();
		});
	}
	//---------------------------------------------------------------------------------------------------
	static function t3():Void
	{
		var t = new AlphaGradient(renderingBuffer);
		
		t.run();
		
		blit();
	}
	//---------------------------------------------------------------------------------------------------
	static function t4():Void
	{
		var t = new AADemo(renderingBuffer);
		t.run();
		blit();
	}
	//---------------------------------------------------------------------------------------------------
	static function t5():Void
	{
		var t = new AATest(renderingBuffer);
		t.run();
		blit();
	}
	//---------------------------------------------------------------------------------------------------
	static function t6():Void
	{
		var pixelOffset = 0.5;
		var tr = 10.;
		
		var path = new VectorPath();
		
		path.removeAll();
		
		path.moveTo(tr + pixelOffset, tr + pixelOffset);
		path.lineTo(pixelBufferWidth + pixelOffset - tr, tr + pixelOffset);
		path.lineTo(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr);
		path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
		path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
		path.curve4(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr, pixelBufferWidth + pixelOffset - tr, pixelOffset + tr, pixelOffset + tr, pixelOffset + tr);
		path.closePolygon();
		
		var curve = new ConvCurve(path);
		var stroke = new ConvStroke(curve);
		
		stroke.width = 0.3;
		rasterizer.addPath(stroke);	
		
		scanlineRenderer.color = new RgbaColor(255, 0, 0, 128);
		SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
		
		rasterizer.addPath(curve);
		scanlineRenderer.color = new RgbaColor(255, 0, 0, 20);
		SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
		
		blit();
	}
	//---------------------------------------------------------------------------------------------------
	static function t7():Void
	{
		var pixelOffset = 0.5;
		var tr = 10.;
		
		var path = new VectorPath();
		
		path.removeAll();
		path.moveTo(tr + pixelOffset, tr + pixelOffset);
		path.lineTo(pixelBufferWidth + pixelOffset - tr, tr + pixelOffset);
		path.lineTo(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr);
		path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
		path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
		path.curve4(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr, pixelBufferWidth + pixelOffset - tr, pixelOffset + tr, pixelOffset + tr, pixelOffset + tr);
		path.closePolygon();		
		
		var curve = new ConvCurve(path);
		var dash = new ConvDash(curve);
		var stroke = new ConvStroke(dash);
		
		dash.addDash(10, 10);
		stroke.width = 5;
		stroke.lineCap = LineCap.ROUND;
		rasterizer.addPath(curve);
		
		scanlineRenderer.color = new RgbaColor(160, 180, 80, 80);
		SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
		
		rasterizer.addPath(stroke);
		scanlineRenderer.color = new RgbaColor(120, 100, 0);
		SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
		
		blit();
	}
	//---------------------------------------------------------------------------------------------------
	static function t8():Void
	{
		var pixelOffset = 0.5;
		var tr = 10.;
		
		var path = new VectorPath();
		
		path.removeAll();
		path.moveTo(tr + pixelOffset, tr + pixelOffset);
		path.lineTo(pixelBufferWidth + pixelOffset - tr, tr + pixelOffset);
		path.lineTo(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr);
		path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
		path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
		path.curve4(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr, pixelBufferWidth + pixelOffset - tr, pixelOffset + tr, pixelOffset + tr, pixelOffset + tr);
		path.closePolygon();		
		
		var curve = new ConvCurve(path);
		var stroke0 = new ConvStroke(curve);
		
		var dash = new ConvDash(stroke0);
		var stroke = new ConvStroke(dash);
		
		stroke0.width = 5;
		stroke0.lineCap = LineCap.ROUND;
		
		dash.addDash(10, 10);
		
		stroke.width = 1;
		stroke.lineCap = LineCap.ROUND;
		
		rasterizer.addPath(curve);
		
		scanlineRenderer.color = new RgbaColor(160, 180, 80, 80);
		SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
		
		rasterizer.addPath(stroke);
		scanlineRenderer.color = new RgbaColor(120, 100, 0);
		SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
		
		blit();	
	}
	//---------------------------------------------------------------------------------------------------
	static function t9():Void
	{
		var t = new Circles(renderingBuffer);
		t.run();
		blit();
	}
}