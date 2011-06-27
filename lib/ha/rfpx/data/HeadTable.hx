package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class HeadTable 
{
	private var _tableRecord:TableRecord;
	private var _version:Int;					//FIXED
	private var _fontRevision:Int;				//FIXED
	private var _checkSumAdjustment:UInt;		//ULONG
	private var _magicNumber:UInt;				//ULONG
	private var _flags:UInt;					//USHORT
	private var _unitsPerEm:UInt;				//USHORT
	private var _created:Float;					//LONGDATETIME
	private var _modified:Float;				//LONGDATETIME
	private var _xMin:Int;						//SHORT
	private var _yMin:Int;						//SHORT
	private var _xMax:Int;						//SHORT
	private var _yMax:Int;						//SHORT
	private var _macStyle:UInt;					//USHORT
	private var _lowestRecPPEM:UInt;			//USHORT
	private var _fontDirectionHint:Int;			//SHORT
	private var _indexToLocFormat:Int;			//SHORT
	private var _glyphDataFormat:Int;			//SHORT
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer) 
	{
		_tableRecord = record;
		
		_version = data.getInt();
		data += 4;
		_fontRevision = data.getInt();
		data += 4;
		_checkSumAdjustment = data.getUInt();
		data += 4;
		_magicNumber = data.getUInt();
		data += 4;
		_flags = data.getUShort();
		data += 2;
		_unitsPerEm = data.getUShort();
		data += 2;
		_created = data.getDouble();
		data += 8;
		_modified = data.getDouble();
		data += 8;
		_xMin = data.getShort();
		data += 2;
		_yMin = data.getShort();
		data += 2;
		_xMax = data.getShort();
		data += 2;
		_yMax = data.getShort();
		data += 2;
		_macStyle = data.getUShort();
		data += 2;
		_lowestRecPPEM = data.getUShort();
		data += 2;
		_fontDirectionHint = data.getShort();
		data += 2;
		_indexToLocFormat = data.getShort();
		data += 2;
		_glyphDataFormat = data.getShort();
	}
	//---------------------------------------------------------------------------------------------------
	public inline var indexToLocFormat(get_indexToLocFormat, null):Int;
	private inline function get_indexToLocFormat():Int { return _indexToLocFormat; }
	//---------------------------------------------------------------------------------------------------
	public inline var unitsPerEm(get_unitsPerEm, null):UInt;
	private inline function get_unitsPerEm():UInt { return _unitsPerEm; }
}