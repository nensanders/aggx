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

package aggx.core.geometry;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.core.memory.Ref;
import aggx.core.math.Calc;
//=======================================================================================================
class AffineTransformer implements ITransformer
{
	public var sx:Float;
	public var shy:Float;
	public var shx:Float;
	public var sy:Float;
	public var tx:Float;
	public var ty:Float;

    public function toString(): String
    {
        return '{$sx, $shy, $shx, $sy, $tx, $ty}';
    }
	//---------------------------------------------------------------------------------------------------
	public function new(v0:Float = 1.0, v1:Float = 0.0, v2:Float = 0.0, v3:Float = 1.0, v4:Float = 0.0, v5:Float = 0.0) 
	{
		sx = v0;
		shy = v1;
		shx = v2;
		sy = v3;
		tx = v4;
		ty = v5;
	}
	//---------------------------------------------------------------------------------------------------
	public static function of(m:AffineTransformer):AffineTransformer
	{
		return new AffineTransformer(m.sx, m.shy, m.shx, m.sy, m.tx, m.ty);
	}
	//---------------------------------------------------------------------------------------------------
	public static function rotator(a:Float):AffineTransformer
	{
		return new AffineTransformer(Math.cos(a), Math.sin(a), -Math.sin(a), Math.cos(a), 0.0, 0.0);
	}
	//---------------------------------------------------------------------------------------------------
	public static function scaler(x:Float, ?y:Float):AffineTransformer
	{
		if (y == null) 
		{
			y = x;
		}
		return new AffineTransformer(x, 0.0, 0.0, y, 0.0, 0.0);
	}
	//---------------------------------------------------------------------------------------------------
	public static function skewer(x:Float, y:Float) 
	{
		return new AffineTransformer(1.0, Math.tan(y), Math.tan(x), 1.0, 0.0, 0.0);
	}
	//---------------------------------------------------------------------------------------------------
	public static function translator(x:Float, y:Float) 
	{
		return new AffineTransformer(1.0, 0.0, 0.0, 1.0, x, y);
	}
	//---------------------------------------------------------------------------------------------------
	public function set(v0:Float, v1:Float, v2:Float, v3:Float, v4:Float, v5:Float):Void
	{
		sx = v0;
		shy = v1;
		shx = v2;
		sy = v3;
		tx = v4;
		ty = v5;
	}
	//---------------------------------------------------------------------------------------------------
	public function parlToParl(src:Vector<Float>, dst:Vector<Float>):AffineTransformer
	{
		sx = src[2] - src[0];
		shy = src[3] - src[1];
		shx = src[4] - src[0];
		sy = src[5] - src[1];
		tx = src[0];
		ty = src[1];
		invert();
		multiply(new AffineTransformer(dst[2] - dst[0], dst[3] - dst[1], dst[4] - dst[0], dst[5] - dst[1], dst[0], dst[1]));
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function rectToParl(x1:Float, y1:Float, x2:Float, y2:Float, parl:Vector<Float>):AffineTransformer
	{
		var src = new Vector<Float>(6);
		src[0] = x1; src[1] = y1;
		src[2] = x2; src[3] = y1;
		src[4] = x2; src[5] = y2;
		parlToParl(src, parl);
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function parlToRect(parl:Vector<Float>, x1:Float, y1:Float, x2:Float, y2:Float):AffineTransformer
	{
		var dst = new Vector<Float>(6);
		dst[0] = x1; dst[1] = y1;
		dst[2] = x2; dst[3] = y1;
		dst[4] = x2; dst[5] = y2;
		parlToParl(parl, dst);
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function multiply(m:AffineTransformer):AffineTransformer
	{
		var t0 = sx * m.sx + shy * m.shx;
		var t2 = shx * m.sx + sy * m.shx;
		var t4 = tx * m.sx + ty * m.shx + m.tx;
		shy = sx * m.shy + shy * m.sy;
		sy = shx * m.shy + sy * m.sy;
		ty = tx * m.shy + ty * m.sy + m.ty;
		sx = t0;
		shx = t2;
		tx = t4;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function invert():AffineTransformer
	{
		var d = determinantReciprocal;

		var t0 = sy * d;
		sy = sx * d;
		shy = -shy * d;
		shx = -shx * d;

		var t4 = -tx * t0  - ty * shx;
		ty = -tx * shy - ty * sy;

		sx = t0;
		tx = t4;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function flipX():AffineTransformer
	{
		sx = -sx;
		shy = -shy;
		tx = -tx;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function flipY():AffineTransformer
	{
		shx = -shx;
		sy = -sy;
		ty = -ty;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function reset()
	{
		sx  = sy  = 1.0;
		shy = shx = tx = ty = 0.0;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function isIdentity(epsilon:Float = 1e-14):Bool
	{
		return Calc.isEqualEps(sx, 1.0, epsilon) && Calc.isEqualEps(shy, 0.0, epsilon) &&		
			Calc.isEqualEps(shx, 0.0, epsilon) && Calc.isEqualEps(sy, 1.0, epsilon) &&			
			Calc.isEqualEps(tx, 0.0, epsilon) && Calc.isEqualEps(ty, 0.0, epsilon);			
	}
	//---------------------------------------------------------------------------------------------------
	public function isValid(epsilon:Float = 1e-14):Bool
	{
		return Calc.fabs(sx) > epsilon && Calc.fabs(sy) > epsilon;
	}
	//---------------------------------------------------------------------------------------------------
	public function isEqual(m:AffineTransformer, epsilon:Float = 1e-14):Bool
	{
		return Calc.isEqualEps(sx, m.sx, epsilon) && Calc.isEqualEps(shy, m.shy, epsilon) &&		
			Calc.isEqualEps(shx, m.shx, epsilon) && Calc.isEqualEps(sy, m.sy, epsilon) &&			
			Calc.isEqualEps(tx, m.tx, epsilon) && Calc.isEqualEps(ty, m.ty, epsilon);			
	}	
	//---------------------------------------------------------------------------------------------------
	public function transform(x:FloatRef, y:FloatRef):Void
	{
		var tmp = x.value;
		x.value = tmp * sx  + y.value * shx + tx;
		y.value = tmp * shy + y.value * sy  + ty;
	}
	//---------------------------------------------------------------------------------------------------
	public function transform2x2(x:FloatRef, y:FloatRef):Void
	{
		var tmp = x.value;
		x.value = tmp * sx  + y.value * shx;
		y.value = tmp * shy + y.value * sy;
	}
	//---------------------------------------------------------------------------------------------------
	public function transformInverse(x:FloatRef, y:FloatRef):Void
	{
		var d = determinantReciprocal;
		var a = (x.value - tx) * d;
		var b = (y.value - ty) * d;
		x.value = a * sy - b * shx;
		y.value = b * sx - a * shy;
	}
	//---------------------------------------------------------------------------------------------------
	public function setScaling(x:Float, ?y:Float):AffineTransformer
	{
		if (y != null)		
		{
			var mm0 = x;
			var mm3 = y;
			sx *= mm0;
			shx *= mm0;
			tx *= mm0;
			shy *= mm3;
			sy *= mm3;
			ty *= mm3;			
		}
		else 
		{
			var m = x;
			sx *= m;
			shx *= m;
			tx *= m;
			shy *= m;
			sy *= m;
			ty *= m;
		}
		return this;
	}	
	//---------------------------------------------------------------------------------------------------
	public function setTranslation(x:Float, y:Float):AffineTransformer
	{
		tx += x;
		ty += y;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function setRotation(a:Float):AffineTransformer
	{
		var ca = Math.cos(a);
		var sa = Math.sin(a);
		var t0 = sx  * ca - shy * sa;
		var t2 = shx * ca - sy * sa;
		var t4 = tx  * ca - ty * sa;
		shy = sx  * sa + shy * ca;
		sy  = shx * sa + sy * ca;
		ty  = tx  * sa + ty * ca;
		sx  = t0;
		shx = t2;
		tx  = t4;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function premultiply(m:AffineTransformer):AffineTransformer
	{
		var t = AffineTransformer.of(m);
		var t0 = t.multiply(this);
		set(t0.sx, t0.shy, t0.shx, t0.sy, t0.tx, t0.ty);
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function multiplyInverse(m:AffineTransformer):AffineTransformer
	{
		var t = AffineTransformer.of(m);
		t.invert();
		return multiply(t);
	}
	//---------------------------------------------------------------------------------------------------
	public function premultiplyInverse(m:AffineTransformer):AffineTransformer
	{
		var t = AffineTransformer.of(m);
		t.invert();
		var t0 = t.multiply(this);
		set(t0.sx, t0.shy, t0.shx, t0.sy, t0.tx, t0.ty);
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function scaleAbs(x:FloatRef, y:FloatRef):Void
	{
		x.value = Math.sqrt(sx * sx + shx * shx);
		y.value = Math.sqrt(shy * shy + sy * sy);
	}	
	//---------------------------------------------------------------------------------------------------
	public function translate(dx:FloatRef, dy:FloatRef):Void
	{
		dx.value = tx;
		dy.value = ty;
	}
	//---------------------------------------------------------------------------------------------------
	public function scale(x:FloatRef, y:FloatRef):Void
	{
		var x1 = Ref.getFloat().set(0.0);
		var y1 = Ref.getFloat().set(0.0);
		var x2 = Ref.getFloat().set(1.0);
		var y2 = Ref.getFloat().set(1.0);
		var t = AffineTransformer.of(this);
		t = t.multiply(AffineTransformer.rotator(-rotation));
		t.transform(x1, y1);
		t.transform(x2, y2);
		x.value = Ref.putFloat(x2).value - Ref.putFloat(x1).value;
		y.value = Ref.putFloat(y2).value - Ref.putFloat(y1).value;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_determinant():Float { return sx * sy - shy * shx; }
	public var determinant(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_determinantReciprocal():Float { return 1.0 / (sx * sy - shy * shx); }
	public var determinantReciprocal(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_scaling():Float 
	{
		var x = 0.707106781 * sx  + 0.707106781 * shx;
		var y = 0.707106781 * shy + 0.707106781 * sy;
		return Math.sqrt(x * x + y * y);
	}
	public var scaling(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_rotation():Float 
	{
        var x1 = Ref.getFloat().set(0.0);
        var y1 = Ref.getFloat().set(0.0);
        var x2 = Ref.getFloat().set(1.0);
        var y2 = Ref.getFloat().set(0.0);
		transform(x1, y1);
		transform(x2, y2);
		return Math.atan2(Ref.putFloat(y2).value - Ref.putFloat(y1).value, Ref.putFloat(x2).value - Ref.putFloat(x1).value);
	}
	public var rotation(get, null):Float;
}