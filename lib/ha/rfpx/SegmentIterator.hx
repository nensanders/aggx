package lib.ha.rfpx;
//=======================================================================================================
import flash.Vector;
//=======================================================================================================
private typedef GlyphContourFriend =
{
	private var _segments:Vector<ContourSegment>;
	private var _numberOfSegments:UInt;
}
//=======================================================================================================
class SegmentIterator
{
	private var _contour:GlyphContourFriend;
	private var _segmentIndex:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new(contour:GlyphContour) 
	{
		_contour = cast contour;
		_segmentIndex = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function initialize():Void
	{
		_segmentIndex = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function next():Bool
	{
		++_segmentIndex;
		return _segmentIndex < _contour._numberOfSegments;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_current():ContourSegment { return _contour._segments[_segmentIndex]; }
	public inline var current(get_current, null):ContourSegment;
}