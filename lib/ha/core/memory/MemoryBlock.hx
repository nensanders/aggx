package lib.ha.core.memory;
//=======================================================================================================
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.system.ApplicationDomain;
import lib.ha.core.math.Calc;
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
	public inline var ptr(get_ptr, set_ptr):Pointer;
	//---------------------------------------------------------------------------------------------------
	private inline function get_start():UInt { return _start; }
	public inline var start(get_start, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_size():UInt { return _size; }
	public inline var size(get_size, null):UInt;
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