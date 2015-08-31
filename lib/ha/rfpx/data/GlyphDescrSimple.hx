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

package lib.ha.rfpx.data;
//=======================================================================================================
import haxe.ds.Vector;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.utils.Bits;
import lib.ha.core.memory.MemoryReaderEx;
import lib.ha.rfpx.GlyphPoint;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class GlyphDescrSimple 
{
	private var _endPtsOfContours:Vector<UInt>;		//USHORT[numberOfContours]
	private var _instructionLength:UInt;			//USHORT
	private var _instructions:Vector<Int>;			//BYTE[instructionLength]
	//private var _flags:Vector<Int>;					//BYTE[]
	private var _xCoordinates:Vector<Int>;			//BYTE/SHORT
	private var _yCoordinates:Vector<Int>;			//BYTE/SHORT
	private var _onCurve:Vector<Bool>;          // TODO Unused?
	private var _tags:Vector<UInt>;
	private var _numberOfPoints:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer, numberOfContours:UInt) 
	{
		_endPtsOfContours = new Vector(numberOfContours);
		
		var i:UInt = 0;
		while (i < numberOfContours)
		{
			_endPtsOfContours[i] = data.getUShort();
			data += 2;
			++i;
		}
		
		_instructionLength = data.getUShort();
		data += 2;
		
		_instructions = new Vector(_instructionLength);
		i = 0;
		while (i < _instructionLength)
		{
			_instructions[i] = data.getByte();
			data++;
			++i;
		}
		_numberOfPoints = _endPtsOfContours[_endPtsOfContours.length - 1] + 1;
		
		var count:UInt = 0, c:UInt = 0;
		_tags = new Vector(_numberOfPoints);
		
		i = 0;
		while (i < _numberOfPoints) 
		{
			c = data.getByte();
			_tags[i++] = c;
			data++;
			if ((c & 8) != 0) 
			{
				count = data.getByte();
				data++;
				while (count > 0) 
				{
					_tags[i++] = c;
					--count;
				}
			}
		}
		
		_xCoordinates = new Vector(_numberOfPoints);
		_yCoordinates = new Vector(_numberOfPoints);		
		
		var x:Int = 0;
		i = 0;
		while (i < _numberOfPoints)
		{
			var f = _tags[i];
			var y:Int = 0;
			if ((f & 2) != 0)
			{
				y = data.getByte();
				data++;
				if ((f & 16) == 0) y = -y;
			}
			else if ((f & 16) == 0)
			{
				y = data.getShort();
				data += 2;
			}
			x += y;
			_xCoordinates[i] = x;
			++i;
		}
		
		i = x = 0;
		while (i < _numberOfPoints)
		{
			var f = _tags[i];
			var y:Int = 0;
			if ((f & 4) != 0)
			{
				y = data.getByte();
				data++;
				if ((f & 32) == 0) y = -y;
				
			}
			else if ((f & 32) == 0)
			{
				y = data.getShort();
				data += 2;
			}
			x += y;
			_yCoordinates[i] = x;
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfPoints():UInt { return _numberOfPoints; }
	public var numberOfPoints(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfContours():UInt { return _endPtsOfContours.length; }
	public var numberOfContours(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public function getContourPoints(contourIndex:UInt, pts:Array<GlyphPoint>, transform:AffineTransformer):Void
	{
		var from:UInt = 0, to:UInt = _endPtsOfContours[contourIndex];
		if (contourIndex > 0)
		{
			from = _endPtsOfContours[contourIndex - 1] + 1;
		}
		while (from <= to)
		{
			var x = _xCoordinates[from];
			var y = _yCoordinates[from];
			
			if (transform != null)
			{
				var rx = Ref.float1.set(x);
				var ry = Ref.float2.set(y);
				transform.transform(rx, ry);
				x = Std.int(rx.value);
				y = Std.int(ry.value);
			}
            pts.push(new GlyphPoint(x, y, _tags[from]));
			++from;
		}
	}
}