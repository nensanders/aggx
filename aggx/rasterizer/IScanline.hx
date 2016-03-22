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
interface IScanline
{
	public var spanCount(get, null):UInt;
	public var y(get, null):Int;
	public var spanIterator(get, null):ISpanIterator;
	//---------------------------------------------------------------------------------------------------
	public function reset(minX:Int, maxX:Int):Void;
	public function resetSpans():Void;
	public function finalize(y:Int):Void;
	public function addCell(x:Int, cover:Byte):Void;
	//public function addCells(x:Int, len:UInt, covers:Pointer):Void;
	public function addSpan(x:Int, len:UInt, cover:Byte):Void;
}