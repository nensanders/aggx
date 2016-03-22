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
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class LocaTable 
{
	private var _tableRecord:TableRecord;
	private var _offsets:Vector<UInt>;
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data: Data, numGlyphs:UInt, offsetsType:UInt)
	{
		_offsets = new Vector(numGlyphs);
		var i:UInt = 0;
		if (offsetsType == 0) 
		{
			while (i < numGlyphs)
			{
				_offsets[i] = data.dataGetUShort() * 2;
				data.offset += 2;
				++i;
			}
		}
		else 
		{
			while (i < numGlyphs)
			{
				_offsets[i] = data.dataGetUInt();
				data.offset += 4;
				++i;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getOffset(idx:UInt):UInt
	{
		return _offsets[idx];
	}
}