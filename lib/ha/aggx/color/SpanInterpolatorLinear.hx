package lib.ha.aggx.color;
//=======================================================================================================
import lib.ha.aggx.calculus.Dda2LineInterpolator;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.memory.Ref;
import lib.ha.core.math.Calc;
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
	public inline var transformer(get_transformer, set_transformer):AffineTransformer;
	//---------------------------------------------------------------------------------------------------
	public function begin(x:Float, y:Float, len:Int):Void
	{
		var tx = Ref.float5.set(x);
		var ty = Ref.float6.set(y);

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
		var tx = Ref.float8.set(xe);
		var ty = Ref.float9.set(ye);
		
		_transformer.transform(tx, ty);
		_liX = new Dda2LineInterpolator(_liX.y, Calc.iround(tx.value * SUBPIXEL_SCALE), len);
		_liY = new Dda2LineInterpolator(_liY.y, Calc.iround(ty.value * SUBPIXEL_SCALE), len);	
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