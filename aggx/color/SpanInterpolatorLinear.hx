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
//=======================================================================================================
import aggx.calculus.Dda2LineInterpolator;
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Ref;
import aggx.core.math.Calc;
//=======================================================================================================
class SpanInterpolatorLinear implements ISpanInterpolator
{
	private static inline var SUBPIXEL_SHIFT = 8;
	private static inline var SUBPIXEL_SCALE = 1 << SUBPIXEL_SHIFT;
	//---------------------------------------------------------------------------------------------------
	private var _transformer:AffineTransformer;
	private var _liX:Dda2LineInterpolator;
	private var _liY:Dda2LineInterpolator;
	//---------------------------------------------------------------------------------------------------
	public function new(trans:AffineTransformer, ?x:Float, ?y:Float, ?len:Int) 
	{
		_transformer = trans;
		if (x != null && y != null && len != null) 
		{
			begin(x, y, len);
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_transformer():AffineTransformer { return _transformer; }
	private inline function set_transformer(value:AffineTransformer):AffineTransformer { return _transformer = value; }
	public var transformer(get, set):AffineTransformer;
	//---------------------------------------------------------------------------------------------------
	public function begin(x:Float, y:Float, len:Int):Void
	{
		var tx = Ref.getFloat().set(x);
		var ty = Ref.getFloat().set(y);

		_transformer.transform(tx, ty);

		var x1:Int = Calc.iround(tx.value * SUBPIXEL_SCALE);
		var y1:Int = Calc.iround(ty.value * SUBPIXEL_SCALE);

		tx.value = x + len;
		ty.value = y;

		_transformer.transform(tx, ty);

		var x2 = Calc.iround(tx.value * SUBPIXEL_SCALE);
		var y2 = Calc.iround(ty.value * SUBPIXEL_SCALE);

		_liX = new Dda2LineInterpolator(x1, x2, len);
		_liY = new Dda2LineInterpolator(y1, y2, len);
	}
	//---------------------------------------------------------------------------------------------------
	public function resynchronize(xe:Float, ye:Float, len:Int):Void
	{
		var tx = Ref.getFloat().set(xe);
		var ty = Ref.getFloat().set(ye);
		
		_transformer.transform(tx, ty);

		_liX = new Dda2LineInterpolator(_liX.y, Calc.iround(Ref.putFloat(tx).value * SUBPIXEL_SCALE), len);
		_liY = new Dda2LineInterpolator(_liY.y, Calc.iround(Ref.putFloat(ty).value * SUBPIXEL_SCALE), len);
	}
	//---------------------------------------------------------------------------------------------------
	public function op_inc():Void
	{
		_liX.op_inc();
		_liY.op_inc();
	}
	//---------------------------------------------------------------------------------------------------
	public function coordinates(x:IntRef, y:IntRef):Void
	{
		x.value = _liX.y;
		y.value = _liY.y;
	}
}