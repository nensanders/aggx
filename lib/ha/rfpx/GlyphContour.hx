package lib.ha.rfpx;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.geometry.Coord;
import lib.ha.core.utils.Bits;
//=======================================================================================================
class GlyphContour
{
	private var _segments:Vector<ContourSegment>;
	private var _numberOfSegments:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new(points:Vector<GlyphPoint>) 
	{
		_segments = new Vector();
		_numberOfSegments = 0;
		construct(points);
	}
	//---------------------------------------------------------------------------------------------------
	private function construct(points:Vector<GlyphPoint>):Void
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
	public inline var numberOfSegments(get_numberOfSegments, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_segmentIterator():SegmentIterator { return new SegmentIterator(this); }
	public inline var segmentIterator(get_segmentIterator, null):SegmentIterator;
}