package lib.ha.aggx.color;
//=======================================================================================================
class GradientCircle implements IGradientFunction
{
	public function new() { }
	//---------------------------------------------------------------------------------------------------
	public function calculate(x:Int, y:Int, d:Int):Int 
	{
		return Std.int(Math.sqrt(x * x + y * y));
	}
}