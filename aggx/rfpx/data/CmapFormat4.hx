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
import aggx.core.memory.MemoryReaderEx;
import aggx.core.memory.MemoryAccess;

using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapFormat4
{
	private var _format:UInt;					//UShort
	private var _length:UInt;					//UShort
	private var _language:UInt;					//UShort
	private var _segCountX2:UInt;				//UShort
	private var _searchRange:UInt;				//UShort
	private var _entrySelector:UInt;			//UShort
	private var _rangeShift:UInt;				//UShort
	private var _endCount:Vector<UInt>;			//UShort[segCountX2/2]
	private var _reservedPad:UInt;				//UShort
	private var _startCount:Vector<UInt>;		//UShort[segCountX2/2]
	private var _idDelta:Vector<Int>;			//UShort[segCountX2/2]
	private var _idRangeOffset:Vector<UInt>;	//UShort[segCountX2/2]
	private var _glyphIndexArray:Pointer;//UShort[]

	private var _idRangeOffsetPtr:Pointer;

	/// preserve original binary data, because this format may require additional raw lookups
	private var _mapData: Data;
	private var originalLength: Int;
	private var originalOffset: Int;
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_format = 4;

		originalOffset = data.offset;

		_length = data.dataGetUShort();
		data.offset += 2;
		_language = data.dataGetUShort();
		data.offset += 2;
		_segCountX2 = data.dataGetUShort();
		data.offset += 2;
		_searchRange = data.dataGetUShort();
		data.offset += 2;
		_entrySelector = data.dataGetUShort();
		data.offset += 2;
		_rangeShift = data.dataGetUShort();
		data.offset += 2;

		var segCount:UInt = _segCountX2 >> 1;
		_endCount = new Vector(segCount);
		var i:UInt = 0;
		while (i < segCount)
		{
			_endCount[i] = data.dataGetUShort();
			data.offset += 2;
			++i;
		}

		_reservedPad = 0;
		data.offset += 2;

		_startCount = new Vector(segCount);
		i = 0;
		while (i < segCount)
		{
			_startCount[i] = data.dataGetUShort();
			data.offset += 2;
			++i;
		}

		_idDelta = new Vector(segCount);
		i = 0;
		while (i < segCount)
		{
			_idDelta[i] = data.dataGetShort();
			data.offset += 2;
			++i;
		}

		_idRangeOffset = new Vector(segCount);
		_idRangeOffsetPtr = data.offset - originalOffset;
		i = 0;
		while (i < segCount)
		{
			_idRangeOffset[i] = data.dataGetShort();
			data.offset += 2;
			++i;
		}

		_glyphIndexArray = data.dataGetUShort();

		/// save the original binary data for getGlyphIndex lookup fails
		_mapData = new Data(_length);

		data.offset = originalOffset;

		var prevOffsetLength = data.offsetLength;
		data.offsetLength = _length;
		_mapData.writeData(data);
		data.offsetLength = prevOffsetLength;


	}
	//---------------------------------------------------------------------------------------------------
	public function getGlyphIndex(charCode:UInt):UInt
	{
		var glyphIndex = 0;
		var segment = findFormat4Segment(charCode);
		if (segment < 0)
		{
			return 0;
		}
		if (_idRangeOffset[segment] == 0)
		{
			glyphIndex = (_idDelta[segment] + charCode) % 65536;
		}
		else
		{
			var v0 = _idRangeOffset[segment];
			var v1 = (charCode-_startCount[segment]) << 1;
			var v2 = _idRangeOffsetPtr + (segment << 1);

			/// lookup into raw data
			var previousMemory = MemoryAccess.domainMemory;
			MemoryAccess.select(_mapData);

			var result:UInt  = (v0 + v1 + v2).getUShort();

			MemoryAccess.select(previousMemory);

			if (result != 0)
			{
				glyphIndex = (_idDelta[segment] + result) % 65536;
			}
			else
			{
				glyphIndex = 0;
			}
		}
		return glyphIndex;
	}
	//---------------------------------------------------------------------------------------------------
	private function findFormat4Segment(charCode:UInt):Int
	{
		var segment = -1;
		var segCount:UInt = _segCountX2 >> 1;
		var i:UInt = 0;
		while (i < segCount && _endCount[i] < charCode)
		{
			++i;
		}
		if (i >= segCount) segment = -1;
		if (_startCount[i] > charCode) segment = -1;
		segment = i;
		return segment;
	}
	//---------------------------------------------------------------------------------------------------
	private function find(c:UInt):UInt
	{
		var min:UInt, max:UInt, mid:UInt;

		min = 0;
		max = (_segCountX2 >> 1) - 1;
		mid = max >> 1;

		while (min < max)
		{
			var val = _endCount[mid];
			if (val == c)
			break;
			else if (val < c) min = mid + 1;
			else if (val > c) max = mid;
			mid = (min + max) >> 1;
		}

		return mid;
	}
}