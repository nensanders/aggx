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
import aggx.core.memory.Ref;
//=======================================================================================================
class GlyfTable 
{
	private var _tableRecord:TableRecord;
	private var _glyphRecords:Vector<GlyphRecord>;
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data: Data, numGlyphs:UInt, locaTable:LocaTable) //<=== from MaxpTable
	{
		var offset = data.offset;
		_tableRecord = record;
		
		_glyphRecords = new Vector(numGlyphs);
		
		var i:UInt = 0;
		var z:UInt = numGlyphs - 1;
		while (i < numGlyphs)
		{
			if (i < z && (locaTable.getOffset(i + 1) - locaTable.getOffset(i)) > 0)
			{
				data.offset = offset + locaTable.getOffset(i);
				_glyphRecords[i] = new GlyphRecord(data);
			}
			else 
			{
				_glyphRecords[i] = null;
			}
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getGlyphRecord(idx:UInt):GlyphRecord
	{
		return idx < _glyphRecords.length ? _glyphRecords[idx] : null;
	}
}