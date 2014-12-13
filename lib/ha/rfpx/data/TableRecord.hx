package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class TableRecord 
{
	private var _tag:UInt; 			//ULONG
	private var _checkSum:UInt; 	//ULONG
	private var _offset:UInt; 		//ULONG
	private var _length:UInt; 		//ULONG
	//---------------------------------------------------------------------------------------------------
	public function new(dataPtr:PointerRef) 
	{
		var ptr = dataPtr.value;
		
		_tag = ptr.getUInt();
		ptr += 4;
		_checkSum = ptr.getUInt();
		ptr += 4;
		_offset = ptr.getUInt();
		ptr += 4;
		_length = ptr.getUInt();
		ptr += 4;
		
		dataPtr.value = ptr;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_tag():UInt { return _tag; }
	public var tag(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_offset():UInt { return _offset; }
	public var offset(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_length():UInt { return _length; }
	public var length(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
}