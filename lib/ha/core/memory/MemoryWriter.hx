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

package lib.ha.core.memory;
//=======================================================================================================
class MemoryWriter
{
	public static inline function setByte(addr:Pointer, v:Int):Void
	{
		untyped __vmem_set__(0, addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setShort(addr:Pointer, v:Int):Void
	{
		untyped __vmem_set__(1, addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setInt(addr:Pointer, v:Int):Void
	{
		untyped __vmem_set__(2, addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setUInt(addr:Pointer, v:UInt):Void
	{
		untyped __vmem_set__(2, addr, v);
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function setFloat(addr:Pointer, v:Float ):Void
	{
		untyped __vmem_set__(3, addr, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setDouble(addr:Pointer, v:Float):Void
	{
		untyped __vmem_set__(4, addr, v);
	}

}