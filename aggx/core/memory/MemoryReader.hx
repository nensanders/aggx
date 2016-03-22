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

package aggx.core.memory;
//=======================================================================================================
import aggx.core.memory.MemoryAccess;
//=======================================================================================================
class MemoryReader 
{	
	public static inline function getChar(addr:Pointer):Int
	{
		var x0 = MemoryAccess.getUInt8(addr);
		var y0 = (x0 << 24) >> 24;
		return y0;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getByte(addr:Pointer):Int
	{
		return MemoryAccess.getUInt8(addr);
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function getShort(addr:Pointer):Int
	{
		var x0 = MemoryAccess.signExtend16(MemoryAccess.getUInt16(addr));
		var x1:Int = (x0 << 16) >> 16;
		return x1;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getUShort(addr:Pointer):UInt
	{
		return MemoryAccess.getUInt16(addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getInt(addr:Pointer):Int
	{
		return MemoryAccess.getInt32(addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getUInt(addr:Pointer):UInt	
	{
		return MemoryAccess.getInt32(addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getFloat(addr:Pointer ):Float
	{
		return MemoryAccess.getFloat32(addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getDouble(addr:Pointer):Float
	{
		return MemoryAccess.getFloat64(addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getString(addr:Pointer, len:Int):String
	{
        return MemoryAccess.getUTF8String(addr, len);
	}	
}