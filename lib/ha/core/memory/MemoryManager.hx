package lib.ha.core.memory;
//=======================================================================================================
import flash.Memory;
import flash.system.ApplicationDomain;
import flash.Vector;
import haxe.io.BytesData;
import lib.ha.core.math.Calc;
//=======================================================================================================
private typedef MemoryBlockFriend =
{
	private var _start:UInt;
	private var _size:UInt;
	private var _ptr:Pointer;
	private var _prev:MemoryBlock;
	private var _next:MemoryBlock;
}
//=======================================================================================================
class MemoryManager
{
	private static var _lastBlock:MemoryBlockFriend;
	private static var blocks:Vector<MemoryBlock> = new Vector();
	//---------------------------------------------------------------------------------------------------
	public static function malloc(?size:Int):MemoryBlock
	{
		if (size == null || size < 1024)
		{
			size = 1024;
		}
		var block = new MemoryBlock();
		mallocImpl(size, block);
		_lastBlock = block;
		return block;
	}
	//---------------------------------------------------------------------------------------------------
	public static function mallocEx(bytes:BytesData):MemoryBlock
	{
		if (bytes.bytesAvailable < 1024)
		{
			bytes.length = 1024;
		}
		var block = new MemoryBlock();
		mallocExImpl(bytes, block);
		_lastBlock = block;
		return block;
	}	
	//---------------------------------------------------------------------------------------------------
	public static function realloc(block:MemoryBlockFriend, size:UInt):Void
	{
		size = roundToNext1024(size);
		if (size != block._size)
		{
			var offset = size-block._size;
			block._size = size;
			var prev:MemoryBlockFriend = _lastBlock;
			ApplicationDomain.currentDomain.domainMemory.length += offset;
			while (prev._start != block._start)
			{
				MemoryUtils.copy(prev._start + offset, prev._start, prev._size);
				prev = prev._prev;
			}
			block._ptr = block._size;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public static function expand(block:MemoryBlockFriend, size:UInt):Void
	{
		size = roundToNext1024(size);
		if (size > 0)
		{
			var offset = size;
			block._size += size;
			var prev:MemoryBlockFriend = _lastBlock;
			ApplicationDomain.currentDomain.domainMemory.length += offset;
			while (prev._start != block._start)
			{
				MemoryUtils.copy(prev._start + offset, prev._start, prev._size);
				prev = prev._prev;
			}
			block._ptr = block._size;
		}
		//trace("Expanding:\n\tsize: " + block._size + "\n\tstart: " + block._start);
	}	
	//---------------------------------------------------------------------------------------------------
	public static function free(block:MemoryBlockFriend):Void
	{
		var prev:MemoryBlockFriend = block._prev;
		var next:MemoryBlockFriend = block._next;
		prev._next = cast next;
		next._prev = cast prev;
		var offset = -block._size;
		while (next != null)
		{
			MemoryUtils.copy(next._ptr + offset, next._ptr, next._size);
			next = next._next;
		}
		ApplicationDomain.currentDomain.domainMemory.length += offset;
	}
	//---------------------------------------------------------------------------------------------------
	private static function mallocImpl(?size:Int, block:MemoryBlockFriend):Void
	{
		size = roundToNext1024(size);
		if (_lastBlock == null) 
		{
			var bytes = new BytesData();
			bytes.length = size;
			Memory.select(bytes);
			block._start = block._ptr = 0;
			block._size = size;
			_lastBlock = block;
		}
		else 
		{
			_lastBlock._next = cast block;
			block._prev = cast _lastBlock;
			block._start = block._ptr = _lastBlock._start + _lastBlock._size;
			block._size = size;
			_lastBlock = block;
			ApplicationDomain.currentDomain.domainMemory.length += size;
		}
		//trace("Allocation of size\n\tsize: " + block._size + "\n\tstart: " + block._start);
	}
	//---------------------------------------------------------------------------------------------------
	private static function mallocExImpl(bytes:BytesData, block:MemoryBlockFriend):Void
	{
		if (_lastBlock == null)
		{
			Memory.select(bytes);
			block._start = block._ptr = 0;
			block._size = bytes.length;
			_lastBlock = block;
		}
		else 
		{
			_lastBlock._next = cast block;
			block._prev = cast _lastBlock;
			block._start = block._ptr = _lastBlock._start + _lastBlock._size;
			block._size = bytes.length;
			_lastBlock = block;
			ApplicationDomain.currentDomain.domainMemory.length += bytes.length;
			bytes.readBytes(ApplicationDomain.currentDomain.domainMemory, block._start, block._size);			
		}
		//trace("Allocation from bytes\n\tsize: " + block._size + "\n\tstart: " + block._start);
	}	
	//---------------------------------------------------------------------------------------------------
	private static function roundToNext1024(size:UInt):UInt
	{
		size = Calc.umax(size, 1024);
		return size + ((size % 1024) > 0 ? 1024 : 0);
	}
}