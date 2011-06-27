package lib.ha.aggx.rasterizer;
//=======================================================================================================
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Pointer;
//=======================================================================================================
class ScanlineHitTest implements IScanline
{
	private var _x:Int;
	private var _isHit:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new(x:Int) 
	{
		_x = x;
		_isHit = false;
	}
	//---------------------------------------------------------------------------------------------------
	public function reset(minX:Int, maxX:Int):Void { }	
	//---------------------------------------------------------------------------------------------------
	public function resetSpans():Void {}
	//---------------------------------------------------------------------------------------------------
	public function finalize(y:Int):Void { }
	//---------------------------------------------------------------------------------------------------
	public function addCell(x:Int, y:Int):Void
	{
		if (_x == x) _isHit = true;
	}
	//---------------------------------------------------------------------------------------------------
	public function addCells(x:Int, len:Int, covers:Pointer):Void { }	
	//---------------------------------------------------------------------------------------------------
	public function addSpan(x:Int, len:Int, cover:Byte):Void
	{
		if (_x >= x && _x < x + len) _isHit = true;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_spanCount():UInt { return 1; }
	public inline var spanCount(get_spanCount, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_isHit():Bool { return _isHit; }
	public inline var isHit(get_isHit, null):Bool;
	//---------------------------------------------------------------------------------------------------
	private inline function get_y():Int { return 0; }
	public inline var y(get_y, null):Int;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_spanIterator():ISpanIterator { return null; }
	public inline var spanIterator(get_spanIterator, null):ISpanIterator;
}