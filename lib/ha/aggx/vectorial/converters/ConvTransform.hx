package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.IVertexSource;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.geometry.ITransformer;
import lib.ha.core.memory.Ref;
//=======================================================================================================
class ConvTransform implements IVertexSource
{
    private var _source:IVertexSource;
    private var _transformer:ITransformer;
	//---------------------------------------------------------------------------------------------------
	public function new(vs:IVertexSource, ?trans:ITransformer) 
	{
		_source = vs;
		_transformer = trans == null ? new AffineTransformer() : trans;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(source:IVertexSource):Void
	{
		_source = source;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt)
	{
		_source.rewind(pathId);
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		var cmd = _source.getVertex(x, y);
		if(PathUtils.isVertex(cmd))
		{
			_transformer.transform(x, y);
		}
		return cmd;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function set_transformer(value:ITransformer):ITransformer { return _transformer = value; }
	public inline var transformer(null, set_transformer):ITransformer;
}