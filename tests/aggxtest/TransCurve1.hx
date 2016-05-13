package tests.aggxtest;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.color.RgbaColor;
import aggx.gui.InteractivePolygon;
import aggx.rasterizer.Scanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.renderer.SolidScanlineRenderer;
import aggx.RenderingBuffer;
import aggx.typography.FontEngine;
import aggx.vectorial.converters.ConvBSpline;
import aggx.vectorial.converters.ConvCurve;
import aggx.vectorial.converters.ConvSegmentator;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.converters.ConvTransform;
import aggx.vectorial.SimplePolygonVertexSource;
import aggx.vectorial.TransSinglePath;
import aggx.rfpx.TrueTypeCollection;
//=======================================================================================================
class TransCurve1 
{
	public static var NUMBER_OF_POINTS:UInt = 8;
	public static var PRESERVE_X_SCALE:Bool = true;
	public static var NUMBER_OF_INTERMEDIATE_POINTS:UInt = 200;
	public static var FIXED_LENGTH:Bool = true;
	public static var CLOSE:Bool = false;
	//---------------------------------------------------------------------------------------------------
	private var _renderingBuffer:RenderingBuffer;
	private var _pixelFormatRenderer:PixelFormatRenderer;
	private var _clippingRenderer:ClippingRenderer;
	private var _scanlineRenderer:SolidScanlineRenderer;
	private var _scanline:Scanline;
	private var _rasterizer:ScanlineRasterizer;
	private var _fontEngine:FontEngine;
	private var _fontSize:UInt;
	private var _string:String;
	private var _poly:InteractivePolygon;
//	private var _dx:Vector<Float>;
//	private var _dy:Vector<Float>;
	private var _path:SimplePolygonVertexSource;
	private var _bspline:ConvBSpline;
	private var _tcurve:TransSinglePath;
	private var _fcurv:ConvCurve;
	private var _fsegm:ConvSegmentator;
	private var _ftrans:ConvTransform;
	private var _stroke:ConvStroke;
	private var _fontScale:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(rbuf:RenderingBuffer, ttc:TrueTypeCollection) 
	{
		_renderingBuffer = rbuf;
		_pixelFormatRenderer = new PixelFormatRenderer(_renderingBuffer);
		_clippingRenderer = new ClippingRenderer(_pixelFormatRenderer);
		_scanline = new Scanline();
		_rasterizer = new ScanlineRasterizer();
		_scanlineRenderer = new SolidScanlineRenderer(_clippingRenderer);
		_fontEngine = new FontEngine(ttc);
		_fontEngine.preCacheFaces(32, 127);
		_fontSize = 40;
		_string = "This is a demo of haXe port of the cool \"Antigrain Geometry\" library.";
		
		_poly = new InteractivePolygon(NUMBER_OF_POINTS, 3.0);
		initPoly();
		
//		_dx = new Vector(6);
//		_dy = new Vector(6);
		_path = new SimplePolygonVertexSource(_poly.polygon, _poly.numberOfPoints, false, CLOSE);
		_bspline = new ConvBSpline(_path);
		_bspline.interpolationStep = 1 / NUMBER_OF_INTERMEDIATE_POINTS;
		_tcurve = new TransSinglePath();
		_fcurv = new ConvCurve(_fontEngine.path);
		_fsegm = new ConvSegmentator(_fcurv);
		_fsegm.approximationScale = 3.0;
		_ftrans = new ConvTransform(_fsegm, _tcurve);
		_fontScale = _fontEngine.getScale(_fontSize);
		_stroke = new ConvStroke(_bspline);
		_stroke.width = 2.0;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function initPoly():Void
	{
        _poly.xn(0, 50);
        _poly.yn(0, 50);
        _poly.xn(1, 150 + 20);
        _poly.yn(1, 150 - 20);
        _poly.xn(2, 250 - 20);
        _poly.yn(2, 250 + 20);
        _poly.xn(3, 350 + 20);
        _poly.yn(3, 350 - 20);
        _poly.xn(4, 450 - 20);
        _poly.yn(4, 450 + 20);
        _poly.xn(5, 550);
        _poly.yn(5, 550);
	}
	//---------------------------------------------------------------------------------------------------
	public function run():Void 
	{	
		draw();
	}
	//---------------------------------------------------------------------------------------------------
	private function draw():Void
	{		
		_tcurve = new TransSinglePath();
		_tcurve.addPath(_bspline);
		_tcurve.preserveXScale = PRESERVE_X_SCALE;
		if (FIXED_LENGTH) 
		{
			_tcurve.baseLength = 1120.;
		}
		_ftrans = new ConvTransform(_fsegm, _tcurve);
		
		var x = 0.;
		var y = 0.;
		
		var c:UInt = _string.length;
		var i:UInt = 0;
		while (i < c)
		{
			if (x > _tcurve.totalLength) break;

			var face = _fontEngine.vectorizeCharacter(_string.charCodeAt(i), _fontSize, x, y);
			_rasterizer.reset();
			_rasterizer.addPath(_ftrans);
			_scanlineRenderer.color = new RgbaColor(27, 106, 240);
			SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _scanlineRenderer);

			x += face.glyph.advanceWidth * _fontScale;
			y = 0;

			++i;
		}
		
		_rasterizer.addPath(_stroke);
		_scanlineRenderer.color = new RgbaColor(136, 207, 100);
		SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _scanlineRenderer);
		
		_rasterizer.addPath(_poly);
		_scanlineRenderer.color = new RgbaColor(136, 20, 50, 140);
		SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _scanlineRenderer);
	}
	//---------------------------------------------------------------------------------------------------
	public function animate():Void
	{
		//initPoly();
		var i:UInt = 0;
		while (i < NUMBER_OF_POINTS)
		{
			var x = _poly.xn(i);
			var y = _poly.yn(i);
			var dx = (((Math.random() * 32768) % 1000) - 500) * 0.04;
			var dy = (((Math.random() * 32768) % 1000) - 500) * 0.04;
			if (x < 0.0) { x = 0.0; dx = -dx; }
			if(x > _renderingBuffer.width) { x = _renderingBuffer.width; dx = -dx; }
			if(y < 0.0) { y = 0.0; dy = -dy; }
			if(y > _renderingBuffer.height) { y = _renderingBuffer.height; dy = -dy; }
			x += dx;
			y += dy;
			_poly.xn(i, x);
			_poly.yn(i, y);
			++i;
		}
		draw();
	}	
}