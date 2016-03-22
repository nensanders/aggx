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

package aggx.rasterizer;
//=======================================================================================================
import aggx.core.memory.MemoryAccess;
import aggx.core.memory.Pointer;
//=======================================================================================================
class PixelCell
{
	public static inline var PIXEL_CELL_X = 0;
	public static inline var PIXEL_CELL_Y = 4;
	public static inline var PIXEL_CELL_AREA = 8;
	public static inline var PIXEL_CELL_COVER = 12;
	public static inline var SIZE = 16;
	//---------------------------------------------------------------------------------------------------
	public var x:Int;
	public var y:Int;
	public var cover:Int;
	public var area:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(?cell:PixelCell)
	{
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
	}

	public function toString(): String
	{
		return '{x: $x, y: $y, area: $area, cover: $cover}';
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
		return MemoryAccess.getInt32(addr + PIXEL_CELL_X);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getY(addr:Pointer):Int
	{
		return MemoryAccess.getInt32(addr + PIXEL_CELL_Y);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getCover(addr:Pointer):Int
	{
		return MemoryAccess.getInt32(addr + PIXEL_CELL_COVER);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function getArea(addr:Pointer):Int
	{
		return MemoryAccess.getInt32(addr + PIXEL_CELL_AREA);
	}
	//---------------------------------------------------------------------------------------------------

	public static inline function getAll(addr:Pointer, cell:PixelCell):Void
	{
		cell.define(
            MemoryAccess.getInt32(addr + PIXEL_CELL_X),
            MemoryAccess.getInt32(addr + PIXEL_CELL_Y),
            MemoryAccess.getInt32(addr + PIXEL_CELL_COVER),
            MemoryAccess.getInt32(addr + PIXEL_CELL_AREA));
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setX(addr:Pointer, v:Int):Void
	{
        MemoryAccess.setInt32(addr + PIXEL_CELL_X, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setY(addr:Pointer, v:Int):Void
	{
        MemoryAccess.setInt32(addr + PIXEL_CELL_Y, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setCover(addr:Pointer, v:Int):Void
	{
        MemoryAccess.setInt32(addr + PIXEL_CELL_COVER, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setArea(addr:Pointer, v:Int):Void
	{
        MemoryAccess.setInt32(addr + PIXEL_CELL_AREA, v);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setAll(addr:Pointer, cell:PixelCell):Void
	{
        MemoryAccess.setInt32(addr + PIXEL_CELL_X, cell.x);
        MemoryAccess.setInt32(addr + PIXEL_CELL_Y, cell.y);
        MemoryAccess.setInt32(addr + PIXEL_CELL_COVER, cell.cover);
        MemoryAccess.setInt32(addr + PIXEL_CELL_AREA, cell.area);
	}
	//---------------------------------------------------------------------------------------------------
	public static inline function setAllEx(addr:Pointer, cellPtr:Pointer):Void
	{
        MemoryAccess.setInt32(addr + PIXEL_CELL_X, MemoryAccess.getInt32(cellPtr + PIXEL_CELL_X));
        MemoryAccess.setInt32(addr + PIXEL_CELL_Y, MemoryAccess.getInt32(cellPtr + PIXEL_CELL_Y));
        MemoryAccess.setInt32(addr + PIXEL_CELL_COVER, MemoryAccess.getInt32(cellPtr + PIXEL_CELL_COVER));
        MemoryAccess.setInt32(addr + PIXEL_CELL_AREA, MemoryAccess.getInt32(cellPtr + PIXEL_CELL_AREA));
	}
}