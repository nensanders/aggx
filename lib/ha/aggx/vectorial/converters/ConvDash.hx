package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.IMarkerGenerator;
import lib.ha.aggx.vectorial.generators.VcgenDash;
import lib.ha.aggx.vectorial.IVertexSource;
//=======================================================================================================
class ConvDash extends ConvAdaptorVcgen
{
	public function new(vs:IVertexSource, ?markers:IMarkerGenerator) 
	{
		super(vs, markers);
		_generator = new VcgenDash();
	}
	//---------------------------------------------------------------------------------------------------
	public function removeAllDashes():Void
	{
		cast(_generator, VcgenDash).removeAllDashes();
	}
	//---------------------------------------------------------------------------------------------------
	public function addDash(dashLen:Float, gapLen:Float):Void
	{
		cast(_generator, VcgenDash).addDash(dashLen, gapLen);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_shorten():Float { return cast(_generator, VcgenDash).shorten; }
	private inline function set_shorten(value:Float):Float { return cast(_generator, VcgenDash).shorten = value; }
	public inline var shorten(get_shorten, set_shorten):Float;	
	//---------------------------------------------------------------------------------------------------
	private inline function set_dashStart(value:Float):Float { return cast(_generator, VcgenDash).dashStart = value; }
	public inline var dashStart(null, set_dashStart):Float;
}