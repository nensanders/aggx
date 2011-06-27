package lib.ha.aggx.color;
//=======================================================================================================
import lib.ha.aggx.calculus.Dda2LineInterpolator;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.memory.Ref;
import lib.ha.core.utils.Calc;
//=======================================================================================================
class SpanInterpolatorLinearSubdiv implements ISpanInterpolator
{
	private static var SUBPIXEL_SHIFT = 8;
	private static var SUBPIXEL_SCALE = 1 << SUBPIXEL_SHIFT;
	//---------------------------------------------------------------------------------------------------
	private var _transformer:AffineTransformer;
	private var _liX:Dda2LineInterpolator;
	private var _liY:Dda2LineInterpolator;
	private var _subdivShift:Int;
	private var _subdivSize:Int;
	private var _subdivMask:Int;
	private var _srcX:Int;
	private var _srcY:Float;
	private var _pos:Int;
	private var _len:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(trans:AffineTransformer, subdivShift:Int = 4, ?x:Float, ?y:Float, ?len:Int) 
	{
		_transformer = trans;
		_subdivShift = subdivShift;
		_subdivSize = 1 << _subdivShift;
		_subdivMask = _subdivSize-1;
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
	private inline function get_subdivShift():Int { return _subdivShift; }
	private inline function set_subdivShift(value:Int):Int
	{
		_subdivShift = value;
		_subdivSize = 1 << _subdivShift;
		_subdivMask = _subdivSize-1;
		return value;
	}
	public inline var subdivShift(get_subdivShift, set_subdivShift):Int;	
	//---------------------------------------------------------------------------------------------------
	public function begin(x:Float, y:Float, len:Int):Void
	{
		var tx = Ref.float1.set(x);
		var ty = Ref.float2.set(y);

		_pos = 1;
		_srcX = Calc.iround(x * SUBPIXEL_SCALE) + SUBPIXEL_SCALE;
		_srcY = y;
		_len = len;

		if (len > _subdivSize) len = _subdivSize;

		_transformer.transform(tx, ty);
		var x1 = Calc.iround(tx.value * SUBPIXEL_SCALE);
		var y1 = Calc.iround(ty.value * SUBPIXEL_SCALE);

		tx.value = x + len;
		ty.value = y;
		_transformer.transform(tx, ty);

		_liX = new Dda2LineInterpolator(x1, Calc.iround(tx.value * SUBPIXEL_SCALE), len);
		_liY = new Dda2LineInterpolator(y1, Calc.iround(ty.value * SUBPIXEL_SCALE), len);
	}
	//---------------------------------------------------------------------------------------------------
	public function op_inc():Void
	{
		_liX.op_inc();
		_liY.op_inc();

		if(_pos >= _subdivSize)
		{
			var len = _len;
			if (len > _subdivSize) len = _subdivSize;
			var tx = Ref.float1.set(_srcX / SUBPIXEL_SCALE + len);
			var ty = Ref.float2.set(_srcY);
			_transformer.transform(tx, ty);
			_liX = new Dda2LineInterpolator(_liX.y(), Calc.iround(tx.value * SUBPIXEL_SCALE), len);
			_liY = new Dda2LineInterpolator(_liY.y(), Calc.iround(ty.value * SUBPIXEL_SCALE), len);
			_pos = 0;
		}
		_srcX += SUBPIXEL_SCALE;
		++_pos;
		--_len;		
	}
	//---------------------------------------------------------------------------------------------------
	public function coordinates(x:IntRef, y:IntRef):Void
	{
		x.value = _liX.y;
		y.value = _liY.y;
	}
}