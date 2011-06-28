package lib.ha.aggx.vectorial;
//=======================================================================================================
import lib.ha.core.math.Calc;
//=======================================================================================================
class VertexDistance implements IDistanceProvider
{
	public var x:Float;
	public var y:Float;
	public var dist:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(?x_:Float, ?y_:Float)
	{
		x = x_;
		y = y_;
		dist = 0.0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function calc(val:IDistanceProvider):Bool
	{
		var ret = (dist = Calc.distance(x, y, val.x, val.y)) > Calc.VERTEX_DIST_EPSILON;
		if(!ret) dist = 1.0 / Calc.VERTEX_DIST_EPSILON;
		return ret;
	}
}