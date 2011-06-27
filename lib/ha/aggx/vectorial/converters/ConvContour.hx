package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.VcgenContour;
import lib.ha.aggx.vectorial.IVertexSource;
//=======================================================================================================
class ConvContour extends ConvAdaptorVcgen
{
	public function new(vs:IVertexSource) 
	{
		super(vs);
		_generator = new VcgenContour();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():Float { return cast(_generator, VcgenContour).width; }
	private inline function set_width(value:Float):Float { return cast(_generator, VcgenContour).width = value; }
	public inline var width(get_width, set_width):Float;		
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineCap():Int { return cast(_generator, VcgenContour).lineCap; }
	private inline function set_lineCap(value:Int):Int { return cast(_generator, VcgenContour).lineCap = value; }
	public inline var lineCap(get_lineCap, set_lineCap):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineJoin():Int { return cast(_generator, VcgenContour).lineJoin; }
	private inline function set_lineJoin(value:Int):Int { return cast(_generator, VcgenContour).lineJoin = value; }
	public inline var lineJoin(get_lineJoin, set_lineJoin):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerJoin():Int { return cast(_generator, VcgenContour).innerJoin; }
	private inline function set_innerJoin(value:Int):Int { return cast(_generator, VcgenContour).innerJoin = value; }
	public inline var innerJoin(get_innerJoin, set_innerJoin):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_miterLimit():Float { return cast(_generator, VcgenContour).miterLimit; }
	private inline function set_miterLimit(value:Float):Float { return cast(_generator, VcgenContour).miterLimit = value; }
	public inline var miterLimit(get_miterLimit, set_miterLimit):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerMiterLimit():Float { return cast(_generator, VcgenContour).innerMiterLimit; }
	private inline function set_innerMiterLimit(value:Float):Float { return cast(_generator, VcgenContour).innerMiterLimit = value; }
	public inline var innerMiterLimit(get_innerMiterLimit, set_innerMiterLimit):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return cast(_generator, VcgenContour).approximationScale; }
	private inline function set_approximationScale(value:Float):Float { return cast(_generator, VcgenStroke).approximationScale = value; }
	public inline var approximationScale(get_approximationScale, set_approximationScale):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function set_miterLimitTheta(value:Float):Float { return cast(_generator, VcgenContour).miterLimit = value; }
	public inline var miterLimitTheta(null, set_miterLimitTheta):Float;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_autoDetect():Bool { return cast(_generator, VcgenContour).autoDetect; }
	private inline function set_autoDetect(value:Bool):Bool { return cast(_generator, VcgenContour).autoDetect = value; }
	public inline var autoDetect(get_autoDetect, set_autoDetect):Bool;
}