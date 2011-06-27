package lib.ha.aggx.color;
//=======================================================================================================
class GradientXY implements IGradientFunction
{
	public function new() 
	{
	}
	//---------------------------------------------------------------------------------------------------
	public function calculate(x:Int, y:Int, d:Int):Int 
	{
		return Std.int(Math.abs(x) * Math.abs(y) / d);
	}
}