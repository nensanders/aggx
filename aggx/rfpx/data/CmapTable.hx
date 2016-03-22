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
import haxe.ds.Vector;
import types.Data;
import aggx.core.memory.Pointer;
import aggx.core.memory.Ref;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapTable 
{
	private var _tableRecord:TableRecord;
	private var _version:UInt;							//USHORT
	private var _numTables:UInt;						//USHORT
	private var _formats0:Array<CmapFormat0>;			//Apple
	private var _formats2:Array<CmapFormat2>;
	private var _formats4:Array<CmapFormat4>;			//Microsoft
	private var _formats6:Array<CmapFormat6>;
	//---------------------------------------------------------------------------------------------------
	public function new(record: TableRecord, data: Data)
	{
		_tableRecord = record;
		
		_formats0 = new Array();
		_formats2 = new Array();
		_formats4 = new Array();
		_formats6 = new Array();
		
		var dataPtr = data.offset;
		
		_version = data.dataGetUShort();
		data.offset += 2;
		_numTables = data.dataGetUShort();
		data.offset += 2;

        var encRecords = new Vector(_numTables);
		for (i in 0 ... _numTables)
		{
			encRecords[i] = new EncodingRecord(data);
		}


		var i:UInt = 0;
		while (i < _numTables)
		{
			var encRecord = encRecords[i];
			//var encRecordPtr = _tableRecord.offset + encRecord.offset;
			var cmapFormatPtr = dataPtr + encRecord.offset;//dataPtr + encRecordPtr;
            data.offset = cmapFormatPtr;
			var cmapFormatType = data.dataGetUShort();//encRecordPtr.getUShort();
			data.offset += 2;
			switch (cmapFormatType)
			{
				case 0: _formats0.push(new CmapFormat0(data, encRecord));
				case 2: _formats2.push(new CmapFormat2(data));
				case 4: _formats4.push(new CmapFormat4(data));
				case 6: _formats6.push(new CmapFormat6(data));
			}
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getGlyphIndex(charCode:UInt):UInt
	{
		return _formats4[0].getGlyphIndex(charCode);
	}

}