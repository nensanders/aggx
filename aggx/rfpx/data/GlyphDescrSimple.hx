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

package aggx.rfpx.data;
//=======================================================================================================
import types.Data;
import haxe.ds.Vector;
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Pointer;
import aggx.core.memory.Ref;
import aggx.core.utils.Bits;
import aggx.core.memory.MemoryReaderEx;
import aggx.rfpx.GlyphPoint;
using aggx.core.memory.MemoryReaderEx;
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
	public function new(data: Data, numberOfContours:UInt)
	{
		_endPtsOfContours = new Vector(numberOfContours);
		
		var i:UInt = 0;
		while (i < numberOfContours)
		{
			_endPtsOfContours[i] = data.dataGetUShort();
			data.offset += 2;
			++i;
		}
		
		_instructionLength = data.dataGetUShort();
		data.offset += 2;
		
		_instructions = new Vector(_instructionLength);
		i = 0;
		while (i < _instructionLength)
		{
			_instructions[i] = data.readInt8();
			data.offset++;
			++i;
		}
		_numberOfPoints = _endPtsOfContours[_endPtsOfContours.length - 1] + 1;
		
		var count:UInt = 0, c:UInt = 0;
		_tags = new Vector(_numberOfPoints);
        for (i in 0..._numberOfPoints) _tags[i] = 0; // TODO check js
		
		i = 0;
		while (i < _numberOfPoints) 
		{
			c = data.readUInt8();
			_tags[i++] = c;
			data.offset++;
			if ((c & 8) != 0) 
			{
				count = data.readUInt8();
				data.offset++;
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
				y = data.readUInt8();
				data.offset++;
				if ((f & 16) == 0) y = -y;
			}
			else if ((f & 16) == 0)
			{
				y = data.dataGetShort();
				data.offset += 2;
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
				y = data.readUInt8();
				data.offset++;
				if ((f & 32) == 0) y = -y;
				
			}
			else if ((f & 32) == 0)
			{
				y = data.dataGetShort();
				data.offset += 2;
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
		var _from:UInt = 0, _to:UInt = _endPtsOfContours[contourIndex];
		if (contourIndex > 0)
		{
			_from = _endPtsOfContours[contourIndex - 1] + 1;
		}
        var rx = Ref.getFloat();
        var ry = Ref.getFloat();
		while (_from <= _to)
		{
			var x = _xCoordinates[_from];
			var y = _yCoordinates[_from];
			
			if (transform != null)
			{
				rx.set(x);
				ry.set(y);
				transform.transform(rx, ry);
				x = Std.int(rx.value);
				y = Std.int(ry.value);
			}
            pts.push(new GlyphPoint(x, y, _tags[_from]));
			++_from;
		}
        Ref.putFloat(rx);
        Ref.putFloat(ry);
	}
}