package tests.aggxtest;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.calculus.BSpline;
import aggx.color.RgbaColor;
import aggx.color.RgbaColorF;
import aggx.rasterizer.Scanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.renderer.SolidScanlineRenderer;
import aggx.RenderingBuffer;
import aggx.vectorial.converters.ConvTransform;
import aggx.vectorial.Ellipse;
import aggx.core.geometry.AffineTransformer;
import aggx.core.math.Calc;
//=======================================================================================================
class Circles
{
	public static var Z1 = 0.2;//0...1
	public static var Z2 = 0.7;//0...1
	public static var SELECTIVITY = 0.1;//0...1
	public static var SIZE = .4;//0...1
	//---------------------------------------------------------------------------------------------------
	private static var splineRx = [0.000000, 0.200000, 0.400000, 0.910484, 0.957258, 1.000000 ];
	private static var splineRy = [1.000000, 0.800000, 0.600000, 0.066667, 0.169697, 0.600000 ];
	private static var splineGx = [0.000000, 0.292244, 0.485655, 0.564859, 0.795607, 1.000000 ];
	private static var splineGy = [0.000000, 0.607260, 0.964065, 0.892558, 0.435571, 0.000000 ];
	private static var splineBx = [0.000000, 0.055045, 0.143034, 0.433082, 0.764859, 1.000000 ];
	private static var splineBy = [0.385480, 0.128493, 0.021416, 0.271507, 0.713974, 1.000000 ];
	//---------------------------------------------------------------------------------------------------
	private var _renderingBuffer:RenderingBuffer;
	private var _pixelFormatRenderer:PixelFormatRenderer;
	private var _clippingRenderer:ClippingRenderer;
	private var _scanline:Scanline;
	private var _rasterizer:ScanlineRasterizer;
	private var _numberOfPoints:UInt;
	private var _points:Vector<ScatterPoint>;
	private var _splineR:BSpline;
	private var _splineG:BSpline;
	private var _splineB:BSpline;
	//---------------------------------------------------------------------------------------------------
	public function new(rbuf:RenderingBuffer) 
	{
		_renderingBuffer = rbuf;
		_pixelFormatRenderer = new PixelFormatRenderer(_renderingBuffer);
		_clippingRenderer = new ClippingRenderer(_pixelFormatRenderer);
		_scanline = new Scanline();
		_rasterizer = new ScanlineRasterizer();
		_splineR = new BSpline();
		_splineG = new BSpline();
		_splineB = new BSpline();
		_splineR.init(6, splineRx, splineRy);
		_splineG.init(6, splineGx, splineGy);
		_splineB.init(6, splineBx, splineBy);
		_numberOfPoints = 10000;
		_points = new Vector(_numberOfPoints);
	}
	//---------------------------------------------------------------------------------------------------
	public function run():Void 
	{
		generate();
		draw();
	}
	//---------------------------------------------------------------------------------------------------
	public function animate():Void
	{
        var i:UInt = 0;
        while (i < _numberOfPoints)
        {
            _points[i].x += (randomDouble(0, SELECTIVITY) - SELECTIVITY * 0.5) * 100;
            _points[i].y += (randomDouble(0, SELECTIVITY) - SELECTIVITY * 0.5) * 100;
            _points[i].z += randomDouble(0, SELECTIVITY * 0.01) - SELECTIVITY * 0.005;
            if (_points[i].z < 0.0) _points[i].z = 0.0;
            if (_points[i].z > 1.0) _points[i].z = 1.0;
			++i;
        }
		draw();
	}
	//---------------------------------------------------------------------------------------------------
	private function draw():Void
	{
		_clippingRenderer.clear(new RgbaColor(255, 255, 255, 255));
		
		var ellipse = new Ellipse();
		var transform = new ConvTransform(ellipse, AffineTransformer.scaler(1, 1));
		
		var i:UInt = 0;
		var drawn = 0;
		while(i < _numberOfPoints)
		{
			var z = _points[i].z;
			var alpha = 1.0;
			if(z < Z1)
			{
				alpha = 1.0 - (Z1 - z) * SELECTIVITY * 100.0;
			}

			if(z > Z2)
			{
				alpha = 1.0 - (z - Z2) * SELECTIVITY * 100.0;
			}



			if(alpha > 1.0) alpha = 1.0;
			if(alpha < 0.0) alpha = 0.0;

			if(alpha > 0.0)
			{
				ellipse.init(_points[i].x, _points[i].y, SIZE * 5.0, SIZE * 5.0, 8);
				_rasterizer.addPath(transform);

				SolidScanlineRenderer.renderAASolidScanlines(_rasterizer, _scanline, _clippingRenderer, new RgbaColor(_points[i].color.r, _points[i].color.g, _points[i].color.b, Std.int(alpha * RgbaColor.BASE_MASK)));
				drawn++;
			}
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	private function generate():Void
	{
		var rx = _renderingBuffer.width / 3.5;
		var ry = _renderingBuffer.height / 3.5;

		var i:UInt = 0;
		while (i < _numberOfPoints)		
		{
			var p = new ScatterPoint();
			var z = p.z = randomDouble(0.0, 1.0);
			var x = Math.cos(z * Calc.PI2) * rx;
			var y = Math.sin(z * Calc.PI2) * ry;

			var distance  = randomDouble(0.0, rx/2.0);
			var angle = randomDouble(0.0, Calc.PI2);

			p.x = _renderingBuffer.width / 2.0 + x + Math.cos(angle) * distance;
			p.y = _renderingBuffer.height / 2.0 + y + Math.sin(angle) * distance;
			p.color = new RgbaColorF(_splineR.get(z) * 0.8, _splineG.get(z) * 0.8, _splineB.get(z) * 0.8, 1.0).toRgbaColor();
			_points[i] = p;
			++i;
		}
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function randomDouble(start:Float, end:Float):Float
	{
		return Math.random() * (end - start) + start;
	}	
}
//=======================================================================================================
class ScatterPoint
{
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var color:RgbaColor;
	public function new() { }	
}