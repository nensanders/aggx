package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
//=======================================================================================================
class GlyfTable 
{
	private var _tableRecord:TableRecord;
	private var _glyphRecords:Vector<GlyphRecord>;
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer, numGlyphs:UInt, locaTable:LocaTable) //<=== from MaxpTable
	{
		_tableRecord = record;
		
		_glyphRecords = new Vector(numGlyphs);
		
		var i:UInt = 0;
		var z:UInt = numGlyphs - 1;
		while (i < numGlyphs)
		{
			if (i < z && (locaTable.getOffset(i + 1) - locaTable.getOffset(i)) > 0)
			{
				_glyphRecords[i] = new GlyphRecord(data + locaTable.getOffset(i));
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
		return _glyphRecords[idx];
	}
}