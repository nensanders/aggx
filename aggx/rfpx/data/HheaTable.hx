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
	public function new(record:TableRecord, data: Data)
	{
		_tableRecord = record;
		
		_version = data.dataGetInt();
		data.offset += 4;
		_ascender = data.dataGetShort();
		data.offset += 2;
		_descender = data.dataGetShort();
		data.offset += 2;
		_lineGap = data.dataGetShort();
		data.offset += 2;
		_advanceWidthMax = data.dataGetUShort();
		data.offset += 2;
		_minLeftSideBearing = data.dataGetShort();
		data.offset += 2;
		_minRightSideBearing = data.dataGetShort();
		data.offset += 2;
		_xMaxExtent = data.dataGetShort();
		data.offset += 2;
		_caretSlopeRise = data.dataGetShort();
		data.offset += 2;
		_caretSlopeRun = data.dataGetShort();
		data.offset += 2;
		_caretOffset = data.dataGetShort();
		data.offset += 2;
		data.offset += 8;
		_metricDataFormat = data.dataGetShort();
		data.offset += 2;
		_numberOfHMetrics = data.dataGetUShort();
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