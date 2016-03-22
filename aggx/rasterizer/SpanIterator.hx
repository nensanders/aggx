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

package aggx.rasterizer;
//=======================================================================================================
import haxe.ds.Vector;
//=======================================================================================================
class SpanIterator implements ISpanIterator
{
	private var _spans:Vector<Span>;
	private var _index:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new(spans:Vector<Span>) 
	{
		_spans = spans;
		_index = 1;
	}
	//---------------------------------------------------------------------------------------------------
	public function initialize():Void 
	{
		_index = 1;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_current():Span { return _spans[_index]; }
	public var current(get_current, null):Span;
	//---------------------------------------------------------------------------------------------------
	public inline function next():Void { ++_index; }
}