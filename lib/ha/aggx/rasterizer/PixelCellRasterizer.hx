package lib.ha.aggx.rasterizer;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.MemoryManager;
import lib.ha.core.memory.Pointer;
import lib.ha.aggx.rasterizer.PixelCell;
using lib.ha.aggx.rasterizer.PixelCell;
//=======================================================================================================
class SortedY
{
	public var start:Int;
	public var num:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new() { }	
}
//=======================================================================================================
class PixelCellRasterizer
{
	private static inline var POLY_SUBPIXEL_SHIFT = 8;
	private static inline var POLY_SUBPIXEL_SCALE = 1 << POLY_SUBPIXEL_SHIFT;
	private static inline var POLY_SUBPIXEL_MASK = POLY_SUBPIXEL_SCALE-1;
	//---------------------------------------------------------------------------------------------------
	private var _cellsCount:UInt;
	
	private var _cells:MemoryBlock;
	private var _cellsPtr:Pointer;
	
	private var _sortedCells:MemoryBlock;
	private var _sortedCellsPtr:Pointer;
	
	private var _sortedY:Vector<SortedY>;
	private var _currentCell:PixelCell;
	private var _minX:Int;
	private var _minY:Int;
	private var _maxX:Int;
	private var _maxY:Int;
	private var _isSorted:Bool;
<<<<<<< .mine
	
	private var _tempCell:PixelCell;
=======
	private var _storage:PixelCellStorage;
>>>>>>> .r9
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_cellsCount = 0;
		
		_cells = MemoryManager.malloc(32768 << 4);
		_cellsPtr = _cells.ptr;
		
		_sortedCells = MemoryManager.malloc(32768 << 4);
		_sortedCellsPtr = _sortedCells.ptr;

		_currentCell = new PixelCell();
		_sortedY = new Vector();
		_minX = 0x7FFFFFFF;
		_minY = 0x7FFFFFFF;
		_maxX = -0x7FFFFFFF;
		_maxY = -0x7FFFFFFF;
		_isSorted = false;
<<<<<<< .mine
		
		_tempCell = new PixelCell();
=======
		_storage = new PixelCellStorage();
>>>>>>> .r9
	}
	//---------------------------------------------------------------------------------------------------
	public function reset():Void
	{
		_cellsCount = 0;
		_currentCell.initial();
		_isSorted = false;
		_minX = 0x7FFFFFFF;
		_minY = 0x7FFFFFFF;
		_maxX = -0x7FFFFFFF;
		_maxY = -0x7FFFFFFF;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_minX():Int { return _minX; }
	public inline var minX(get_minX, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_minY():Int { return _minY; }
	public inline var minY(get_minY, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxX():Int { return _maxX; }
	public inline var maxX(get_maxX, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxY():Int { return _maxY; }
	public inline var maxY(get_maxY, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_cellsCount():UInt { return _cellsCount; }
	public inline var cellsCount(get_cellsCount, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_isSorted():Bool { return _isSorted; }
	public inline var isSorted(get_isSorted, null):Bool;
	//---------------------------------------------------------------------------------------------------
<<<<<<< .mine
	public inline function getScanlineCells(y:Int):Pointer
=======
	public inline function getScanlineCells(y:Int):PixelCellStorage
>>>>>>> .r9
	{
<<<<<<< .mine
		return _sortedCellsPtr + (_sortedY[y - _minY].start << 4);
=======
		return _storage.set(_sortedCells, _sortedY[y - _minY].start);//{ data: _sortedCells, offset: _sortedY[y - _minY].start };
>>>>>>> .r9
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getScanlineCellsCount(y:Int):UInt
	{
		return _sortedY[y - _minY].num;
	}
	//---------------------------------------------------------------------------------------------------
<<<<<<< .mine
	public inline function addCurrentCell():Void
=======
	public inline function style(styleCell:PixelCell)
	{
		_styleCell.setStyleCell(styleCell);
	}	
	//---------------------------------------------------------------------------------------------------
	public inline function addCurrentCell():Void
>>>>>>> .r9
	{
		if ((_currentCell.area | _currentCell.cover) != 0)
		{
<<<<<<< .mine
			(_cellsPtr + (_cellsCount << 4)).setAll(_currentCell);
			++_cellsCount;
=======
			_cells[_cellsCount++] = new PixelCell(_currentCell);
			//_cells[_cellsCount].set(_currentCell);
			//_cellsCount++;
>>>>>>> .r9
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function setCurrentCell(x:Int, y:Int):Void
	{
		if(_currentCell.isNotEqual(x, y))
		{
			addCurrentCell();
<<<<<<< .mine
			_currentCell.define(x, y, 0, 0);
=======
			_currentCell.define(x, y, 0, 0, _styleCell);
			//_currentCell.setStyleCell(_styleCell);
			//_currentCell.x = x;
			//_currentCell.y = y;
			//_currentCell.cover = 0;
			//_currentCell.area = 0;
>>>>>>> .r9
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function renderHLine(ey:Int, x1:Int, y1:Int, x2:Int, y2:Int):Void
	{
		var ex1 = x1 >> POLY_SUBPIXEL_SHIFT;
		var ex2 = x2 >> POLY_SUBPIXEL_SHIFT;
		var fx1 = x1 & POLY_SUBPIXEL_MASK;
		var fx2 = x2 & POLY_SUBPIXEL_MASK;

		var delta:Int, p:Int, first:Int, dx:Int;
		var incr:Int, lift:Int, mod:Int, rem:Int;

		if(y1 == y2)
		{
			setCurrentCell(ex2, ey);
			return;
		}

		if(ex1 == ex2)
		{
			delta = y2 - y1;
			_currentCell.cover += delta;
			_currentCell.area += (fx1 + fx2) * delta;
			return;
		}

		p = (POLY_SUBPIXEL_SCALE-fx1) * (y2 - y1);
		first = POLY_SUBPIXEL_SCALE;
		incr = 1;

		dx = x2 - x1;

		if(dx < 0)
		{
			p = fx1 * (y2 - y1);
			first = 0;
			incr = -1;
			dx = -dx;
		}

		delta = Std.int(p / dx);
		mod = p % dx;

		if(mod < 0)
		{
			delta--;
			mod += dx;
		}

		_currentCell.cover += delta;
		_currentCell.area += (fx1 + first) * delta;

		ex1 += incr;
		setCurrentCell(ex1, ey);
		y1 += delta;

		if(ex1 != ex2)
		{
			p = POLY_SUBPIXEL_SCALE * (y2 - y1 + delta);
			lift = Std.int(p / dx);
			rem = p % dx;

			if (rem < 0)
			{
				lift--;
				rem += dx;
			}

			mod -= dx;

			while (ex1 != ex2)
			{
				delta = lift;
				mod += rem;
				if(mod >= 0)
				{
					mod -= dx;
					delta++;
				}

				_currentCell.cover += delta;
				_currentCell.area += POLY_SUBPIXEL_SCALE * delta;
				y1 += delta;
				ex1 += incr;
				setCurrentCell(ex1, ey);
			}
		}
		delta = y2 - y1;
		_currentCell.cover += delta;
		_currentCell.area += (fx2 + POLY_SUBPIXEL_SCALE-first) * delta;
	}
	//---------------------------------------------------------------------------------------------------
	public function line(x1:Int, y1:Int, x2:Int, y2:Int):Void
	{
		var dx_limit = 16384 << POLY_SUBPIXEL_SHIFT;

		var dx = x2 - x1;

		if(dx >= dx_limit || dx <= -dx_limit)
		{
			var cx = (x1 + x2) >> 1;
			var cy = (y1 + y2) >> 1;
			line(x1, y1, cx, cy);
			line(cx, cy, x2, y2);
		}

		var dy = y2 - y1;
		var ex1 = x1 >> POLY_SUBPIXEL_SHIFT;
		var ex2 = x2 >> POLY_SUBPIXEL_SHIFT;
		var ey1 = y1 >> POLY_SUBPIXEL_SHIFT;
		var ey2 = y2 >> POLY_SUBPIXEL_SHIFT;
		var fy1 = y1 & POLY_SUBPIXEL_MASK;
		var fy2 = y2 & POLY_SUBPIXEL_MASK;

		var x_from:Int, x_to:Int;
		var p:Int, rem:Int, mod:Int, lift:Int, delta:Int, first:Int, incr:Int;

		if(ex1 < _minX) _minX = ex1;
		if(ex1 > _maxX) _maxX = ex1;
		if(ey1 < _minY) _minY = ey1;
		if(ey1 > _maxY) _maxY = ey1;
		if(ex2 < _minX) _minX = ex2;
		if(ex2 > _maxX) _maxX = ex2;
		if(ey2 < _minY) _minY = ey2;
		if(ey2 > _maxY) _maxY = ey2;

		setCurrentCell(ex1, ey1);

		if(ey1 == ey2)
		{
			renderHLine(ey1, x1, fy1, x2, fy2);
			return;
		}

		incr  = 1;
		if(dx == 0)
		{
			var ex = x1 >> POLY_SUBPIXEL_SHIFT;
			var two_fx = (x1 - (ex << POLY_SUBPIXEL_SHIFT)) << 1;
			var area;

			first = POLY_SUBPIXEL_SCALE;
			if(dy < 0)
			{
				first = 0;
				incr  = -1;
			}

			x_from = x1;

			delta = first - fy1;
			_currentCell.cover += delta;
			_currentCell.area  += two_fx * delta;

			ey1 += incr;
			setCurrentCell(ex, ey1);

			delta = first + first - POLY_SUBPIXEL_SCALE;
			area = two_fx * delta;
			while(ey1 != ey2)
			{
				_currentCell.cover = delta;
				_currentCell.area  = area;
				ey1 += incr;
				setCurrentCell(ex, ey1);
			}
			delta = fy2 - POLY_SUBPIXEL_SCALE + first;
			_currentCell.cover += delta;
			_currentCell.area  += two_fx * delta;
			return;
		}

		p = (POLY_SUBPIXEL_SCALE-fy1) * dx;
		first = POLY_SUBPIXEL_SCALE;

		if(dy < 0)
		{
			p = fy1 * dx;
			first = 0;
			incr = -1;
			dy = -dy;
		}

		delta = Std.int(p / dy);
		mod = p % dy;

		if(mod < 0)
		{
			delta--;
			mod += dy;
		}

		x_from = x1 + delta;
		renderHLine(ey1, x1, fy1, x_from, first);

		ey1 += incr;
		setCurrentCell(x_from >> POLY_SUBPIXEL_SHIFT, ey1);

		if(ey1 != ey2)
		{
			p = POLY_SUBPIXEL_SCALE * dx;
			lift = Std.int(p / dy);
			rem = p % dy;

			if(rem < 0)
			{
				lift--;
				rem += dy;
			}
			mod -= dy;

			while(ey1 != ey2)
			{
				delta = lift;
				mod += rem;
				if (mod >= 0)
				{
					mod -= dy;
					delta++;
				}

				x_to = x_from + delta;
				renderHLine(ey1, x_from, POLY_SUBPIXEL_SCALE - first, x_to, first);
				x_from = x_to;

				ey1 += incr;
				setCurrentCell(x_from >> POLY_SUBPIXEL_SHIFT, ey1);
			}
		}
		renderHLine(ey1, x_from, POLY_SUBPIXEL_SCALE - first, x2, fy2);
	}
	//---------------------------------------------------------------------------------------------------
	private function qsort(beg:Pointer, end:Pointer):Void
	{
		if (end == beg)
		{
			return;
		}
		
		var pivot = getPivotPoint(beg, end);
		
		if (pivot > beg)
		{
			qsort(beg, pivot - (1 << 4));
		}
		
		if (pivot < end)
		{
			qsort(pivot + (1 << 4), end);
		}
	}
	//---------------------------------------------------------------------------------------------------
	private function getPivotPoint(beg:Pointer, end:Pointer):Pointer
	{
		var size = 1 << 4;
		var pivot:Pointer = beg;
		var m:Pointer = beg + size;
		var n:Pointer = end;
		
		while ((m < end) && (pivot.getX() >= m.getX()))
		{
			m += size;
		}
		
		while ((n > beg) && (pivot.getX() <= n.getX()))
		{
			n -= size;
		}
		
		while (m < n)
		{
			m.getAll(_tempCell);
			m.setAllEx(n);
			n.setAll(_tempCell);
			
			while ((m < end) && (pivot.getX() >= m.getX()))
			{
				m += size;
			}
			
			while ((n > beg) && (pivot.getX() <= n.getX()))
			{
				n -= size;
			}
		}
		if (pivot != n)
		{	
			n.getAll(_tempCell);
			n.setAllEx(pivot);
			pivot.setAll(_tempCell);
		}		
		return n;
	}	
	//---------------------------------------------------------------------------------------------------
	public function sortCells()
	{
		if (_isSorted) return;

		addCurrentCell();
		_currentCell.x = 0x7FFFFFFF;
		_currentCell.y = 0x7FFFFFFF;
		_currentCell.cover = 0;
		_currentCell.area = 0;

		if (_cellsCount == 0) return;

		var _sortedYSize:UInt = _maxY - _minY + 1;
		_sortedY = new Vector<SortedY>(_sortedYSize);
		var i:UInt = 0;
		while (i < _sortedYSize)
		{
			_sortedY[i] = new SortedY();
			++i;
		}

		i = 0;
		while(i < _cellsCount)
		{
			var index = (_cellsPtr + (i << 4)).getY() - _minY;
			_sortedY[index].start++;
			++i;
		}

		var start = 0;
		i = 0;
		while (i < _sortedYSize) 
		{
			var v = _sortedY[i].start;
			_sortedY[i].start = start;
			start += v;
			i++;
		}

		i = 0;
		while (i < _cellsCount)
		{
			var sortedIndex = (_cellsPtr + (i << 4)).getY() - _minY;
			(_sortedCellsPtr + ((_sortedY[sortedIndex].start + _sortedY[sortedIndex].num) << 4)).setAllEx(_cellsPtr + (i << 4));
			++_sortedY[sortedIndex].num;
			++i;
		}

		i = 0;
		while (i < _sortedYSize)
		{
			if (_sortedY[i].num != 0)
			{
				qsort(_sortedCellsPtr + (_sortedY[i].start << 4), _sortedCellsPtr + ((_sortedY[i].start + _sortedY[i].num - 1) << 4));
			}
			++i;
		}
		
		_isSorted = true;
	}	
}