package lib.ha.core.memory;
//=======================================================================================================
import flash.Memory;
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
	public inline var accessor(get_accessor, set_accessor):MemoryAccessor;
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
		for (i in offset...offset + size) Memory.setByte(begin + i, 0);
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