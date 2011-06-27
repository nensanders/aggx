package lib.ha.aggx.color;
//=======================================================================================================
import lib.ha.core.memory.Ref;
import lib.ha.core.math.Calc;
//=======================================================================================================
class SpanGradient implements ISpanGenerator
{
	public static var GRADIENT_SUBPIXEL_SHIFT = 4;
	public static var GRADIENT_SUBPIXEL_SCALE = 1 << GRADIENT_SUBPIXEL_SHIFT;
	public static var GRADIENT_SUBPIXEL_MASK = GRADIENT_SUBPIXEL_SCALE-1;
	//---------------------------------------------------------------------------------------------------
	public static var DOWNSCALE_SHIFT = 8 - GRADIENT_SUBPIXEL_SHIFT;
	//---------------------------------------------------------------------------------------------------
	private var _interpolator:ISpanInterpolator;
	private var _gradientFunction:IGradientFunction;
	private var _colorFunction:IColorFunction;
	private var _d1:Int;
	private var _d2:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(inter:ISpanInterpolator, gradientFunc:IGradientFunction, colorFunc:IColorFunction, d1_:Float, d2_:Float)	
	{
		_interpolator = inter;
		_gradientFunction = gradientFunc;
		_colorFunction = colorFunc;
		_d1 = Calc.iround(d1_ * GRADIENT_SUBPIXEL_SCALE);
		_d2 = Calc.iround(d2_ * GRADIENT_SUBPIXEL_SCALE);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_interpolator():ISpanInterpolator { return _interpolator; }
	private inline function set_interpolator(value:ISpanInterpolator):ISpanInterpolator { return _interpolator = value; }
	public inline var interpolator(get_interpolator, set_interpolator):ISpanInterpolator;
	//---------------------------------------------------------------------------------------------------
	private inline function get_gradientFunction():IGradientFunction { return _gradientFunction; }
	private inline function set_gradientFunction(value:IGradientFunction):IGradientFunction { return _gradientFunction = value; }
	public inline var gradientFunction(get_gradientFunction, set_gradientFunction):IGradientFunction;
	//---------------------------------------------------------------------------------------------------
	private inline function get_colorFunction():IColorFunction { return _colorFunction; }
	private inline function set_colorFunction(value:IColorFunction):IColorFunction { return _colorFunction = value; }
	public inline var colorFunction(get_colorFunction, set_colorFunction):IColorFunction;
	//---------------------------------------------------------------------------------------------------
	private inline function get_d1():Float { return _d1 / GRADIENT_SUBPIXEL_SCALE; }
	private inline function set_d1(value:Float):Float { return _d1 = Calc.iround(value * GRADIENT_SUBPIXEL_SCALE); }
	public inline var d1(get_d1, set_d1):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_d2():Float { return _d2 / GRADIENT_SUBPIXEL_SCALE; }
	private inline function set_d2(value:Float):Float { return _d2 = Calc.iround(value * GRADIENT_SUBPIXEL_SCALE); }
	public inline var d2(get_d2, set_d2):Float;
	//---------------------------------------------------------------------------------------------------
	public function prepare():Void { }
	//---------------------------------------------------------------------------------------------------
	public function generate(span:RgbaColorStorage, x_:Int, y_:Int, len:Int):Void
	{
		var dd = _d2 - _d1;
		if (dd < 1) dd = 1;
		var x = Ref.int1.set(x_);
		var y = Ref.int2.set(y_);
		var offset = span.offset;
		_interpolator.begin(x_ + 0.5, y_ + 0.5, len);
		do
		{
			_interpolator.coordinates(x, y);
			var d = _gradientFunction.calculate(x.value >> DOWNSCALE_SHIFT, y.value >> DOWNSCALE_SHIFT, _d2);
			d = Std.int(((d - _d1) * _colorFunction.size) / dd);
			if(d < 0) d = 0;
			if(d >= cast _colorFunction.size) d = _colorFunction.size - 1;
			span.data[offset++] = _colorFunction.get(d);
			_interpolator.op_inc();
		}
		while (--len != 0);
	}
}