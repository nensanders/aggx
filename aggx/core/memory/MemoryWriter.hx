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
class MemoryWriter
{
	public static inline function setByte(addr:Pointer, v:Int):Void
	{
        MemoryAccess.setUInt8(addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setShort(addr:Pointer, v:Int):Void
	{
        MemoryAccess.setInt16(addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setInt(addr:Pointer, v:Int):Void
	{
        MemoryAccess.setInt32(addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setUInt(addr:Pointer, v:UInt):Void
	{
        MemoryAccess.setInt32(addr, v);
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function setFloat(addr:Pointer, v:Float ):Void
	{
        MemoryAccess.setFloat32(addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setDouble(addr:Pointer, v:Float):Void
	{
        MemoryAccess.setFloat64(addr, v);
	}

}