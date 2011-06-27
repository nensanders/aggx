package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class EncodingRecord 
{
	private var _platformID:UInt;		//USHORT	3 = Microsoft, 1 = Apple, 0 = Unicode
	private var _encodingID:UInt;		//USHORT
	private var _offset:UInt;			//ULONG
	//---------------------------------------------------------------------------------------------------
	public function new(dataPtr:PointerRef) 
	{
		var ptr = dataPtr.value;
		
		_platformID = ptr.getUShort();
		ptr += 2;
		_encodingID = ptr.getUShort();
		ptr += 2;
		_offset = ptr.getUInt();
		ptr += 4;
		
		dataPtr.value = ptr;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_offset():UInt { return _offset; }
	public inline var offset(get_offset, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_platformID():UInt { return _platformID; }
	public inline var platformID(get_platformID, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_encodingID():UInt { return _encodingID; }
	public inline var encodingID(get_encodingID, null):UInt;
}