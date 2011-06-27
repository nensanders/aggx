package lib.ha.core.utils;
//=======================================================================================================
import flash.Memory;
//=======================================================================================================
class Bits 
{
	inline public static var BIT_01 = 1 << 00;
	inline public static var BIT_02 = 1 << 01;
	inline public static var BIT_03 = 1 << 02;
	inline public static var BIT_04 = 1 << 03;
	inline public static var BIT_05 = 1 << 04;
	inline public static var BIT_06 = 1 << 05;
	inline public static var BIT_07 = 1 << 06;
	inline public static var BIT_08 = 1 << 07;
	inline public static var BIT_09 = 1 << 08;
	inline public static var BIT_10 = 1 << 09;
	inline public static var BIT_11 = 1 << 10;
	inline public static var BIT_12 = 1 << 11;
	inline public static var BIT_13 = 1 << 12;
	inline public static var BIT_14 = 1 << 13;
	inline public static var BIT_15 = 1 << 14;
	inline public static var BIT_16 = 1 << 15;
	inline public static var BIT_17 = 1 << 16;
	inline public static var BIT_18 = 1 << 17;
	inline public static var BIT_19 = 1 << 18;
	inline public static var BIT_20 = 1 << 19;
	inline public static var BIT_21 = 1 << 20;
	inline public static var BIT_22 = 1 << 21;
	inline public static var BIT_23 = 1 << 22;
	inline public static var BIT_24 = 1 << 23;
	inline public static var BIT_25 = 1 << 24;
	inline public static var BIT_26 = 1 << 25;
	inline public static var BIT_27 = 1 << 26;
	inline public static var BIT_28 = 1 << 27;
	inline public static var BIT_29 = 1 << 28;
	inline public static var BIT_30 = 1 << 29;
	inline public static var BIT_31 = 1 << 30;
	inline public static var BIT_32 = 1 << 31;
	inline public static var ALL = -1;
	//---------------------------------------------------------------------------------------------------
	inline public static var INT_BITS =	32;
	//---------------------------------------------------------------------------------------------------
	inline public static function getBits(x:Int, mask:Int):Int { return x & mask; }
	//---------------------------------------------------------------------------------------------------
	inline public static function hasBits(x:Int, mask:Int):Bool { return (x & mask) != 0; }
	//---------------------------------------------------------------------------------------------------
	inline public static function incBits(x:Int, mask:Int):Bool { return (x & mask) == mask; }
	//---------------------------------------------------------------------------------------------------
	inline public static function setBits(x:Int, mask:Int):Int { return x | mask; }
	//---------------------------------------------------------------------------------------------------
	inline public static function clrBits(x:Int, mask:Int):Int { return x & ~mask; }
	//---------------------------------------------------------------------------------------------------
	inline public static function invBits(x:Int, mask:Int):Int { return x ^ mask; }
	//---------------------------------------------------------------------------------------------------
	inline public static function setBitsIf(x:Int, mask:Int, expr:Bool):Int
	{
		return expr ? (x | mask) : (x & ~mask);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function hasBitAt(x:Int, i:Int):Bool
	{
		return (x & (1 << i)) != 0;
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function setBitAt(x:Int, i:Int):Int
	{
		return x | (1 << i);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function clrBitAt(x:Int, i:Int):Int
	{
		return x & ~(1 << i);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function invBitAt(x:Int, i:Int):Int
	{
		return x ^ (1 << i);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function setBitsRange(x:Int, min:Int, max:Int):Int
	{
		for (i in min...max) x = setBits(x, 1 << i);
		return x;
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function mask(n:Int):Int
	{
		return (1 << n) - 1;
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function ones(x:Int)
	{
		x -= ((x >> 1) & 0x55555555);
		x = (((x >> 2) & 0x33333333) + (x & 0x33333333));
		x = (((x >> 4) + x) & 0x0f0f0f0f);
		x += (x >> 8);
		x += (x >> 16);
		return(x & 0x0000003f);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function ntz(x:Int):Int
	{
		if (x == 0) return 0;
		else
		{
			if (Memory.getByte(956) != 31)
			{
				var x = 0x077CB531;
				for (i in 0...32)
				{
					Memory.setI32(cast(1020 - ((x >>> 27) << 2), UInt), i);
					x <<= 1;
				}
			}
			return Memory.getI32(cast(1020 - ((((x & -x) * 0x077CB531) >>> 27) << 2), UInt));
		}
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function nlz(x:Int):Int
	{
		if (x < 0) return 0;
		else
		{
			x |= (x >> 1);
			x |= (x >> 2);
			x |= (x >> 4);
			x |= (x >> 8);
			x |= (x >> 16);
			return(INT_BITS - ones(x));
		}
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function msb(x:Int):Int
	{
		x |= (x >> 1);
		x |= (x >> 2);
		x |= (x >> 4);
		x |= (x >> 8);
		x |= (x >> 16);
		return(x & ~(x >>> 1));
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function rol(x:Int, n:Int) { return (x << n) | (x >>> (INT_BITS - n)); }
	//---------------------------------------------------------------------------------------------------
	inline public static function ror(x:Int, n:Int) { return (x >>> n) | (x << (INT_BITS - n)); }
	//---------------------------------------------------------------------------------------------------
	inline public static function reverse(x:Int):Int
	{
		var y = 0x55555555;
        x = (((x >> 1) & y) | ((x & y) << 1));
        y = 0x33333333;
        x = (((x >> 2) & y) | ((x & y) << 2));
        y = 0x0f0f0f0f;
        x = (((x >> 4) & y) | ((x & y) << 4));
        y = 0x00ff00ff;
        x = (((x >> 8) & y) | ((x & y) << 8));
        return((x >> 16) | (x << 16));
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function flipWORD(x:Int):Int
	{
		return (x << 8 | x >> 8);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function flipDWORD(x:Int):Int
	{
		return (x << 24 | ((x << 8) & 0x00FF0000) | ((x >> 8) & 0x0000FF00) | x >> 24);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function packI16(lo:Int, hi:Int):Int
	{
		return ((hi + 0x8000) << 16) | (lo + 0x8000);
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function unpackI16Lo(x:Int):Int
	{
		return (x & 0xffff) - 0x8000;
	}
	//---------------------------------------------------------------------------------------------------
	inline public static function unpackI16Hi(x:Int):Int
	{
		return (x >>> 16) - 0x8000;
	}
}