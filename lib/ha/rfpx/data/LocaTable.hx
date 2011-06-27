package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class LocaTable 
{
	private var _tableRecord:TableRecord;
	private var _offsets:Vector<UInt>;
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer, numGlyphs:UInt, offsetsType:UInt) 
	{
		_offsets = new Vector(numGlyphs);
		var i:UInt = 0;
		if (offsetsType == 0) 
		{
			while (i < numGlyphs)
			{
				_offsets[i] = data.getUShort() * 2;
				data += 2;
				++i;
			}
		}
		else 
		{
			while (i < numGlyphs)
			{
				_offsets[i] = data.getUInt();
				data += 4;
				++i;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getOffset(idx:UInt):UInt
	{
		return _offsets[idx];
	}
}