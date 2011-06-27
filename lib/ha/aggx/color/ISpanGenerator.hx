package lib.ha.aggx.color;
//=======================================================================================================
interface ISpanGenerator
{
	public function prepare():Void;
	public function generate(span:RgbaColorStorage, x_:Int, y_:Int, len:Int):Void;
}