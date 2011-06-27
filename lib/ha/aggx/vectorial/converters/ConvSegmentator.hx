package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.VpgenSegmentator;
import lib.ha.aggx.vectorial.IVertexSource;
//=======================================================================================================
class ConvSegmentator extends ConvAdaptorVpgen
{
	public function new(vs:IVertexSource) 
	{
		super(vs);
		_generator = new VpgenSegmentator();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximation_scale():Float { return cast(_generator, VpgenSegmentator).approximationScale; }
	private inline function set_approximation_scale(value:Float):Float { return cast(_generator, VpgenSegmentator).approximationScale = value; }
	public inline var approximationScale(get_approximation_scale, set_approximation_scale):Float;
}