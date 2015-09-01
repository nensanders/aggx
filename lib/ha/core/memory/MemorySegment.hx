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
//=======================================================================================================
class MemorySegment
{
	public var next:MemorySegment;
	public var prev:MemorySegment;
	public var begin:Int;
	public var end:Int;
	public var isEmpty:Bool;
	public var size:Int;
	public var manager:MemoryManager;
	public var offset:Int;
	//---------------------------------------------------------------------------------------------------
	private var _accessor:MemoryAccessor;
	//---------------------------------------------------------------------------------------------------
	public function new(man:MemoryManager, off:Int)
	{
		manager = man;
		offset = off;
		begin = end = size = 0;
		isEmpty = true;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_accessor():MemoryAccessor { return _accessor; }
	private inline function set_accessor(value:MemoryAccessor):MemoryAccessor { return _accessor = value; }
	public var accessor(get, set):MemoryAccessor;
	//---------------------------------------------------------------------------------------------------
	public function free():Void
	{	
		prev = null;
		next = null;
		manager = null;
		_accessor = null;
		begin = -1;
		end = -1;
		size = -1;
		offset = -1;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function shiftLeft(x:Int):Void
	{
		begin -= x;
		end -= x;
		setOffset();
	}
	//---------------------------------------------------------------------------------------------------
	public inline function shiftRight(x:Int):Void
	{
		begin += x;
		end += x;
		setOffset();
	}
	//---------------------------------------------------------------------------------------------------
	public inline function expandLeft(s:Int):Void
	{
		size += s;
		begin = end - size + 1;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function shrinkLeft(s:Int):Void
	{
		size -= s;
		end = begin + size - 1;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function expandRight(s:Int):Void
	{
		size += s;
		end = begin + size - 1;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function shrinkRight(s:Int):Void
	{
		size -= s;
		begin = end - size + 1;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function setOffset():Void
	{
		if (accessor != null) setByteOffset(accessor, offset + begin);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function wipe():Void
	{
		for (i in offset...offset + size) MemoryAccess.setInt8(begin + i, 0);
	}
	//---------------------------------------------------------------------------------------------------
	public function copy():MemorySegment
	{
		var copy:MemorySegment = new MemorySegment(manager, offset);
		copy.begin = begin;
		copy.end = end;
		copy.isEmpty = isEmpty;
		copy.size = size;
		return copy;
	}
	//---------------------------------------------------------------------------------------------------
	inline private function setByteOffset(accessor: { private var _offset:Int; }, x:Int):Void
	{
		accessor._offset = x;
	}
}