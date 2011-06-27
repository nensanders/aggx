package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.VcgenBSpline;
import lib.ha.aggx.vectorial.IVertexSource;
//=======================================================================================================
class ConvBSpline extends ConvAdaptorVcgen
{
	public function new(vs:IVertexSource) 
	{
		super(vs);
		_generator = new VcgenBSpline();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_interpolationStep():Float { return cast(_generator, VcgenBSpline).interpolationStep; }
	private inline function set_interpolationStep(value:Float):Float { return cast(_generator, VcgenBSpline).interpolationStep = value; }
	public inline var interpolationStep(get_interpolationStep, set_interpolationStep):Float;
}