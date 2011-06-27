package lib.ha.aggx.color;
//=======================================================================================================
interface ISpanAllocator
{
	public function allocate(spanLen:UInt):RgbaColorStorage;
}