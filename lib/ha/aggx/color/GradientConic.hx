package lib.ha.aggx.color;
//=======================================================================================================
import lib.ha.core.utils.Calc;
//=======================================================================================================
class GradientConic implements IGradientFunction
{
	public function new() 
	{
	}
	//---------------------------------------------------------------------------------------------------
	public function calculate(x:Int, y:Int, d:Int):Int 
	{
		return Std.int((Calc.fabs(Math.atan2(y, x)) * d / Calc.pi));
	}
}