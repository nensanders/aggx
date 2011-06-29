package lib.ha.aggx.rasterizer;
//=======================================================================================================
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Pointer;
//=======================================================================================================
class PixelCell
{
	private static inline var PIXEL_CELL_X = 0;
	private static inline var PIXEL_CELL_Y = 4;
	private static inline var PIXEL_CELL_AREA = 8;
	private static inline var PIXEL_CELL_COVER = 12;
	//---------------------------------------------------------------------------------------------------
	public var x:Int;
	public var y:Int;
	public var cover:Int;
	public var area:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(?cell:PixelCell)
	{
<<<<<<< .mine
		if (cell == null) 
		{
			initial();
		}
		else 
		{
			x = cell.x;
			y = cell.y;
			cover = cell.cover;
			area = cell.area;
		}
=======
		if (cell == null) 
		{
			initial();
		}
		else 
		{
			x = cell.x;
			y = cell.y;
			cover = cell.cover;
			area = cell.area;
			left = cell.left;
			right = cell.right;
		}
>>>>>>> .r9
	}	
	//---------------------------------------------------------------------------------------------------
	public function initial():Void
	{
		x = 0x7FFFFFFF;
		y = 0x7FFFFFFF;
		cover = 0;
		area = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function set(cell:PixelCell):Void
	{
		x = cell.x;
		y = cell.y;
		cover = cell.cover;
		area = cell.area;
	}
	//---------------------------------------------------------------------------------------------------
	public function define(x_:Int, y_:Int, cover_:Int, area_:Int):Void
	{
		x = x_;
		y = y_;
		cover = cover_;
		area = area_;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function isNotEqual(ex:Int, ey:Int):Bool
	{
		return ((ex - x) | (ey - y)) != 0;
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getX(addr:Pointer):Int
	{
		return untyped __vmem_get__(2, addr + PIXEL_CELL_X);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getY(addr:Pointer):Int
	{
		return untyped __vmem_get__(2, addr + PIXEL_CELL_Y);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getCover(addr:Pointer):Int
	{
		return untyped __vmem_get__(2, addr + PIXEL_CELL_COVER);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getArea(addr:Pointer):Int
	{
		return untyped __vmem_get__(2, addr + PIXEL_CELL_AREA);
	}
	//---------------------------------------------------------------------------------------------------
<<<<<<< .mine
	public static inline function getAll(addr:Pointer, cell:PixelCell):Void
=======
	public function define(x_:Int, y_:Int, cover_:Int, area_:Int, styleCell:PixelCell):Void
	{
		x = x_;
		y = y_;
		cover = cover_;
		area = area_;
		left = styleCell.left;
		right = styleCell.right;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function setStyleCell(cell:PixelCell)
>>>>>>> .r9
	{
		cell.define(
			untyped __vmem_get__(2, addr + PIXEL_CELL_X),
			untyped __vmem_get__(2, addr + PIXEL_CELL_Y),
			untyped __vmem_get__(2, addr + PIXEL_CELL_COVER),
			untyped __vmem_get__(2, addr + PIXEL_CELL_AREA));
	}
	//---------------------------------------------------------------------------------------------------
<<<<<<< .mine
	public static inline function setX(addr:Pointer, v:Int):Void
=======
	public inline function isNotEqual(ex:Int, ey:Int, cell:PixelCell):Bool
>>>>>>> .r9
	{
		untyped __vmem_set__(2, addr + PIXEL_CELL_X, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setY(addr:Pointer, v:Int):Void
	{
		untyped __vmem_set__(2, addr + PIXEL_CELL_Y, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setCover(addr:Pointer, v:Int):Void
	{
		untyped __vmem_set__(2, addr + PIXEL_CELL_COVER, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setArea(addr:Pointer, v:Int):Void
	{
		untyped __vmem_set__(2, addr + PIXEL_CELL_AREA, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setAll(addr:Pointer, cell:PixelCell):Void
	{
		untyped __vmem_set__(2, addr + PIXEL_CELL_X, cell.x);
		untyped __vmem_set__(2, addr + PIXEL_CELL_Y, cell.y);
		untyped __vmem_set__(2, addr + PIXEL_CELL_COVER, cell.cover);
		untyped __vmem_set__(2, addr + PIXEL_CELL_AREA, cell.area);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setAllEx(addr:Pointer, cellPtr:Pointer):Void
	{
		untyped __vmem_set__(2, addr + PIXEL_CELL_X, untyped __vmem_get__(2, cellPtr + PIXEL_CELL_X));
		untyped __vmem_set__(2, addr + PIXEL_CELL_Y, untyped __vmem_get__(2, cellPtr + PIXEL_CELL_Y));
		untyped __vmem_set__(2, addr + PIXEL_CELL_COVER, untyped __vmem_get__(2, cellPtr + PIXEL_CELL_COVER));
		untyped __vmem_set__(2, addr + PIXEL_CELL_AREA, untyped __vmem_get__(2, cellPtr + PIXEL_CELL_AREA));
	}
}