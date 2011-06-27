package lib.ha.aggx;
//=======================================================================================================
class GradientDiamond implements IGradientFunction
{
	public function new() 
	{
	}
	//---------------------------------------------------------------------------------------------------
	public function calculate(x:Int, y:Int, d:Int):Int 
	{
		var ax = Math.abs(x);
		var ay = Math.abs(y);
		return ax > ay ? ax : ay;
	}
}