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

package aggx.color;

import aggx.core.memory.Ref;
import aggx.core.math.Calc;

enum SpreadMethod
{
    Pad;
    Reflect;
    Repeat;
}

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

    public var spread: SpreadMethod = SpreadMethod.Pad;
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
	public var interpolator(get, set):ISpanInterpolator;
	//---------------------------------------------------------------------------------------------------
	private inline function get_gradientFunction():IGradientFunction { return _gradientFunction; }
	private inline function set_gradientFunction(value:IGradientFunction):IGradientFunction { return _gradientFunction = value; }
	public var gradientFunction(get, set):IGradientFunction;
	//---------------------------------------------------------------------------------------------------
	private inline function get_colorFunction():IColorFunction { return _colorFunction; }
	private inline function set_colorFunction(value:IColorFunction):IColorFunction { return _colorFunction = value; }
	public var colorFunction(get, set):IColorFunction;
	//---------------------------------------------------------------------------------------------------
	private inline function get_d1():Float { return _d1 / GRADIENT_SUBPIXEL_SCALE; }
	private inline function set_d1(value:Float):Float { return _d1 = Calc.iround(value * GRADIENT_SUBPIXEL_SCALE); }
	public var d1(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_d2():Float { return _d2 / GRADIENT_SUBPIXEL_SCALE; }
	private inline function set_d2(value:Float):Float { return _d2 = Calc.iround(value * GRADIENT_SUBPIXEL_SCALE); }
	public var d2(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	public function prepare():Void { }
	//---------------------------------------------------------------------------------------------------
	public function generate(span:RgbaColorStorage, x_:Int, y_:Int, len:Int):Void
	{
		var dd: Int = _d2 - _d1;
		if (dd < 1) dd = 1;
		var x = Ref.getInt().set(x_);
		var y = Ref.getInt().set(y_);
		var offset = span.offset;
		var _len = len;//codegen bug workaround
		_interpolator.begin(x_ + 0.5, y_ + 0.5, len);
		do
		{
			_interpolator.coordinates(x, y);
			var d: Int = _gradientFunction.calculate(x.value >> DOWNSCALE_SHIFT, y.value >> DOWNSCALE_SHIFT, _d2);

			var temp: Int = ((d - _d1) * _colorFunction.size);
			d =  Calc.intDiv(temp, dd);

            switch(spread)
            {
                case SpreadMethod.Pad:
                    {
                        if(d < 0)
                        {
                            d = 0;
                        }
                        if(d >= _colorFunction.size)
                        {
                            d = _colorFunction.size - 1;
                        }
                    }
                case SpreadMethod.Repeat:
                    {
                        d = d % _colorFunction.size;
                        if (d < 0)
                        {
                            d = _colorFunction.size + d;
                        }
                    }

                case SpreadMethod.Reflect:
                    {
                        d = Calc.abs(d);

                        var even: Bool =  Calc.intDiv(d, _colorFunction.size) % 2 == 0;
                        d = d % _colorFunction.size;

                        if (!even)
                        {
                            d = _colorFunction.size - d - 1;
                        }
                    }
            }

            span.data[offset++] = _colorFunction.get(d);
			_interpolator.op_inc();
		}
		while (--_len != 0);
        Ref.putInt(x);
        Ref.putInt(y);
	}
}