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
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
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
	public function new(record:TableRecord, data: Data)
	{
		_tableRecord = record;
		
		_version = data.dataGetInt();
		data.offset += 4;
		_fontRevision = data.dataGetInt();
		data.offset += 4;
		_checkSumAdjustment = data.dataGetUInt();
		data.offset += 4;
		_magicNumber = data.dataGetUInt();
		data.offset += 4;
		_flags = data.dataGetUShort();
		data.offset += 2;
		_unitsPerEm = data.dataGetUShort();
		data.offset += 2;
		_created = data.readFloat64();
		data.offset += 8;
		_modified = data.readFloat64();
		data.offset += 8;
		_xMin = data.dataGetShort();
		data.offset += 2;
		_yMin = data.dataGetShort();
		data.offset += 2;
		_xMax = data.dataGetShort();
		data.offset += 2;
		_yMax = data.dataGetShort();
		data.offset += 2;
		_macStyle = data.dataGetUShort();
		data.offset += 2;
		_lowestRecPPEM = data.dataGetUShort();
		data.offset += 2;
		_fontDirectionHint = data.dataGetShort();
		data.offset += 2;
		_indexToLocFormat = data.dataGetShort();
		data.offset += 2;
		_glyphDataFormat = data.dataGetShort();
	}
	//---------------------------------------------------------------------------------------------------
	public var indexToLocFormat(get, null):Int;
	private inline function get_indexToLocFormat():Int { return _indexToLocFormat; }
	//---------------------------------------------------------------------------------------------------
	public var unitsPerEm(get, null):UInt;
	private inline function get_unitsPerEm():UInt { return _unitsPerEm; }
}