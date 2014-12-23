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

package lib.ha.core.memory;
//=======================================================================================================
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.system.ApplicationDomain;
//=======================================================================================================
class MemoryBlock
{
	private var _start:UInt;
	private var _size:UInt;
	private var _ptr:Pointer;
	private var _prev:MemoryBlock;
	private var _next:MemoryBlock;
	//---------------------------------------------------------------------------------------------------
	public function new()
	{
		_start = 0;
		_size = 0;
		_ptr = 0;
		_prev = null;
		_next = null;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_ptr():Pointer { return _ptr; }
	private inline function set_ptr(value:Pointer):Pointer { return _ptr = value; }
	public var ptr(get, set):Pointer;
	//---------------------------------------------------------------------------------------------------
	private inline function get_start():UInt { return _start; }
	public var start(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_size():UInt { return _size; }
	public var size(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public static function clone(block:MemoryBlock):MemoryBlock
	{
		var b = new MemoryBlock();
		b._start = b._ptr = block._start;
		b._size = block._size;
		return b;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function blit(block:MemoryBlock, bitmap:BitmapData, rect:Rectangle):Void
	{
		var pos = ApplicationDomain.currentDomain.domainMemory.position;
		ApplicationDomain.currentDomain.domainMemory.position = block._start;
		bitmap.lock();
		bitmap.setPixels(rect, ApplicationDomain.currentDomain.domainMemory);
		bitmap.unlock();
		ApplicationDomain.currentDomain.domainMemory.position = pos;
	}
}