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

import types.Data;
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReaderEx;

using aggx.core.memory.MemoryReaderEx;

class VheaTable
{
    public var _tableRecord(default, null): TableRecord;
	public var _version(default, null): Int;					//FIXED32
    public var _vertTypoAscender(default, null): Int;         //SHORT
    public var _vertTypoDescender(default, null): Int;         //SHORT
    public var _vertTypoLineGap(default, null): Int;         //SHORT
    public var _advanceHeightMax(default, null): Int;         //SHORT
    public var _minTopSideBearing(default, null): Int;         //SHORT
    public var _minBottomSideBearing(default, null): Int;         //SHORT
    public var _yMaxExtent(default, null): Int;         //SHORT
    public var _caretSlopeRise(default, null): Int;         //SHORT
    public var _caretSlopeRun(default, null): Int;         //SHORT
    public var _caretOffset(default, null): Int;         //SHORT
    public var _reserved0(default, null): Int;         //SHORT
    public var _reserved1(default, null): Int;         //SHORT
    public var _reserved2(default, null): Int;         //SHORT
    public var _reserved3(default, null): Int;         //SHORT
    public var _metricDataFormat(default, null): Int;         //SHORT
    public var _numOfLongVerMetrics(default, null): Int;         //USHORT

	public function new(record:TableRecord, data: Data)
	{
		_tableRecord = record;
		
		_version = data.dataGetInt();
		data.offset += 4;

        _vertTypoAscender = data.dataGetShort();
        data.offset += 2;

        _vertTypoDescender = data.dataGetShort();
        data.offset += 2;

        _vertTypoLineGap = data.dataGetShort();
        data.offset += 2;

        _advanceHeightMax = data.dataGetShort();
        data.offset += 2;

        _minTopSideBearing = data.dataGetShort();
        data.offset += 2;

        _minBottomSideBearing = data.dataGetShort();
        data.offset += 2;

        _yMaxExtent = data.dataGetShort();
        data.offset += 2;

        _caretSlopeRise = data.dataGetShort();
        data.offset += 2;

        _caretSlopeRun = data.dataGetShort();
        data.offset += 2;

        _caretOffset = data.dataGetShort();
        data.offset += 2;

        _reserved0 = data.dataGetShort();
        data.offset += 2;

        _reserved1 = data.dataGetShort();
        data.offset += 2;

        _reserved2 = data.dataGetShort();
        data.offset += 2;

        _reserved3 = data.dataGetShort();
        data.offset += 2;

        _metricDataFormat = data.dataGetShort();
        data.offset += 2;

        _numOfLongVerMetrics = data.dataGetUShort();
        data.offset += 2;
	}
	
}