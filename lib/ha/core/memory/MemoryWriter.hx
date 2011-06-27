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