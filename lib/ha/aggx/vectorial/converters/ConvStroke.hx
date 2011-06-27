package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.IMarkerGenerator;
import lib.ha.aggx.vectorial.generators.VcgenStroke;
import lib.ha.aggx.vectorial.IVertexSource;
//=======================================================================================================
class ConvStroke extends ConvAdaptorVcgen
{
	public function new(vs:IVertexSource, ?markers:IMarkerGenerator) 
	{
		super(vs, markers);
		_generator = new VcgenStroke();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():Float { return cast(_generator, VcgenStroke).width; }
	private inline function set_width(value:Float):Float { return cast(_generator, VcgenStroke).width = value; }
	public inline var width(get_width, set_width):Float;		
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineCap():Int { return cast(_generator, VcgenStroke).lineCap; }
	private inline function set_lineCap(value:Int):Int { return cast(_generator, VcgenStroke).lineCap = value; }
	public inline var lineCap(get_lineCap, set_lineCap):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineJoin():Int { return cast(_generator, VcgenStroke).lineJoin; }
	private inline function set_lineJoin(value:Int):Int { return cast(_generator, VcgenStroke).lineJoin = value; }
	public inline var lineJoin(get_lineJoin, set_lineJoin):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerJoin():Int { return cast(_generator, VcgenStroke).innerJoin; }
	private inline function set_innerJoin(value:Int):Int { return cast(_generator, VcgenStroke).innerJoin = value; }
	public inline var innerJoin(get_innerJoin, set_innerJoin):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_miterLimit():Float { return cast(_generator, VcgenStroke).miterLimit; }
	private inline function set_miterLimit(value:Float):Float { return cast(_generator, VcgenStroke).miterLimit = value; }
	public inline var miterLimit(get_miterLimit, set_miterLimit):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerMiterLimit():Float { return cast(_generator, VcgenStroke).innerMiterLimit; }
	private inline function set_innerMiterLimit(value:Float):Float { return cast(_generator, VcgenStroke).innerMiterLimit = value; }
	public inline var innerMiterLimit(get_innerMiterLimit, set_innerMiterLimit):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return cast(_generator, VcgenStroke).approximationScale; }
	private inline function set_approximationScale(value:Float):Float { return cast(_generator, VcgenStroke).approximationScale = value; }
	public inline var approximationScale(get_approximationScale, set_approximationScale):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function set_miterLimitTheta(value:Float):Float { return cast(_generator, VcgenStroke).miterLimit = value; }
	public inline var miterLimitTheta(null, set_miterLimitTheta):Float;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_shorten():Float { return cast(_generator, VcgenStroke).shorten; }
	private inline function set_shorten(value:Float):Float { return cast(_generator, VcgenStroke).shorten = value; }
	public inline var shorten(get_shorten, set_shorten):Float;
}