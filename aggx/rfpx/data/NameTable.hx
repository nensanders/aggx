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

package aggx.rfpx.data;
//=======================================================================================================
import types.Data;
import haxe.ds.Vector;
import aggx.core.memory.Pointer;
import aggx.core.memory.Ref;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
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

    public var fontName: String = "";

	public function new(record:TableRecord, data: Data)
	{
		_tableRecord = record;
		
		var dataPtr = data.offset;
		
		_format = data.dataGetUShort();
		data.offset += 2;
		_count = data.dataGetUShort();
		data.offset += 2;
		_stringOffset = data.dataGetUShort();
		data.offset += 2;
		
		var strDataPtr = dataPtr + _stringOffset;
		_nameRecord = new Vector(_count);
		
		var i:UInt = 0, nameRecord:NameRecord;
		while (i < _count) 
		{
			_nameRecord[i] = nameRecord = new NameRecord(data);
			++i;
		}
		
		if (_format == 1)
		{
			_langTagCount = data.dataGetUShort();
            _langTagRecord = new Vector(_langTagCount);
			i = 0;
			while (i < _langTagCount)
			{
				var len = data.dataGetUShort();
				data.offset += 2;
				var ofs = data.dataGetUShort();
				data.offset += 2;
				_langTagRecord[i] = new LangTagRecord(len, ofs);
				++i;
			}
		}

		var offset = data.offset;
		for (i in 0 ... _count)
		{
            var nameRecord: NameRecord = _nameRecord[i];
			data.offset = strDataPtr;
			nameRecord.readString(data);

            if (nameRecord.isFontName())
            {
                fontName = nameRecord._record;
            }
		}
		data.offset = offset;
	}
}