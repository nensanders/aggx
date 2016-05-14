package tests.aggxtest;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.color.GammaLookupTable;
import aggx.color.GradientX;
import aggx.color.IColorFunction;
import aggx.color.RgbaColor;
import aggx.color.RgbaColorF;
import aggx.color.SpanAllocator;
import aggx.color.SpanGradient;
import aggx.color.SpanGradient;
import aggx.color.ColorArray;
import aggx.color.SpanInterpolatorLinear;
import aggx.rasterizer.IScanline;
import aggx.rasterizer.Scanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.IRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.renderer.ScanlineRenderer;
import aggx.renderer.SolidScanlineRenderer;
import aggx.RenderingBuffer;
import aggx.vectorial.converters.ConvDash;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.Ellipse;
import aggx.vectorial.IVertexSource;
import aggx.vectorial.LineCap;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathFlags;
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Ref;
import aggx.core.math.Calc;
//=======================================================================================================
class AATest
{
	private var _renderingBuffer:RenderingBuffer;
	private var _pixelFormatRenderer:PixelFormatRenderer;
	private var _clippingRenderer:ClippingRenderer;
	private var _scanlineRenderer:SolidScanlineRenderer;
	private var _scanline:Scanline;
	private var _rasterizer:ScanlineRasterizer;
	private var _gamma:GammaLookupTable;
	//---------------------------------------------------------------------------------------------------
	public static var GAMMA:Float = 1.0;//0...3
	//---------------------------------------------------------------------------------------------------
	public function new(rbuf:RenderingBuffer) 
	{
		_renderingBuffer = rbuf;
		_pixelFormatRenderer = new PixelFormatRenderer(_renderingBuffer);
		_clippingRenderer = new ClippingRenderer(_pixelFormatRenderer);
		_scanline = new Scanline();
		_rasterizer = new ScanlineRasterizer();
		_scanlineRenderer = new SolidScanlineRenderer(_clippingRenderer);
		_gamma = new GammaLookupTable();
	}
	//---------------------------------------------------------------------------------------------------
	public function run():Void 
	{
		_clippingRenderer.clear(new RgbaColor(0, 0, 0));
		
		_gamma.gamma = 1.0;
		
		var dash = new DashedLine(_rasterizer, _scanlineRenderer, _scanline);
		var cx = _renderingBuffer.width / 2.0;
		var cy = _renderingBuffer.height / 2.0;

		_scanlineRenderer.color = new RgbaColorF(1.0, 1.0, 1.0, 0.2).toRgbaColor();
		
		var i = 180;
		while (i > 0)
		{
			var n = Calc.PI2 * i / 180.0;
			dash.draw(cx + Math.min(cx, cy) * Math.sin(n), cy + Math.min(cx, cy) * Math.cos(n), cx, cy, 1.0, (i < 90) ? i : 0.0);
			i--;
		}
		
		var gradientFunction = new GradientX();
		var gradientMatrix = new AffineTransformer();
		var spanInterpolator = new SpanInterpolatorLinear(gradientMatrix);
		var spanAllocator = new SpanAllocator();
		var gradientColors = new ColorArray(256);
		var gradientSpan = new SpanGradient(spanInterpolator, gradientFunction, gradientColors, 0, 100);
		var gradientRenderer = new ScanlineRenderer(_clippingRenderer, spanAllocator, gradientSpan);
		var dashGradient = new DashedLine(_rasterizer, gradientRenderer, _scanline);
		
		var x1:Float, y1:Float, x2:Float, y2:Float;
		
		var i = 0;
		while (i < 20)
		{
			_scanlineRenderer.color = new RgbaColorF(1, 1, 1).toRgbaColor();

			var ell = new Ellipse();

			ell.init(20 + i * (i + 1) + 0.5, 20.5, i / 2.0, i / 2.0, 8 + i);
			_rasterizer.reset();
			_rasterizer.addPath(ell);
			SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _scanlineRenderer);

			ell.init(18 + i * 4 + 0.5, 33 + 0.5, i/20.0, i/20.0, 8);
			_rasterizer.reset();
			_rasterizer.addPath(ell);
			SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _scanlineRenderer);

			ell.init(18 + i * 4 + (i-1) / 10.0 + 0.5, 27 + (i - 1) / 10.0 + 0.5, 0.5, 0.5, 8);
			_rasterizer.reset();
			_rasterizer.addPath(ell);
			SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _scanlineRenderer);

			fillColorArray(gradientColors, new RgbaColorF(1, 1, 1).toRgbaColor(), new RgbaColorF(i % 2, (i % 3) * 0.5, (i % 5) * 0.25).toRgbaColor());

			x1 = 20 + i* (i + 1);
			y1 = 40.5;
			x2 = 20 + i * (i + 1) + (i - 1) * 4;
			y2 = 100.5;
			calcLinearGradientTransform(x1, y1, x2, y2, gradientMatrix);
			dashGradient.draw(x1, y1, x2, y2, i, 0);


			fillColorArray(gradientColors, new RgbaColorF(1, 0, 0).toRgbaColor(), new RgbaColorF(0, 0, 1).toRgbaColor());

			x1 = 17.5 + i * 4;
			y1 = 107;
			x2 = 17.5 + i * 4 + i/6.66666667;
			y2 = 107;
			calcLinearGradientTransform(x1, y1, x2, y2, gradientMatrix);
			dashGradient.draw(x1, y1, x2, y2, 1.0, 0);

			x1 = 18 + i * 4;
			y1 = 112.5;
			x2 = 18 + i * 4;
			y2 = 112.5 + i / 6.66666667;
			calcLinearGradientTransform(x1, y1, x2, y2, gradientMatrix);
			dashGradient.draw(x1, y1, x2, y2, 1.0, 0);

			fillColorArray(gradientColors, new RgbaColorF(1, 0, 0).toRgbaColor(), new RgbaColorF(1, 1, 1).toRgbaColor());
			
			x1 = 21.5;
			y1 = 120 + (i - 1) * 3.1;
			x2 = 52.5;
			y2 = 120 + (i - 1) * 3.1;
			calcLinearGradientTransform(x1, y1, x2, y2, gradientMatrix);
			dashGradient.draw(x1, y1, x2, y2, 1.0, 0);

			fillColorArray(gradientColors, new RgbaColorF(0, 1, 0).toRgbaColor(), new RgbaColorF(1, 1, 1).toRgbaColor());
			
			x1 = 52.5;
			y1 = 118 + i * 3;
			x2 = 83.5;
			y2 = 118 + i * 3;
			calcLinearGradientTransform(x1, y1, x2, y2, gradientMatrix);
			dashGradient.draw(x1, y1, x2, y2, 2.0 - (i - 1) / 10.0, 0);

			fillColorArray(gradientColors, new RgbaColorF(0, 0, 1).toRgbaColor(), new RgbaColorF(1, 1, 1).toRgbaColor());
			
			x1 = 83.5;
			y1 = 119 + i * 3;
			x2 = 114.5;
			y2 = 119 + i * 3;
			calcLinearGradientTransform(x1, y1, x2, y2, gradientMatrix);
			dashGradient.draw(x1, y1, x2, y2, 2.0 - (i - 1) / 10.0, 3.0);


			_scanlineRenderer.color = new RgbaColorF(1, 1, 1).toRgbaColor();
			
			if(i <= 10)
			{
				dash.draw(125.5, 119.5 + (i + 2) * (i / 2.0), 135.5, 119.5 + (i + 2) * (i / 2.0), i, 0.0);
			}

			dash.draw(17.5 + i * 4, 192, 18.5 + i * 4, 192, i / 10.0, 0);

			dash.draw(17.5 + i * 4 + (i - 1) / 10.0, 186, 18.5 + i * 4 + (i - 1) / 10.0, 186, 1.0, 0);
					
			i++;
		}
		
		i = 1;
		while (i <= 13)
		{
			fillColorArray(gradientColors, new RgbaColorF(1, 1, 1).toRgbaColor(), new RgbaColorF(i % 2, (i % 3) * 0.5, (i % 5) * 0.25).toRgbaColor());
			calcLinearGradientTransform(_renderingBuffer.width - 150, _renderingBuffer.height - 20 - i * (i + 1.5), _renderingBuffer.width - 20, _renderingBuffer.height - 20 - i * (i + 1), gradientMatrix);
			_rasterizer.reset();
			_rasterizer.moveToD(_renderingBuffer.width - 150, _renderingBuffer.height - 20 - i * (i + 1.5));
			_rasterizer.lineToD(_renderingBuffer.width - 20,  _renderingBuffer.height - 20 - i * (i + 1));
			_rasterizer.lineToD(_renderingBuffer.width - 20, _renderingBuffer.height - 20 - i * (i + 2));
			SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, gradientRenderer);
			i++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function calcLinearGradientTransform(x1:Float, y1:Float, x2:Float, y2:Float, mtx:AffineTransformer, gradient_d2:Float = 100.0):Void
	{
		var dx = x2 - x1;
		var dy = y2 - y1;
		mtx.reset();
		mtx = mtx.multiply(AffineTransformer.scaler(Math.sqrt(dx * dx + dy * dy) / gradient_d2));
		mtx = mtx.multiply(AffineTransformer.rotator(Math.atan2(dy, dx)));
		mtx = mtx.multiply(AffineTransformer.translator(x1 + 0.5, y1 + 0.5));
		mtx.invert();
	}
	//---------------------------------------------------------------------------------------------------
	public function fillColorArray(array:ColorArray, begin:RgbaColor, end:RgbaColor):Void
	{
		var i = 0;
		while (i < 256)
		{
			array.set(begin.gradient(end, i / 255.0), i);
			++i;
		}
	}
}
//=======================================================================================================
class SimpleVertexSource implements IVertexSource
{
	private var _numVertices:Int;
	private var _count:Int;
	private var _x:Vector<Float>;
	private var _y:Vector<Float>;
	private var _cmd:Vector<Int>;
	//---------------------------------------------------------------------------------------------------
	public function new(?x1:Float, ?y1:Float, ?x2:Float, ?y2:Float, ?x3:Float, ?y3:Float)
	{
		_numVertices = 0;
		_count = 0;
		_x = new Vector(8);
		_y = new Vector(8);
		_cmd = new Vector(9);
		_cmd[8] = PathCommands.STOP;
		if (x1 != null && x2 != null && y1 != null && y2 != null && x3 != null && y3 != null)
		{
			init3(x1, y1, x2, y2, x3, y3);
		}
		else if(x1 != null && x2 != null && y1 != null && y2 != null)
		{
			init2(x1, y1, x2, y2);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function init2(x1:Float, y1:Float, x2:Float, y2:Float):Void
	{
		_numVertices = 2;
		_count = 0;
		_x[0] = x1;
		_y[0] = y1;
		_x[1] = x2;
		_y[1] = y2;
		_cmd[0] = PathCommands.MOVE_TO;
		_cmd[1] = PathCommands.LINE_TO;
		_cmd[2] = PathCommands.STOP;
	}
	//---------------------------------------------------------------------------------------------------
	public function init3(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Void
	{
		_numVertices = 3;
		_count = 0;
		_x[0] = x1;
		_y[0] = y1;
		_x[1] = x2;
		_y[1] = y2;
		_x[2] = x3;
		_y[2] = y3;
		_x[3] = _y[3] = _x[4] = _y[4] = 0.0;
		_cmd[0] = PathCommands.MOVE_TO;
		_cmd[1] = PathCommands.LINE_TO;
		_cmd[2] = PathCommands.LINE_TO;
		_cmd[3] = PathCommands.END_POLY | PathFlags.CLOSE;
		_cmd[4] = PathCommands.STOP;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void
	{
		_count = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		x.value = _x[_count];
		y.value = _y[_count];
		return _cmd[_count++];
	}
}
//=======================================================================================================
class DashedLine
{
	private var _rasterizer:ScanlineRasterizer;
	private var _renderer:IRenderer;
	private var _scanline:IScanline;
	private var _src:SimpleVertexSource;
	private var _dash:ConvDash;
	private var _stroke:ConvStroke;
	private var _dashStroke:ConvStroke;
	//---------------------------------------------------------------------------------------------------
	public function new(ras:ScanlineRasterizer, ren:IRenderer, sl:IScanline)
	{
		_rasterizer = ras;
		_renderer = ren;
		_scanline = sl;
		_src = new SimpleVertexSource();
		_dash = new ConvDash(_src);
		_stroke = new ConvStroke(_src);
		_dashStroke = new ConvStroke(_dash);
	}
	//---------------------------------------------------------------------------------------------------
	public function draw(x1:Float, y1:Float, x2:Float, y2:Float, line_width:Float, dash_length:Float):Void
	{
		_src.init2(x1 + 0.5, y1 + 0.5, x2 + 0.5, y2 + 0.5);
		_rasterizer.reset();
		if(dash_length > 0.0)
		{
			_dash.removeAllDashes();
			_dash.addDash(dash_length, dash_length);
			_dashStroke.width = line_width;
			_dashStroke.lineCap = LineCap.ROUND;
			_rasterizer.addPath(_dashStroke);
		}
		else
		{
			_stroke.width = line_width;
			_stroke.lineCap = LineCap.ROUND;
			_rasterizer.addPath(_stroke);
		}
		SolidScanlineRenderer.renderScanlines(_rasterizer, _scanline, _renderer);
	}	
}