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

package lib.ha.aggx.rasterizer;
//=======================================================================================================
import lib.ha.core.utils.Debug;
import lib.ha.core.utils.DataPointer;
import haxe.CallStack;
import haxe.ds.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.aggx.rasterizer.PixelCell;
import lib.ha.aggx.rasterizer.PixelCellDataExtensions;
import types.Data;
using lib.ha.aggx.rasterizer.PixelCellDataExtensions;
//=======================================================================================================
class SortedY
{
	public var start:Int = 0;
	public var num:UInt = 0;
	//---------------------------------------------------------------------------------------------------
	public function new()
    {
        start = 0;
        num = 0;
    }

    public function toString(): String
    {
        return '{start: $start, num $num}';
    }
}
//=======================================================================================================
class PixelCellRasterizer
{
	private static inline var POLY_SUBPIXEL_SHIFT = 8;
	private static inline var POLY_SUBPIXEL_SCALE = 1 << POLY_SUBPIXEL_SHIFT;
	private static inline var POLY_SUBPIXEL_MASK = POLY_SUBPIXEL_SCALE-1;
    private static inline var PIXEL_SIZE = 16;
	//---------------------------------------------------------------------------------------------------
	private var _cellsCount:UInt;
	private var _cellsCapacity:UInt;

	private var _cells: Data;
	private var _cellsPtr:DataPointer;
	
	private var _sortedCells: Data;
	private var _sortedCellsPtr: DataPointer;
	
	private var _sortedY:Vector<SortedY>;
	private var _currentCell:PixelCell;
	private var _minX:Int;
	private var _minY:Int;
	private var _maxX:Int;
	private var _maxY:Int;
	private var _isSorted:Bool;

	private var _tempCell:PixelCell;

	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_cellsCount = 0;

        _cellsCapacity = 32768;
		
		_cells = new Data(_cellsCapacity * PIXEL_SIZE);
		_cellsPtr = new DataPointer(_cells);
		
		_sortedCells = new Data(_cellsCapacity * PIXEL_SIZE);
		_sortedCellsPtr = new DataPointer(_sortedCells);

		_currentCell = new PixelCell();
		_sortedY = null;
		_minX = 0x7FFFFFFF;
		_minY = 0x7FFFFFFF;
		_maxX = -0x7FFFFFFF;
		_maxY = -0x7FFFFFFF;
		_isSorted = false;

		_tempCell = new PixelCell();

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
	public var minX(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_minY():Int { return _minY; }
	public var minY(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxX():Int { return _maxX; }
	public var maxX(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxY():Int { return _maxY; }
	public var maxY(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_cellsCount():UInt { return _cellsCount; }
	public var cellsCount(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_isSorted():Bool { return _isSorted; }
	public var isSorted(get, null):Bool;
	//---------------------------------------------------------------------------------------------------

	public inline function getScanlineCells(y:Int):DataPointer
	{
        //trace('getScanlineCells: $y offset: ${_sortedY[y - _minY].start * PIXEL_SIZE}');
        _sortedCellsPtr.offset = _sortedY[y - _minY].start * PIXEL_SIZE;
		return _sortedCellsPtr;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getScanlineCellsCount(y:Int):UInt
	{
		return _sortedY[y - _minY].num;
	}
	//---------------------------------------------------------------------------------------------------

	public inline function addCurrentCell():Void
	{
		if ((_currentCell.area | _currentCell.cover) != 0)
		{
            _cellsPtr.offset = _cellsCount * PIXEL_SIZE;
            _cellsPtr.setAll(_currentCell);
			//trace(_currentCell);

			++_cellsCount;

            if (_cellsCount + 1 > _cellsCapacity)
            {
                _cellsCapacity = Math.floor(_cellsCapacity * 1.8);
                _cells.resize(_cellsCapacity * PIXEL_SIZE);
                _sortedCells.resize(_cellsCapacity * PIXEL_SIZE);
            }
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function setCurrentCell(x:Int, y:Int):Void
	{
		if(_currentCell.isNotEqual(x, y))
		{
			addCurrentCell();

			_currentCell.define(x, y, 0, 0);

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
		//trace('line $x1 $y1 $x2 $y2');
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

		//trace('$ex1 $ey1 $ex2 $ey2 $fy1 $fy2');

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
	private function qsort(data: Data, beg: Int, end:Int):Void
	{
        //trace('beg: $beg end: $end');
		if (end == beg)
		{
			return;
		}

		var stack = new Vector(end - beg + 1);
		var top = -1;
		stack[++top] = beg;
		stack[++top] = end;

		while (top >= 0)
		{
			end = stack[top--];
			beg = stack[top--];
			var pivot = getPivotPoint(data, beg, end);
			if (pivot > beg)
			{
				stack[++top] = beg;
				stack[++top] = pivot - PIXEL_SIZE;
			}

			if (pivot < end)
			{
				stack[++top] = pivot + PIXEL_SIZE;
				stack[++top] = end;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	private function getPivotPoint(data: Data, beg:Int, end:Int):Pointer
	{
		var pivot:Pointer = beg;
		var m:Pointer = beg + PIXEL_SIZE;
		var n:Pointer = end;
		
		while ((m < end) && (data.dataGetX(pivot) >= data.dataGetX(m)))
		{
			m += PIXEL_SIZE;
		}
		
		while ((n > beg) && (data.dataGetX(pivot) <= data.dataGetX(n)))
		{
			n -= PIXEL_SIZE;
		}
		
		while (m < n)
		{
            data.dataSwapPixel(m, n);
			
			while ((m < end) && (data.dataGetX(pivot) >= data.dataGetX(m)))
			{
				m += PIXEL_SIZE;
			}
			
			while ((n > beg) && (data.dataGetX(pivot) <= data.dataGetX(n)))
			{
				n -= PIXEL_SIZE;
			}
		}
		if (pivot != n)
		{
            data.dataSwapPixel(pivot, n);
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
            _cellsPtr.offset =  i * PIXEL_SIZE;
			var index = _cellsPtr.getY() - _minY;

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
            _cellsPtr.offset = i * PIXEL_SIZE;
			var sortedIndex = _cellsPtr.getY() - _minY;

            _cellsPtr.offset = i * PIXEL_SIZE;
            _sortedCellsPtr.offset = (_sortedY[sortedIndex].start + _sortedY[sortedIndex].num) * PIXEL_SIZE;
			_sortedCellsPtr.setAllEx(_cellsPtr);

			++_sortedY[sortedIndex].num;
			++i;
		}

		i = 0;
		while (i < _sortedYSize)
		{
			if (_sortedY[i].num != 0)
			{
                /*trace('before sort:');
                for (j in 0 ... _sortedY[i].num)
                {
                    _sortedCellsPtr.offset = (_sortedY[i].start + j) * PIXEL_SIZE;
                    _sortedCellsPtr.getAll(_tempCell);
                    trace(_tempCell);
                }*/

				qsort(_sortedCellsPtr.data, _sortedY[i].start * PIXEL_SIZE, (_sortedY[i].start + _sortedY[i].num - 1) * PIXEL_SIZE);
			}
			++i;
		}
		
		_isSorted = true;
	}	
}