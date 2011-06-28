package lib.ha.aggx.rasterizer;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.OffsetableStorage;
//=======================================================================================================
class PixelCellStorage
{
	public var offset:Int;
	public var data:Vector<PixelCell>;
	//---------------------------------------------------------------------------------------------------
	public function new() { }
	//---------------------------------------------------------------------------------------------------
	public inline function set(d:Vector<PixelCell>, o:Int):PixelCellStorage
	{
		offset = o;
		data = d;
		return this;
	}
}