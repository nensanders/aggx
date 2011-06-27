package lib.ha.rfpx;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.geometry.Coord;
import lib.ha.core.geometry.RectBox;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.utils.Bits;
import lib.ha.rfpx.data.GlyfTable;
import lib.ha.rfpx.data.GlyphRecord;
import lib.ha.rfpx.data.GlyphRecordComp;
import lib.ha.rfpx.data.HheaTable;
import lib.ha.rfpx.data.HmtxTable;
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
			_bounds.y2 = _record.yMin;
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
			_outline.length += numCont;
		}
		var i:UInt = 0;

		while (i < numCont)
		{
			var contourPoints = new Vector<GlyphPoint>();
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
	public inline var advanceWidth(get_advanceWidth, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_advanceHeight():Int { return _advanceHeight; }
	public inline var advanceHeight(get_advanceHeight, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_leftSideBearing():Int { return _leftSideBearing; }
	public inline var leftSideBearing(get_leftSideBearing, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_record():GlyphRecord { return _record; }
	public inline var record(get_record, null):GlyphRecord;
	//---------------------------------------------------------------------------------------------------
	private inline function get_bounds():RectBox { return _bounds; }
	public inline var bounds(get_bounds, null):RectBox;
	//---------------------------------------------------------------------------------------------------
	private inline function get_index():UInt { return _index; }
	public inline var index(get_index, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfContours():UInt { return _numberOfContours; }
	public inline var numberOfContours(get_numberOfContours, null):UInt;
}