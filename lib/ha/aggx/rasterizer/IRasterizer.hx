package lib.ha.aggx.rasterizer;
//=======================================================================================================
interface IRasterizer 
{
	public function rewindScanlines():Bool;
	public function sweepScanline(sl:IScanline):Bool;
	public var minX(get, null):Int;
	public var minY(get, null):Int;
	public var maxX(get, null):Int;
	public var maxY(get, null):Int;
}