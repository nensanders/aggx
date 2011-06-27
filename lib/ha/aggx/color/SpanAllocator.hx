package lib.ha.aggx.color;
//=======================================================================================================
import flash.Vector;
//=======================================================================================================
class SpanAllocator implements ISpanAllocator
{
	private var _span:Vector<RgbaColor>;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_span = new Vector();
	}
	//---------------------------------------------------------------------------------------------------
	public function allocate(spanLen:UInt):RgbaColorStorage
	{
		if (spanLen > _span.length)
		{
			_span.length = 0;
			_span.length = ((spanLen + 255) >> 8) << 8;
		}
		return { data: _span, offset:0 };
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_span():RgbaColorStorage { return { data: _span, offset:0 }; }
	public inline var span(get_span, null):RgbaColorStorage;
	//---------------------------------------------------------------------------------------------------
	private inline function get_max_span_len():UInt { return _span.length; }
	public inline var maxSpanLength(get_max_span_len, null):UInt;
}