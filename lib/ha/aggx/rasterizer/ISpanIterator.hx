package lib.ha.aggx.rasterizer;
//=======================================================================================================
interface ISpanIterator 
{
	public function initialize():Void;
	public var current(get, null):Span;
	public function next():Void;
}