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

package aggx.core.utils;
//=======================================================================================================
import aggx.core.memory.MemoryAccess;
//=======================================================================================================
class Bits
{
	inline public static var BIT_01 = 0x1;
	inline public static var BIT_02 = 0x2;
	inline public static var BIT_03 = 0x4;
	inline public static var BIT_04 = 0x8;
	inline public static var BIT_05 = 0x10;
	inline public static var BIT_06 = 0x20;
	inline public static var BIT_07 = 0x40;
	inline public static var BIT_08 = 0x80;
	inline public static var BIT_09 = 0x100;
	inline public static var BIT_10 = 0x200;
	inline public static var BIT_11 = 0x400;
	inline public static var BIT_12 = 0x800;
	inline public static var BIT_13 = 0x1000;
	inline public static var BIT_14 = 0x2000;
	inline public static var BIT_15 = 0x4000;
	inline public static var BIT_16 = 0x8000;
	inline public static var BIT_17 = 0x10000;
	inline public static var BIT_18 = 0x20000;
	inline public static var BIT_19 = 0x40000;
	inline public static var BIT_20 = 0x80000;
	inline public static var BIT_21 = 0x100000;
	inline public static var BIT_22 = 0x200000;
	inline public static var BIT_23 = 0x400000;
	inline public static var BIT_24 = 0x800000;
	inline public static var BIT_25 = 0x1000000;
	inline public static var BIT_26 = 0x2000000;
	inline public static var BIT_27 = 0x4000000;
	inline public static var BIT_28 = 0x8000000;
	inline public static var BIT_29 = 0x10000000;
	inline public static var BIT_30 = 0x20000000;
	inline public static var BIT_31 = 0x40000000;
	inline public static var BIT_32 = 0x80000000;
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
			if (MemoryAccess.getUInt8(956) != 31)
			{
				var x = 0x077CB531;
				for (i in 0...32)
				{
                    MemoryAccess.setInt32(cast(1020 - ((x >>> 27) << 2), UInt), i);
					x <<= 1;
				}
			}
			return MemoryAccess.getInt32(cast(1020 - ((((x & -x) * 0x077CB531) >>> 27) << 2), UInt));
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