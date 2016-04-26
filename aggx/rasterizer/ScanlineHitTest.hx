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
import aggx.core.memory.Byte;
import aggx.core.memory.Pointer;
//=======================================================================================================
class ScanlineHitTest implements IScanline
{
	private var _x:Int;
	private var _isHit:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new(x:Int) 
	{
		_x = x;
		_isHit = false;
	}
	//---------------------------------------------------------------------------------------------------
	public function reset(minX:Int, maxX:Int):Void { }	
	//---------------------------------------------------------------------------------------------------
	public function resetSpans():Void {}
	//---------------------------------------------------------------------------------------------------
	public function finalize(y:Int):Void { }
	//---------------------------------------------------------------------------------------------------
	public function addCell(x:Int, y:Int):Void
	{
		if (_x == x) _isHit = true;
	}
	//---------------------------------------------------------------------------------------------------
	public function addCells(x:Int, len:UInt, covers:Pointer):Void { }	
	//---------------------------------------------------------------------------------------------------
	public function addSpan(x:Int, len:UInt, cover:Byte):Void
	{
		if (_x >= x && _x < x + cast len) _isHit = true;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_spanCount():UInt { return 1; }
	public var spanCount(get_spanCount, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_isHit():Bool { return _isHit; }
	public var isHit(get_isHit, null):Bool;
	//---------------------------------------------------------------------------------------------------
	private inline function get_y():Int { return 0; }
	public var y(get_y, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_spanIterator():ISpanIterator { return null; }
	public var spanIterator(get_spanIterator, null):ISpanIterator;
}