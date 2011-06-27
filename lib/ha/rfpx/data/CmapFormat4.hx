package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
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
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer) 
	{
		_format = 4;
		
		//var dataPtr = data;
		
		_length = data.getUShort();
		data += 2;
		_language = data.getUShort();
		data += 2;
		_segCountX2 = data.getUShort();
		data += 2;
		_searchRange = data.getUShort();
		data += 2;
		_entrySelector = data.getUShort();
		data += 2;
		_rangeShift = data.getUShort();
		data += 2;
		
		var segCount:UInt = _segCountX2 >> 1;
		_endCount = new Vector(segCount);
		var i:UInt = 0;
		while (i < segCount)
		{
			_endCount[i] = data.getUShort();
			data += 2;
			++i;
		}
		
		_reservedPad = 0;		
		data += 2;
		
		_startCount = new Vector(segCount);
		i = 0;
		while (i < segCount)
		{
			_startCount[i] = data.getUShort();
			data += 2;
			++i;
		}
		
		_idDelta = new Vector(segCount);
		i = 0;
		while (i < segCount)
		{
			_idDelta[i] = data.getShort();
			data += 2;
			++i;
		}
		
		_idRangeOffset = new Vector(segCount);
		_idRangeOffsetPtr = data;
		i = 0;
		while (i < segCount)
		{
			_idRangeOffset[i] = data.getUShort();
			data += 2;
			++i;
		}
		
		_glyphIndexArray = data;
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
			var result:UInt  = (v0 + v1 + v2).getUShort();
			
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