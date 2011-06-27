package lib.ha.aggx.rasterizer;
//=======================================================================================================
import flash.Vector;
//=======================================================================================================
class SpanIterator implements ISpanIterator
{
	private var _spans:Vector<Span>;
	private var _index:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new(spans:Vector<Span>) 
	{
		_spans = spans;
		_index = 1;
	}
	//---------------------------------------------------------------------------------------------------
	public function initialize():Void 
	{
		_index = 1;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_current():Span { return _spans[_index]; }
	public inline var current(get_current, null):Span;
	//---------------------------------------------------------------------------------------------------
	public inline function next():Void { ++_index; }
}