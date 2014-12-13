package lib.ha.aggx.rasterizer;
//=======================================================================================================
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Pointer;
//=======================================================================================================
interface IScanline
{
	public var spanCount(get, null):UInt;
	public var y(get, null):Int;
	public var spanIterator(get, null):ISpanIterator;
	//---------------------------------------------------------------------------------------------------
	public function reset(minX:Int, maxX:Int):Void;
	public function resetSpans():Void;
	public function finalize(y:Int):Void;
	public function addCell(x:Int, cover:Byte):Void;
	public function addCells(x:Int, len:UInt, covers:Pointer):Void;
	public function addSpan(x:Int, len:UInt, cover:Byte):Void;
}