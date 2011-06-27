package lib.ha.aggx;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryUtils;
import lib.ha.core.memory.MemoryWriter;
import lib.ha.core.math.Calc;
using lib.ha.core.memory.MemoryWriter;
//=======================================================================================================
class RenderingBuffer
{
	private var _buf:MemoryBlock;
	private var _start:Pointer;
	private var _width:UInt;
	private var _height:UInt;
	private var _stride:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(buf:MemoryBlock, width:UInt, height:UInt, stride:Int) 
	{
		attach(buf, width, height, stride);
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(buf:MemoryBlock, width:UInt, height:UInt, stride:Int):Void
	{		
		_buf = buf;
		_start = _buf.ptr;
		_width = width;
		_height = height;
		_stride = stride;
		if(_stride < 0)
		{
			_start = (height - 1) * _stride;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getRowPtr(y:Int):Pointer
	{
		return _start + y * _stride;
	}
	//---------------------------------------------------------------------------------------------------
	public function getRow(y:Int):RowInfo
	{
		return new RowInfo(0, _width - 1, getRowPtr(y));
	}
	//---------------------------------------------------------------------------------------------------
	public function copyFrom(src:RenderingBuffer):Void
	{	
		var h = Calc.umin(src.height, _height);
		var l = Calc.umin(strideAbs, src.strideAbs);

		var y:UInt = 0;
		var w = _width;
		while (y < h)
		{
			MemoryUtils.copy(getRowPtr(y), src.getRowPtr(y), l);
			y++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function clear(value:Byte):Void
	{
		var y:UInt = 0;
		var stride = strideAbs;
		while (y < _height)
		{
			var p = getRowPtr(y);
			var x:UInt = 0;
			while (x < stride)
			{
				p.setByte(value);
				p++;
				x++;
			}
			y++;
		}
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_start():UInt { return _start; }
	public inline var start(get_start, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():UInt { return _width; }
	public inline var width(get_width, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_height():UInt { return _height; }
	public inline var height(get_height, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_stride():Int { return _stride; }
	public inline var stride(get_stride, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_strideAbs():UInt { return Calc.abs(_stride); }
	public inline var strideAbs(get_strideAbs, null):UInt;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_buf():MemoryBlock { return MemoryBlock.clone(_buf); }
	public inline var buf(get_buf, null):MemoryBlock;
}