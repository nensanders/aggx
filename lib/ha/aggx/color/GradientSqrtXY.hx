package lib.ha.aggx.color;
//=======================================================================================================
class GradientSqrtXY implements IGradientFunction
{
	public function new() 
	{
	}
	//---------------------------------------------------------------------------------------------------
	public function calculate(x:Int, y:Int, d:Int):Int 
	{
		return Math.sqrt(Math.abs(x) * Math.abs(y));
	}
}