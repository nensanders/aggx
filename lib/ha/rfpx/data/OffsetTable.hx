package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class OffsetTable 
{
	private var _sfntVersion:Int; 		//FIXED
	private var _numTables:UInt; 		//USHORT
	private var _searchRange:UInt;		//USHORT
	private var _entrySelector:UInt;	//USHORT
	private var _rangeShift:UInt; 		//USHORT
	//---------------------------------------------------------------------------------------------------
	public function new(dataPtr:PointerRef) 
	{
		var ptr = dataPtr.value;
		
		_sfntVersion = ptr.getInt();
		ptr += 4;
		_numTables = ptr.getUShort();
		ptr += 2;
		_searchRange = ptr.getUShort();
		ptr += 2;
		_entrySelector = ptr.getUShort();
		ptr += 2;
		_rangeShift = ptr.getUShort();
		ptr += 2;
		
		dataPtr.value = ptr;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_numTables():UInt { return _numTables; }
	public inline var numTables(get_numTables, null):UInt;
}