package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class NameTable 
{
	private var _tableRecord:TableRecord;
	private var _format:UInt;								//USHORT
	private var _count:UInt;								//USHORT
	private var _stringOffset:UInt;							//USHORT
	private var _nameRecord:Vector<NameRecord>;				//NameRecord[count]
	private var _langTagCount:UInt;							//USHORT
	private var _langTagRecord:Vector<LangTagRecord>;		//LangTagRecord[langTagCount]
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer) 
	{
		_tableRecord = record;
		
		var dataPtr = data;		
		
		_format = data.getUShort();
		data += 2;
		_count = data.getUShort();
		data += 2;
		_stringOffset = data.getUShort();
		data += 2;
		
		var strDataPtr = dataPtr + _stringOffset;
		_nameRecord = new Vector(_count);
		
		var refPtr = Ref.pointer1.set(data);
		
		var i:UInt = 0, nameRecord:NameRecord;
		while (i < _count) 
		{
			_nameRecord[i] = nameRecord = new NameRecord(refPtr);
			nameRecord.readString(strDataPtr);
			++i;
		}
		
		data = refPtr.value;
		
		if (_format == 1)
		{
			_langTagCount = data.getUShort();
			i = 0;
			while (i < _langTagCount) 
			{
				var len = data.getUShort();
				data += 2;
				var ofs = data.getUShort();
				data += 2;
				_langTagRecord[i] = new LangTagRecord(len, ofs);
				++i;
			}
		}
	}
}