package lib.ha.aggx.rasterizer;
//=======================================================================================================
import lib.ha.core.memory.Byte;
//=======================================================================================================
class PixelCell
{
	public var x:Int;
	public var y:Int;
	public var cover:Int;
	public var area:Int;
	public var left:Int;
	public var right:Int;
	//---------------------------------------------------------------------------------------------------
	public function new()
	{
		initial();
	}	
	//---------------------------------------------------------------------------------------------------
	public function initial():Void
	{
		x = 0x7FFFFFFF;
		y = 0x7FFFFFFF;
		cover = 0;
		area = 0;
		left = -1;
		right = -1;
	}
	//---------------------------------------------------------------------------------------------------
	public function set(cell:PixelCell):Void
	{
		x = cell.x;
		y = cell.y;
		cover = cell.cover;
		area = cell.area;
		left = cell.left;
		right = cell.right;
	}
	//---------------------------------------------------------------------------------------------------
	public function setStyleCell(cell:PixelCell)
	{
		left = cell.left;
		right = cell.right;
	}
	//---------------------------------------------------------------------------------------------------
	public function isNotEqual(ex:Int, ey:Int, cell:PixelCell):Bool
	{
		return ((ex - x) | (ey - y) | (left - cell.left) | (right - cell.right)) != 0;
	}
}