package lib.ha.aggx.rasterizer;
//=======================================================================================================
interface ISpanIterator 
{
	public function initialize():Void;
	public var current(get_current, null):Span;
	public function next():Void;
}