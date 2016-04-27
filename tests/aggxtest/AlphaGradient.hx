package tests.aggxtest;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.color.GradientCircle;
import aggx.color.GradientXY;
import aggx.color.IAlphaFunction;
import aggx.color.RgbaColor;
import aggx.color.RgbaColorF;
import aggx.color.SpanAllocator;
import aggx.color.SpanConverter;
import aggx.color.SpanGradient;
import aggx.color.SpanGradientAlpha;
import aggx.color.SpanInterpolatorLinear;
import aggx.rasterizer.Scanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.renderer.ScanlineRenderer;
import aggx.renderer.SolidScanlineRenderer;
import aggx.RenderingBuffer;
import aggx.vectorial.Ellipse;
import aggx.vectorial.generators.VcgenStroke;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathFlags;
import aggx.color.ColorArray;
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Byte;
import aggx.core.math.Calc;
//=======================================================================================================
class AlphaGradient
{
	public static var ALPHA:Float = 1;
	//---------------------------------------------------------------------------------------------------
	private var _renderingBuffer:RenderingBuffer;
	private var _pixelFormatRenderer:PixelFormatRenderer;
	private var _clippingRenderer:ClippingRenderer;
	private var _scanlineRenderer:SolidScanlineRenderer;
	private var _scanline:Scanline;
	private var _rasterizer:ScanlineRasterizer;
	private var _x:Vector<Float>;
	private var _y:Vector<Float>;	
	//---------------------------------------------------------------------------------------------------
	public function new(rbuf:RenderingBuffer) 
	{
		_x = new Vector(3);
		_y = new Vector(3);		
		_x[0] = 257; _y[0] = 60;
		_x[1] = 369; _y[1] = 170;
		_x[2] = 143; _y[2] = 310;
		
		_renderingBuffer = rbuf;
		_pixelFormatRenderer = new PixelFormatRenderer(_renderingBuffer);
		_clippingRenderer = new ClippingRenderer(_pixelFormatRenderer);
		_scanline = new Scanline();
		_rasterizer = new ScanlineRasterizer();
		_scanlineRenderer = new SolidScanlineRenderer(_clippingRenderer);
	}
	//---------------------------------------------------------------------------------------------------
	public function run():Void 
	{
		draw();
	}
	//---------------------------------------------------------------------------------------------------
	public function animate():Void
	{
		draw();
	}
	//---------------------------------------------------------------------------------------------------
	private function draw():Void
	{
		_clippingRenderer.clear(new RgbaColor(255, 255, 255));
		
		var ellipse = new Ellipse();
		
		var width = _renderingBuffer.width;
		var height = _renderingBuffer.height;
		
		var i:Int = 0;
		while (i < 100)
		{
			ellipse.init(Math.random() * width, Math.random() * height, Math.random() * 60 + 5, Math.random() * 60 + 5, 50);
			_rasterizer.addPath(ellipse);
			SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer,
				new RgbaColorF(Math.random(), Math.random(), Math.random(), Math.random() / 2.0).toRgbaColor());
			i++;
		}
		var gradientFunction = new GradientCircle();
		var alphaFunction = new GradientXY();
		var gradientMatrix = new AffineTransformer();
		var alphaMatrix = new AffineTransformer();
		var gradientSpanInterpolator = new SpanInterpolatorLinear(gradientMatrix);
		var alphaSpanInterpolator = new SpanInterpolatorLinear(alphaMatrix);
		var spanAllocator = new SpanAllocator();
		var colorArray = new ColorArray(256);
		var alphaArray = new AlphaArray(256);
		var gradientSpan = new SpanGradient(gradientSpanInterpolator, gradientFunction, colorArray, 0, 150);
		var gradientAlphaSpan = new SpanGradientAlpha(alphaSpanInterpolator, alphaFunction, alphaArray, 0, 100);
		var spanConverter = new SpanConverter(gradientSpan, gradientAlphaSpan);
		
		gradientMatrix = gradientMatrix.multiply(AffineTransformer.scaler(0.75, 1.2));
		gradientMatrix = gradientMatrix.multiply(AffineTransformer.rotator( -Calc.PI / 3.0));
		gradientMatrix = gradientMatrix.multiply(AffineTransformer.translator(_renderingBuffer.width / 2, _renderingBuffer.height / 2));
		gradientMatrix.invert();
		
		var parallelogram = new Vector<Float>(6);
		parallelogram[0] = _x[0];
		parallelogram[1] = _y[0];
		parallelogram[2] = _x[1];
		parallelogram[3] = _y[1];
		parallelogram[4] = _x[2];
		parallelogram[5] = _y[2];
		
		alphaMatrix.parlToRect(parallelogram, -100, -100, 100, 100);
		fillColorArray(colorArray, new RgbaColorF(0, 0.19, 0.19).toRgbaColor(), new RgbaColorF(0.7, 0.7, 0.19).toRgbaColor(), new RgbaColorF(0.31, 0, 0).toRgbaColor());
		
		i = 0;
		while (i < 256)
		{
			alphaArray.set(i, i);
			i++;
		}

		ellipse.init(_renderingBuffer.width / 2, _renderingBuffer.height / 2, 150, 150, 100);
		_rasterizer.addPath(ellipse);

		 //Render the circle with gradient plus alpha-gradient
		ScanlineRenderer.renderAAScanlines(_rasterizer, _scanline, _clippingRenderer, spanAllocator, spanConverter);
//
//
		 //Draw the control points and the parallelogram
		//-----------------
		var color_pnt = new RgbaColorF(0, 0.4, 0.4, 0.31).toRgbaColor();
		ellipse.init(_x[0], _y[0], 5, 5, 20);
		_rasterizer.addPath(ellipse);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, color_pnt);
		ellipse.init(_x[1], _y[1], 5, 5, 20);
		_rasterizer.addPath(ellipse);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, color_pnt);
		ellipse.init(_x[2], _y[2], 5, 5, 20);
		_rasterizer.addPath(ellipse);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, color_pnt);

		var stroke = new VcgenStroke();
		stroke.addVertex(_x[0], _y[0], PathCommands.MOVE_TO);
		stroke.addVertex(_x[1], _y[1], PathCommands.LINE_TO);
		stroke.addVertex(_x[2], _y[2], PathCommands.LINE_TO);
		stroke.addVertex(_x[0]+_x[2]-_x[1], _y[0]+_y[2]-_y[1], PathCommands.LINE_TO);
		stroke.addVertex(0, 0, PathCommands.END_POLY | PathFlags.CLOSE);
		_rasterizer.addPath(stroke);
		SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, new RgbaColor(0, 0, 0));
	}
	//---------------------------------------------------------------------------------------------------
	private function fillColorArray(array:ColorArray, begin:RgbaColor, middle:RgbaColor, end:RgbaColor):Void
	{
		var i = 0;
		while (i < 128)		
		{
			var c1 = begin.gradient(middle, i / 128.0);
			array.set(c1, i);
			i++;
		}
		while (i < 256)	
		{
			var c2 = middle.gradient(end, (i - 128) / 128.0);
			array.set(c2, i);
			i++;
		}
	}
}
//=======================================================================================================
class AlphaArray implements IAlphaFunction
{
	private var _alphas:Vector<Byte>;
	//---------------------------------------------------------------------------------------------------
	public function new(size:UInt)
	{
		_alphas = new Vector(size);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_size():UInt { return _alphas.length; }
	public var size(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public function get(idx:UInt):Int
	{
		return _alphas[idx];
	}
	//---------------------------------------------------------------------------------------------------
	public function set(c:Byte, idx:UInt):Void
	{
		_alphas[idx] = c;
	}
}