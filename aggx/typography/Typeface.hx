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

package aggx.typography;
//=======================================================================================================
import aggx.vectorial.VectorPath;
import aggx.core.geometry.Coord;
import aggx.rfpx.ContourSegment;
import aggx.rfpx.Glyph;
//=======================================================================================================
class Typeface
{
	private var _charCode:UInt;
	private var _glyph:Glyph;
	private var _path:VectorPath;
	private var _flipY:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new(glyph:Glyph, code:UInt)
	{
		_charCode = code;
		_glyph = glyph;
		_flipY = true;
		_path = new VectorPath();
		constructOutline();
	}
	//---------------------------------------------------------------------------------------------------
	private function constructOutline():Void
	{
		var x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float;

		_path.removeAll();
		var numberOfContours:UInt = _glyph.numberOfContours;

		var p:Coord;

		var n:UInt = 0;
		while (n < numberOfContours)
		{
			var contourSegments = _glyph.getContourSegments(n);

			if (contourSegments == null)
			{
				++n;
				continue;
			}

			p = contourSegments.current.getPoint(0);

			x1 = p.x;
			y1 = p.y;

			if (_flipY) { y1 = -y1;}

			_path.moveTo(x1, y1);

			while (contourSegments.next())
			{
				var segment = contourSegments.current;
				if (segment.type == ContourSegment.LINE)
				{
					p = segment.getPoint(0);

					x1 = p.x;
					y1 = p.y;

					if (_flipY) { y1 = -y1; }

					_path.lineTo(x1, y1);
				}
				else if (segment.type == ContourSegment.CURVE)
				{
					var b = segment.getPoint(0);
					var c = segment.getPoint(1);

					x1 = b.x;
					y1 = b.y;
					x2 = c.x;
					y2 = c.y;

					if (_flipY) { y1 = -y1; y2 = -y2; }

					_path.curve3(x1, y1, x2, y2);
				}
			}
			++n;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getOutline(path:VectorPath):Void
	{
		path.concatPath(_path);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_charCode():UInt { return _charCode; }
	public var charCode(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_glyph():Glyph { return _glyph; }
	public var glyph(get, null):Glyph;
}