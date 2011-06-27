package lib.ha.aggx.rasterizer;
//=======================================================================================================
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Pointer;
//=======================================================================================================
interface IScanline
{
	public var spanCount(get_spanCount, null):UInt;
	public var y(get_y, null):Int;
	public var spanIterator(get_spanIterator, null):ISpanIterator;
	//---------------------------------------------------------------------------------------------------
	public function reset(minX:Int, maxX:Int):Void;
	public function resetSpans():Void;
	public function finalize(y:Int):Void;
	public function addCell(x:Int, cover:Byte):Void;
	public function addCells(x:Int, len:Int, covers:Pointer):Void;
	public function addSpan(x:Int, len:Int, cover:Byte):Void;
}