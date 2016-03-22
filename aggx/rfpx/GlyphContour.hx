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
import aggx.core.geometry.Coord;
import aggx.core.utils.Bits;
//=======================================================================================================
class GlyphContour
{
	private var _segments:Array<ContourSegment>;
	private var _numberOfSegments:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new(points:Array<GlyphPoint>)
	{
		_segments = new Array();
		_numberOfSegments = 0;
		construct(points);
	}
	//---------------------------------------------------------------------------------------------------
	private function construct(points:Array<GlyphPoint>):Void
	{
		var ON_CURVE = 0;
		var numPoints:UInt = points.length;
		var createNewSegment = false;
		var currentPoint:GlyphPoint = null;
		
		var segment = ContourSegment.createFirst();//assuming that the first Coord is ON_CURVE
		segment.addPoint(points[0].x, points[0].y);//so we add it as MOVE_TO
		
		_segments[_numberOfSegments] = segment;
		++_numberOfSegments;
		_segments[_numberOfSegments] = segment = segment.createNext();
		++_numberOfSegments;
		
		var m:UInt = 1;
		if (numPoints > 2) 
		{
			while (m <= numPoints)
			{
				if (m == numPoints)
				{
					if (Bits.hasBitAt(currentPoint.tag, ON_CURVE)) 
					{
						segment = segment.createNext();
						segment.addPoint(points[0].x, points[0].y);
						_segments[_numberOfSegments] = segment;
						++_numberOfSegments;
					}
					else 
					{
						segment.addPoint(points[0].x, points[0].y);
					}
					break;
				}
				currentPoint = points[m++];
				if (createNewSegment)
				{
					_segments[_numberOfSegments] = segment = segment.createNext();
					++_numberOfSegments;
					createNewSegment = false;
				}
				if (Bits.hasBitAt(currentPoint.tag, ON_CURVE))
				{
					segment.addPoint(currentPoint.x, currentPoint.y);
					createNewSegment = true;
					continue;
				}
				else 
				{
					if (segment.numberOfPoints > 0) 
					{
						var a = new Coord(0, 0);
						var b = segment.getPoint(0);
						var c = currentPoint;
						a.x = b.x - (b.x - c.x) / 2;
						a.y = b.y - (b.y - c.y) / 2;
						segment.addPoint(a.x, a.y);
						_segments[_numberOfSegments] = segment = segment.createNext();
						++_numberOfSegments;
					}
					segment.addPoint(currentPoint.x, currentPoint.y);
				}
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfSegments():UInt { return _numberOfSegments; }
	public var numberOfSegments(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_segmentIterator():SegmentIterator { return new SegmentIterator(this); }
	public var segmentIterator(get, null):SegmentIterator;
}