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
//=======================================================================================================
import types.Data;
class MemoryReaderEx
{
	public static inline function getChar(addr:Int):Int
	{
		var x0 = MemoryAccess.getUInt8(addr);
		var y0 = (x0 << 24) >> 24; // TODO Is this like sign-extensions?
		return y0;
	}

	public static inline function getByte(addr:Int):Int
	{
		return MemoryAccess.getUInt8(addr);
	}

	public static inline function getInt(addr:Int):Int
	{
		var x0 = MemoryAccess.getInt32(addr);
		var y0 = (((x0 >> 0) & 0xff) << 24) | (((x0 >> 8) & 0xff) << 16) | (((x0 >> 16) & 0xff) << 8) | (((x0 >> 24) & 0xff) << 0);
		return y0;
	}

	public static inline function dataGetInt(data: Data):Int
	{
		var x0 = data.readInt32();
		var y0 = (((x0 >> 0) & 0xff) << 24) | (((x0 >> 8) & 0xff) << 16) | (((x0 >> 16) & 0xff) << 8) | (((x0 >> 24) & 0xff) << 0);
		return y0;
	}


	public static inline function getUInt(addr: Int):UInt
	{
		var x0:UInt = MemoryAccess.getInt32(addr);
		var y0 = (((x0 >> 0) & 0xff) << 24) | (((x0 >> 8) & 0xff) << 16) | (((x0 >> 16) & 0xff) << 8) | (((x0 >> 24) & 0xff) << 0);
		return y0;
	}

    public static inline function dataGetUInt(data: Data):UInt
    {
        var x0:UInt = data.readInt32();
        var y0 = (((x0 >> 0) & 0xff) << 24) | (((x0 >> 8) & 0xff) << 16) | (((x0 >> 16) & 0xff) << 8) | (((x0 >> 24) & 0xff) << 0);
        return y0;
    }

	public static inline function getShort(addr:Int):Int
	{
		var x0 = MemoryAccess.getUInt16(addr);
		var y0:Int = (((x0 >> 0) & 0xff) << 8) | (((x0 >> 8) & 0xff) << 0);
		var y1:Int = (y0 << 16) >> 16;
		return y1;
	}

    public static inline function dataGetShort(data: Data):Int
    {
        var x0 = data.readUInt16();
        var y0:Int = (((x0 >> 0) & 0xff) << 8) | (((x0 >> 8) & 0xff) << 0);
        var y1:Int = (y0 << 16) >> 16;
        return y1;
    }

	public static inline function getUShort(addr:Int):UInt
	{
		var x0 = MemoryAccess.getUInt16(addr);
		var y0 = (((x0 >> 0) & 0xff) << 8) | (((x0 >> 8) & 0xff) << 0);
		return y0;
	}

	public static inline function dataGetUShort(data: Data):UInt
	{
		var x0 = data.readUInt16();
		var y0 = (((x0 >> 0) & 0xff) << 8) | (((x0 >> 8) & 0xff) << 0);
		return y0;
	}

	public static inline function getFloat(addr:Int ):Float
	{
		return MemoryAccess.getFloat32(addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getDouble(addr:Int):Float
	{
		return MemoryAccess.getFloat64(addr);
	}
}