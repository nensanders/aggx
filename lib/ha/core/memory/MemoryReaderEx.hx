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
import flash.system.ApplicationDomain;
//=======================================================================================================
class MemoryReaderEx
{
	public static inline function getChar(addr:Int):Int
	{
		var __x0 = untyped __vmem_get__(0, addr);
		var __y0 = (__x0 << 24) >> 24;
		return __y0;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getByte(addr:Int):Int
	{
		return untyped __vmem_get__(0, addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getInt(addr:Int):Int
	{
		var __x0 = untyped __vmem_get__(2, addr);
		var __y0 = (((__x0 >> 0) & 0xff) << 24) | (((__x0 >> 8) & 0xff) << 16) | (((__x0 >> 16) & 0xff) << 8) | (((__x0 >> 24) & 0xff) << 0);
		return __y0;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getUInt(addr: Int):UInt
	{
		var __x0:UInt = untyped __vmem_get__(2, addr);
		var __y0 = (((__x0 >> 0) & 0xff) << 24) | (((__x0 >> 8) & 0xff) << 16) | (((__x0 >> 16) & 0xff) << 8) | (((__x0 >> 24) & 0xff) << 0);
		return __y0;
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function getShort(addr:Int):Int
	{
		var __x0 = untyped __vmem_get__(1, addr);		
		var __y0:Int = (((__x0 >> 0) & 0xff) << 8) | (((__x0 >> 8) & 0xff) << 0);
		var __y1:Int = (__y0 << 16) >> 16;
		return __y1;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getUShort(addr:Int):UInt
	{
		var __x0 = untyped __vmem_get__(1, addr);
		var __y0 = (((__x0 >> 0) & 0xff) << 8) | (((__x0 >> 8) & 0xff) << 0);
		return __y0;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getFloat(addr:Int ):Float
	{
		return untyped __vmem_get__(3, addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getDouble(addr:Int):Float
	{
		return untyped __vmem_get__(4, addr);
	}
}