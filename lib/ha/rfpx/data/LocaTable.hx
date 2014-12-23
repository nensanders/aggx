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

package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class LocaTable 
{
	private var _tableRecord:TableRecord;
	private var _offsets:Vector<UInt>;
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer, numGlyphs:UInt, offsetsType:UInt) 
	{
		_offsets = new Vector(numGlyphs);
		var i:UInt = 0;
		if (offsetsType == 0) 
		{
			while (i < numGlyphs)
			{
				_offsets[i] = data.getUShort() * 2;
				data += 2;
				++i;
			}
		}
		else 
		{
			while (i < numGlyphs)
			{
				_offsets[i] = data.getUInt();
				data += 4;
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