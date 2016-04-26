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

package aggx.rfpx;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.core.geometry.Coord;
import aggx.core.geometry.RectBox;
import aggx.core.geometry.AffineTransformer;
import aggx.core.utils.Bits;
import aggx.rfpx.data.GlyfTable;
import aggx.rfpx.data.GlyphRecord;
import aggx.rfpx.data.GlyphRecordComp;
import aggx.rfpx.data.HheaTable;
import aggx.rfpx.data.HmtxTable;
//=======================================================================================================
class Glyph 
{
	private var _leftSideBearing:Int;
	private var _advanceWidth:Int;
	private var _advanceHeight:Int;
	private var _outline:Vector<GlyphContour>;
	private var _numberOfContours:UInt;
	private var _record:GlyphRecord;
	private var _bounds:RectBox;
	private var _index:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new(glyphTable:GlyfTable, glyphIndex:UInt, hmtx:HmtxTable, hhea:HheaTable)
	{
		_leftSideBearing = hmtx.getLSB(glyphIndex);
		_advanceWidth = hmtx.getLHM(glyphIndex).advanceWidth;
		_advanceHeight = hhea.ascender - hhea.descender + hhea.lineGap;
		_record = glyphTable.getGlyphRecord(glyphIndex);
		_index = glyphIndex;
		_numberOfContours = 0;
		if (_record != null) 
		{
			_bounds = new RectBox();
			_bounds.x1 = _record.xMin;
			_bounds.y1 = _record.yMin;
			_bounds.x2 = _record.xMax;
			_bounds.y2 = _record.yMax;
			processGlyph(glyphTable);
		}
	}
	//---------------------------------------------------------------------------------------------------
	private function processGlyph(glyphTable:GlyfTable):Void
	{
		if (_record.isSimple) 
		{
			processSimpleGlyph(_record);
		}
		else 
		{
			processCompositeGlyph(glyphTable);
		}
	}
	//---------------------------------------------------------------------------------------------------
	private function processSimpleGlyph(glyphRecord:GlyphRecord, transformer:AffineTransformer = null):Void
	{
		var ON_CURVE = 0;

		var descr = glyphRecord.simpleDescr;
		var numCont = descr.numberOfContours;
		if (_outline == null) 
		{
			_outline = new Vector(numCont);
		}
		else 
		{
            // Todo Possibly slow growing of a vector. Maybe refactor with array
            var newLength: Int = _outline.length + numCont;
            var tempOutline = new Vector(newLength);
            for (i in 0..._outline.length) tempOutline[i] = _outline[i];
			_outline = tempOutline;
		}
		var i:UInt = 0;

		while (i < numCont)
		{
			var contourPoints = new Array<GlyphPoint>();
			descr.getContourPoints(i, contourPoints, transformer);
			_outline[_numberOfContours] = new GlyphContour(contourPoints);
			++_numberOfContours;
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	private function processCompositeGlyph(glyphTable:GlyfTable):Void
	{
		var descr = _record.compositeDescr;
		var i:UInt = 0, count = descr.componentsCount;
		while (i < count)
		{
			var component = descr.getComponent(i);
			var glyphRecord = glyphTable.getGlyphRecord(component.glyphIndex);
			processSimpleGlyph(glyphRecord, component.transformer);
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getContourSegments(idx:UInt):SegmentIterator 
	{
		return _outline[idx].segmentIterator;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_advanceWidth():Int { return _advanceWidth; }
	public var advanceWidth(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_advanceHeight():Int { return _advanceHeight; }
	public var advanceHeight(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_leftSideBearing():Int { return _leftSideBearing; }
	public var leftSideBearing(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_record():GlyphRecord { return _record; }
	public var record(get, null):GlyphRecord;
	//---------------------------------------------------------------------------------------------------
	private inline function get_bounds():RectBox { return _bounds; }
	public var bounds(get, null):RectBox;
	//---------------------------------------------------------------------------------------------------
	private inline function get_index():UInt { return _index; }
	public var index(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfContours():UInt { return _numberOfContours; }
	public var numberOfContours(get, null):UInt;
}