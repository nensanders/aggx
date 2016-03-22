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
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class GlyphRecord 
{
	private var _numberOfContours:Int;				//SHORT
	private var _xMin:Int;							//SHORT
	private var _yMin:Int;							//SHORT
	private var _xMax:Int;							//SHORT
	private var _yMax:Int;							//SHORT
	private var _simpleDescr:GlyphDescrSimple;
	private var _compositeDescr:GlyphDescrComp;
	private var _isSimple:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_numberOfContours = data.dataGetShort();
		data.offset += 2;
		_xMin = data.dataGetShort();
		data.offset += 2;
		_yMin = data.dataGetShort();
		data.offset += 2;
		_xMax = data.dataGetShort();
		data.offset += 2;
		_yMax = data.dataGetShort();
		data.offset += 2;
		
		if (_numberOfContours > 0)
		{
			_simpleDescr = new GlyphDescrSimple(data, _numberOfContours);
			_isSimple = true;
		}
		else if(_numberOfContours < 0)
		{
			_compositeDescr = new GlyphDescrComp(data);
			_isSimple = false;
		}
		else
		{
			throw "Empty glyph";
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_isSimple():Bool { return _isSimple; }
	public var isSimple(get, null):Bool;
	//---------------------------------------------------------------------------------------------------
	private inline function get_simpleDescr():GlyphDescrSimple { return _simpleDescr; }
	public var simpleDescr(get, null):GlyphDescrSimple;
	//---------------------------------------------------------------------------------------------------
	private inline function get_compositeDescr():GlyphDescrComp { return _compositeDescr; }
	public var compositeDescr(get, null):GlyphDescrComp;
	//---------------------------------------------------------------------------------------------------
	private inline function get_xMin():Int { return _xMin; }
	public var xMin(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_yMin():Int { return _yMin; }
	public var yMin(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_xMax():Int { return _xMax; }
	public var xMax(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_yMax():Int { return _yMax; }
	public var yMax(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfContours():Int { return _numberOfContours; }
	public var numberOfContours(get, null):Int;
	
}