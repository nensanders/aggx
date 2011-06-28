package lib.ha.aggx.color;
import lib.ha.aggx.rasterizer.CoverScale;
//=======================================================================================================
class RgbaColor
{
	//---------------------------------------------------------------------------------------------------
	public static inline var BASE_SHIFT:UInt = 8;
	public static inline var BASE_SCALE:UInt = 1 << BASE_SHIFT;
	public static inline var BASE_MASK:UInt = BASE_SCALE-1;
	//---------------------------------------------------------------------------------------------------
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var a:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(red:Int=0, green:Int=0, blue:Int=0, alpha:Int = 255)	
	{
		r = red;
		g = green;
		b = blue;
		a = alpha;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function fromRgbaColor(color:RgbaColor):RgbaColor
	{
		return new RgbaColor(color.r, color.g, color.b, color.a);
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function fromRgbaColorF(color:RgbaColorF):RgbaColor
	{
		return color.toRgbaColor();
	}	
	//---------------------------------------------------------------------------------------------------
	public static function empty():RgbaColor
	{
		return new RgbaColor(0, 0, 0, 0);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_a():Float { return a / BASE_MASK; }
	private inline function set_a(value:Float):Float
	{
		if(value < 0.0) value = 0.0;
		if(value > 1.0) value = 1.0;
		return a = Std.int(value * BASE_MASK);
	}
	public inline var opacity(get_a, set_a):Float;
	//---------------------------------------------------------------------------------------------------
	public function set(color:RgbaColor):Void
	{
		a = color.a;
		r = color.r;
		g = color.g;
		b = color.b;
	}
	//---------------------------------------------------------------------------------------------------
	public function clear():Void
	{
		r = g = b = a = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function makeTransparent():Void
	{
		a = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function premultiply():RgbaColor
	{
		if(a == BASE_MASK) return this;
		if(a == 0)
		{
			r = g = b = 0;
			return this;
		}
		r = (r * a) >> BASE_SHIFT;
		g = (g * a) >> BASE_SHIFT;
		b = (b * a) >> BASE_SHIFT;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function premultiplyBy(alpha:Int):RgbaColor
	{
		if(a == BASE_MASK && alpha >= BASE_MASK) return this;
		if(a == 0 || alpha == 0)
		{
			r = g = b = a = 0;
			return this;
		}
		var red = Std.int((r * alpha) / a);
		var green = Std.int((g * alpha) / a);
		var blue = Std.int((b * alpha) / a);
		r = ((red > alpha) ? alpha : red);
		g = ((green > alpha) ? alpha : green);
		b = ((blue > alpha) ? alpha : blue);
		a = alpha;
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function demultiply():RgbaColor
	{
		if(a == BASE_MASK) return this;
		if(a == 0)
		{
			r = g = b = 0;
			return this;
		}
		var red = Std.int((r * BASE_MASK) / a);
		var green = Std.int((g * BASE_MASK) / a);
		var blue = Std.int((b * BASE_MASK) / a);
		
		r = ((red > BASE_MASK) ? BASE_MASK : red);
		g = ((green > BASE_MASK) ? BASE_MASK : green);
		b = ((blue > BASE_MASK) ? BASE_MASK : blue);
		return this;
	}
	//---------------------------------------------------------------------------------------------------
	public function gradient(color:RgbaColor, k:Float):RgbaColor
	{
		var ret:RgbaColor = new RgbaColor();
		var ik = Std.int(k * BASE_SCALE);
		ret.r = r + (((color.r - r) * ik) >> BASE_SHIFT);
		ret.g = g + (((color.g - g) * ik) >> BASE_SHIFT);
		ret.b = b + (((color.b - b) * ik) >> BASE_SHIFT);
		ret.a = a + (((color.a - a) * ik) >> BASE_SHIFT);
		return ret;
	}
	//---------------------------------------------------------------------------------------------------
	public function add(color:RgbaColor, cover:Int)
	{
		var cr:Int, cg:Int, cb:Int, ca:Int;
		if(cover == CoverScale.COVER_MASK)
		{
			if(color.a == BASE_MASK)
			{
				set(color);
			}
			else
			{
				cr = r + color.r; r = (cr > BASE_MASK) ? BASE_MASK : cr;
				cg = g + color.g; g = (cg > BASE_MASK) ? BASE_MASK : cg;
				cb = b + color.b; b = (cb > BASE_MASK) ? BASE_MASK : cb;
				ca = a + color.a; a = (ca > BASE_MASK) ? BASE_MASK : ca;
			}
		}
		else
		{
			cr = r + (Std.int(color.r * cover + CoverScale.COVER_MASK / 2) >> CoverScale.COVER_SHIFT);
			cg = g + (Std.int(color.g * cover + CoverScale.COVER_MASK / 2) >> CoverScale.COVER_SHIFT);
			cb = b + (Std.int(color.b * cover + CoverScale.COVER_MASK / 2) >> CoverScale.COVER_SHIFT);
			ca = a + (Std.int(color.a * cover + CoverScale.COVER_MASK / 2) >> CoverScale.COVER_SHIFT);
			
			r = (cr > BASE_MASK) ? BASE_MASK : cr;
			g = (cg > BASE_MASK) ? BASE_MASK : cg;
			b = (cb > BASE_MASK) ? BASE_MASK : cb;
			a = (ca > BASE_MASK) ? BASE_MASK : ca;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function applyGammaDir(gamma:GammaLookupTable):Void
	{
		r = gamma.getDirectGamma(r);
		g = gamma.getDirectGamma(g);
		b = gamma.getDirectGamma(b);
	}
	//---------------------------------------------------------------------------------------------------
	public function applyGammaInv(gamma:GammaLookupTable):Void
	{
		r = gamma.getInverseGamma(r);
		g = gamma.getInverseGamma(g);
		b = gamma.getInverseGamma(b);
	}
}