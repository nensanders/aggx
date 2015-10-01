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

package lib.ha.rfpx.data;
//=======================================================================================================
import haxe.ds.Vector;
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
		
		var refPtr = Ref.getPointer().set(data);
		
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
            _langTagRecord = new Vector(_langTagCount);
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