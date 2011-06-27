package lib.ha.core.memory;
//=======================================================================================================
import flash.system.ApplicationDomain;
//=======================================================================================================
class MemoryReader 
{	
	public static inline function getChar(addr:Pointer):Int
	{
		var __x0 = untyped __vmem_get__(0, addr);
		var __y0 = (__x0 << 24) >> 24;
		return __y0;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getByte(addr:Pointer):Int
	{
		return untyped __vmem_get__(0, addr);
	}	
	//---------------------------------------------------------------------------------------------------
	public static inline function getShort(addr:Pointer):Int
	{
		var __x0 = untyped __vmem_sign__(2, untyped __vmem_get__(1, addr));
		var __x1:Int = (__x0 << 16) >> 16;
		return __x1;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getUShort(addr:Pointer):UInt
	{
		return untyped __vmem_get__(1, addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getInt(addr:Pointer):Int
	{
		return untyped __vmem_get__(2, addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getUInt(addr:Pointer):UInt	
	{
		return untyped __vmem_get__(2, addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getFloat(addr:Pointer ):Float
	{
		return untyped __vmem_get__(3, addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getDouble(addr:Pointer):Float
	{
		return untyped __vmem_get__(4, addr);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getString(addr:Pointer, len:Int):String
	{
		ApplicationDomain.currentDomain.domainMemory.position = addr;
		var s = ApplicationDomain.currentDomain.domainMemory.readUTFBytes(len);
		ApplicationDomain.currentDomain.domainMemory.position = addr;
		return s;
	}	
}