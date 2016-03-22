//----------------------------------------------------------------------------
// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)
//
// Permission to copy, use, modify, sell and distribute this software 
// is granted provided this copyright notice appears in all copies. 
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//
// Haxe port by: Hypeartist hypeartist@gmail.com
// Copyright (C) 2011 https://code.google.com/p/aggx
//
//----------------------------------------------------------------------------
// Contact: mcseem@antigrain.com
//          mcseemagg@yahoo.com
//          http://www.antigrain.com
//----------------------------------------------------------------------------

package aggx.vectorial.converters;
//=======================================================================================================
import aggx.vectorial.IVertexSource;
import aggx.core.geometry.AffineTransformer;
import aggx.core.geometry.ITransformer;
import aggx.core.memory.Ref;
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
	public var transformer(null, set):ITransformer;
}