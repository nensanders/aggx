package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class TTCHeader 
{
	private static var TTCTag = 0x74746366;
	//---------------------------------------------------------------------------------------------------
	private var _version:Int;						//FIXED
	private var _numFonts:UInt;						//ULONG
	private var _offsetTable:Vector<UInt>;			//ULONG[numFonts]
	private var _dsigTag:UInt;						//ULONG
	private var _dsigLength:UInt;					//ULONG
	private var _dsigOffset:UInt;					//ULONG
	//---------------------------------------------------------------------------------------------------
	public function new(data:MemoryBlock)
	{
		_version = data.ptr.getInt();
	}
	//---------------------------------------------------------------------------------------------------
	public static function isTTC(data:MemoryBlock):Bool
	{
		var check = data.ptr.getInt();
		return check == TTCTag;
	}
}