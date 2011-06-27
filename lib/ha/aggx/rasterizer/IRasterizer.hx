package lib.ha.aggx.rasterizer;
//=======================================================================================================
interface IRasterizer 
{
	public function rewindScanlines():Bool;
	public function sweepScanline(sl:IScanline):Bool;
	public var minX(get_minX, null):Int;
	public var minY(get_minY, null):Int;
	public var maxX(get_maxX, null):Int;
	public var maxY(get_maxY, null):Int;
}