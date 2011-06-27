package lib.ha.core.memory;
//=======================================================================================================
import flash.system.ApplicationDomain;
import lib.ha.core.memory.MemoryWriter;
using lib.ha.core.memory.MemoryWriter;
//=======================================================================================================
class MemoryUtils 
{
	public static function copy(dst:Pointer, src:Pointer, size:UInt):Void
	{
		var pos = ApplicationDomain.currentDomain.domainMemory.position;
		ApplicationDomain.currentDomain.domainMemory.position = src;
		ApplicationDomain.currentDomain.domainMemory.readBytes(ApplicationDomain.currentDomain.domainMemory, dst, size);
		ApplicationDomain.currentDomain.domainMemory.position = pos;
	}
	//---------------------------------------------------------------------------------------------------
	public static function set(dst:Pointer, val:Byte, size:UInt):Void
	{
		var i:UInt = 0;
		while (i < size)		
		{
			dst.setByte(val);
			dst++;
			++i;
		}
	}
}