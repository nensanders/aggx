package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class HheaTable 
{
	private var _tableRecord:TableRecord;
	private var _version:Int;					//FIXED
	private var _ascender:Int;					//FWORD -> SHORT (in FUNITs)
	private var _descender:Int;					//FWORD -> SHORT (in FUNITs)
	private var _lineGap:Int;					//FWORD -> SHORT (in FUNITs)
	private var _advanceWidthMax:UInt;			//UFWORD -> USHORT (in FUNITs)
	private var _minLeftSideBearing:Int;		//FWORD -> SHORT (in FUNITs)
	private var _minRightSideBearing:Int;		//FWORD -> SHORT (in FUNITs)
	private var _xMaxExtent:Int;				//FWORD -> SHORT (in FUNITs)
	private var _caretSlopeRise:Int;			//SHORT
	private var _caretSlopeRun:Int;				//SHORT
	private var _caretOffset:Int;				//SHORT
	private var _reserved0:Int;					//SHORT
	private var _reserved1:Int;					//SHORT
	private var _reserved2:Int;					//SHORT
	private var _reserved3:Int;					//SHORT
	private var _metricDataFormat:Int;			//SHORT
	private var _numberOfHMetrics:UInt;			//USHORT
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer) 
	{
		_tableRecord = record;
		
		_version = data.getInt();
		data += 4;
		_ascender = data.getShort();
		data += 2;
		_descender = data.getShort();
		data += 2;
		_lineGap = data.getShort();
		data += 2;
		_advanceWidthMax = data.getUShort();
		data += 2;
		_minLeftSideBearing = data.getShort();
		data += 2;
		_minRightSideBearing = data.getShort();
		data += 2;
		_xMaxExtent = data.getShort();
		data += 2;
		_caretSlopeRise = data.getShort();
		data += 2;
		_caretSlopeRun = data.getShort();
		data += 2;
		_caretOffset = data.getShort();
		data += 2;
		data += 8;
		_metricDataFormat = data.getShort();
		data += 2;
		_numberOfHMetrics = data.getUShort();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfHMetrics():UInt { return _numberOfHMetrics; }
	public var numberOfHMetrics(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_ascender():Int { return _ascender; }
	public var ascender(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_descender():Int { return _descender; }
	public var descender(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineGap():Int { return _lineGap; }
	public var lineGap(get, null):Int;
	
}