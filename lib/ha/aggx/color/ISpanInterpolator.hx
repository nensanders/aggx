package lib.ha.aggx.color;
//=======================================================================================================
import lib.ha.core.memory.Ref;
//=======================================================================================================
interface ISpanInterpolator 
{
	public function begin(x:Float, y:Float, len:Int):Void;
	public function op_inc():Void;
	public function coordinates(x:IntRef, y:IntRef):Void;
}