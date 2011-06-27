package lib.ha.aggx.rasterizer;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.MemoryManager;
import lib.ha.core.memory.MemoryUtils;
import lib.ha.core.memory.Pointer;
//=======================================================================================================
class ScanlinePixelCellStorage 
{
	private static inline var BLOCK_SIZE = 1024;
	//---------------------------------------------------------------------------------------------------
	private var _cells:MemoryBlock;
	private var _allocatedSize:UInt;
	private var _cellsCount:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_cells = MemoryManager.malloc(BLOCK_SIZE);
		_allocatedSize = BLOCK_SIZE;
		_cellsCount = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function removeAll():Void
	{
		_cells.ptr = _cells.start;
	}
	//---------------------------------------------------------------------------------------------------
	public function addCells(cells:Pointer, numCells:UInt):Int
	{
		if (cast (_cellsCount + numCells) > _allocatedSize)
		{
			MemoryManager.expand(_cells, BLOCK_SIZE);
		}
		MemoryUtils.copy(_cells.start + _cellsCount, cells, numCells);
		var ret = _cellsCount;
		_cellsCount += numCells;
		return ret;
	}
	//---------------------------------------------------------------------------------------------------
	public function get(idx:Int):Pointer
	{
		if(Math.abs(idx) >= _cellsCount) return 0;
		return _cells.start + idx;
	}
}