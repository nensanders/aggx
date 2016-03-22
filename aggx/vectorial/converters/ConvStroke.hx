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
import aggx.vectorial.generators.IMarkerGenerator;
import aggx.vectorial.generators.VcgenStroke;
import aggx.vectorial.IVertexSource;
//=======================================================================================================
class ConvStroke extends ConvAdaptorVcgen
{
	private var _gen:VcgenStroke;
	//---------------------------------------------------------------------------------------------------
	public function new(vs:IVertexSource, ?markers:IMarkerGenerator) 
	{
		super(vs, markers);
		_generator = _gen = new VcgenStroke();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():Float { return _gen.width; }
	private inline function set_width(value:Float):Float { return _gen.width = value; }
	public var width(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineCap():Int { return _gen.lineCap; }
	private inline function set_lineCap(value:Int):Int { return _gen.lineCap = value; }
	public var lineCap(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineJoin():Int { return _gen.lineJoin; }
	private inline function set_lineJoin(value:Int):Int { return _gen.lineJoin = value; }
	public var lineJoin(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerJoin():Int { return _gen.innerJoin; }
	private inline function set_innerJoin(value:Int):Int { return _gen.innerJoin = value; }
	public var innerJoin(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_miterLimit():Float { return _gen.miterLimit; }
	private inline function set_miterLimit(value:Float):Float { return _gen.miterLimit = value; }
	public var miterLimit(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerMiterLimit():Float { return _gen.innerMiterLimit; }
	private inline function set_innerMiterLimit(value:Float):Float { return _gen.innerMiterLimit = value; }
	public var innerMiterLimit(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return _gen.approximationScale; }
	private inline function set_approximationScale(value:Float):Float { return _gen.approximationScale = value; }
	public var approximationScale(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function set_miterLimitTheta(value:Float):Float { return _gen.miterLimit = value; }
	public var miterLimitTheta(null, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_shorten():Float { return _gen.shorten; }
	private inline function set_shorten(value:Float):Float { return _gen.shorten = value; }
	public var shorten(get, set):Float;
}