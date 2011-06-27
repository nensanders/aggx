package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapTable 
{
	private var _tableRecord:TableRecord;
	private var _version:UInt;							//USHORT
	private var _numTables:UInt;						//USHORT
	private var _formats0:Vector<CmapFormat0>;			//Apple
	private var _formats2:Vector<CmapFormat2>;
	private var _formats4:Vector<CmapFormat4>;			//Microsoft
	private var _formats6:Vector<CmapFormat6>;
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer)
	{
		_tableRecord = record;
		
		_formats0 = new Vector();
		_formats2 = new Vector();
		_formats4 = new Vector();
		_formats6 = new Vector();
		
		var dataPtr = data;
		
		_version = data.getUShort();
		data += 2;
		_numTables = data.getUShort();
		data += 2;

		var refPtr = Ref.pointer1.set(data);
		
		var i:UInt = 0;
		while (i < _numTables)
		{
			var encRecord = new EncodingRecord(refPtr);
			//var encRecordPtr = _tableRecord.offset + encRecord.offset;
			var cmapFormatPtr = dataPtr + encRecord.offset;//dataPtr + encRecordPtr;
			var cmapFormatType = cmapFormatPtr.getUShort();//encRecordPtr.getUShort();
			cmapFormatPtr += 2;
			switch (cmapFormatType)
			{
				case 0:
					_formats0[_formats0.length] = new CmapFormat0(cmapFormatPtr, encRecord);
				case 2:
					_formats2[_formats2.length] = new CmapFormat2(cmapFormatPtr);
				case 4:
					_formats4[_formats4.length] = new CmapFormat4(cmapFormatPtr);
				case 6:
					_formats6[_formats6.length] = new CmapFormat6(cmapFormatPtr);
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