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

package lib.ha.rfpx;
//=======================================================================================================

import haxe.ds.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.rfpx.data.GlyfTable;
import lib.ha.rfpx.data.GlyphRecord;
import lib.ha.rfpx.data.HeadTable;
import lib.ha.rfpx.data.HheaTable;
import lib.ha.rfpx.data.HmtxTable;
import lib.ha.rfpx.data.LocaTable;
import lib.ha.rfpx.data.MaxpTable;
import lib.ha.rfpx.data.OffsetTable;
import lib.ha.rfpx.data.Os2Table;
import lib.ha.rfpx.data.PostTable;
import lib.ha.rfpx.data.TableRecord;
import lib.ha.rfpx.data.TableTags;
import lib.ha.rfpx.data.CmapTable;
import lib.ha.rfpx.data.NameTable;
//=======================================================================================================
class TrueTypeFont
{
	private var _fc:TrueTypeCollection;
	private var _data:Pointer;
	private var _tableRecords:Vector<TableRecord>;
	private var _head:HeadTable;
	private var _hhea:HheaTable;
	private var _maxp:MaxpTable;
	private var _loca:LocaTable;
	private var _os2:Os2Table;
	private var _cmap:CmapTable;
	private var _glyf:GlyfTable;
	private var _hmtx:HmtxTable;
	private var _name:NameTable;
	private var _post:PostTable;
	//---------------------------------------------------------------------------------------------------
	public function new(fc:TrueTypeCollection)
	{
		_fc = fc;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_ascender():Int { return _hhea.ascender; }
	public var ascender(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_descender():Int { return _hhea.descender; }
	public var descender(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineGap():Int { return _hhea.lineGap; }
	public var lineGap(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_unitsPerEm():UInt { return _head.unitsPerEm; }
	public var unitsPerEm(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public function getGlyph(idx:Int):Glyph
	{
		return new Glyph(_glyf, idx, _hmtx, _hhea);
	}
	//---------------------------------------------------------------------------------------------------
	public function getGlyphByCharCode(code:Int):Glyph
	{
		var idx = _cmap.getGlyphIndex(code);
		return new Glyph(_glyf, idx, _hmtx, _hhea);
	}
	//---------------------------------------------------------------------------------------------------
	private function getTableRecord(tag:UInt):TableRecord
	{
		var i:UInt = 0, numTables = _tableRecords.length;
		while (i < cast numTables)
		{
			if (_tableRecords[i].tag == tag) 
			{
				return _tableRecords[i];
			}
			++i;
		}
		return null;
	}
	//---------------------------------------------------------------------------------------------------
	private function parseTables():Void
	{
		var tr:TableRecord;
		_cmap = new CmapTable(tr = getTableRecord(TableTags.cmap), _data + tr.offset);
		_head = new HeadTable(tr = getTableRecord(TableTags.head), _data + tr.offset);
		_maxp = new MaxpTable(tr = getTableRecord(TableTags.maxp), _data + tr.offset);
		_hhea = new HheaTable(tr = getTableRecord(TableTags.hhea), _data + tr.offset);
		_hmtx = new HmtxTable(tr = getTableRecord(TableTags.hmtx), _data + tr.offset, _maxp.numGlyphs, _hhea.numberOfHMetrics);
		_name = new NameTable(tr = getTableRecord(TableTags.name), _data + tr.offset);
		_os2 = new Os2Table(tr = getTableRecord(TableTags.OS_2), _data + tr.offset);
		_post = new PostTable(tr = getTableRecord(TableTags.post), _data + tr.offset);
		_loca = new LocaTable(tr = getTableRecord(TableTags.loca), _data + tr.offset, _maxp.numGlyphs, _head.indexToLocFormat);
		_glyf = new GlyfTable(tr = getTableRecord(TableTags.glyf), _data + tr.offset, _maxp.numGlyphs, _loca);
	}
	//---------------------------------------------------------------------------------------------------
	public function read(data:Pointer):Void
	{
		_data = data;
		var refPtr = Ref.getPointer().set(_data);
		var ot = new OffsetTable(refPtr);
		var numTables = ot.numTables;
		_tableRecords = new Vector(numTables);
		var i:UInt = 0;
		while (i < numTables)
		{
			_tableRecords[i] = new TableRecord(refPtr);
			++i;
		}
		parseTables();
	}
}