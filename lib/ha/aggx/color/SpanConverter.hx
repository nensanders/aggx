package lib.ha.aggx.color;
//=======================================================================================================
class SpanConverter implements ISpanGenerator
{
	private var _spanGen:ISpanGenerator;
	private var _spanCnv:ISpanGenerator;
	//---------------------------------------------------------------------------------------------------
	public function new(gen:ISpanGenerator, conv:ISpanGenerator)
	{
		_spanCnv = conv;
		_spanGen = gen;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach_generator(spanGen:ISpanGenerator) { _spanGen = spanGen; }
	//---------------------------------------------------------------------------------------------------
	public function attach_converter(spanCnv:ISpanGenerator) { _spanCnv = spanCnv; }	
	//---------------------------------------------------------------------------------------------------
	public function prepare():Void
	{
		_spanGen.prepare();
		_spanCnv.prepare();
	}
	//---------------------------------------------------------------------------------------------------
	public function generate(span:RgbaColorStorage, x_:Int, y_:Int, len:Int):Void
	{
		_spanGen.generate(span, x_, y_, len);
		_spanCnv.generate(span, x_, y_, len);
	}	
}