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
	public var current(get, null):ContourSegment;
}