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
import aggx.vectorial.generators.VcgenContour;
import aggx.vectorial.IVertexSource;
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
	public var width(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineCap():Int { return cast(_generator, VcgenContour).lineCap; }
	private inline function set_lineCap(value:Int):Int { return cast(_generator, VcgenContour).lineCap = value; }
	public var lineCap(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineJoin():Int { return cast(_generator, VcgenContour).lineJoin; }
	private inline function set_lineJoin(value:Int):Int { return cast(_generator, VcgenContour).lineJoin = value; }
	public var lineJoin(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerJoin():Int { return cast(_generator, VcgenContour).innerJoin; }
	private inline function set_innerJoin(value:Int):Int { return cast(_generator, VcgenContour).innerJoin = value; }
	public var innerJoin(get, set):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_miterLimit():Float { return cast(_generator, VcgenContour).miterLimit; }
	private inline function set_miterLimit(value:Float):Float { return cast(_generator, VcgenContour).miterLimit = value; }
	public var miterLimit(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerMiterLimit():Float { return cast(_generator, VcgenContour).innerMiterLimit; }
	private inline function set_innerMiterLimit(value:Float):Float { return cast(_generator, VcgenContour).innerMiterLimit = value; }
	public var innerMiterLimit(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return cast(_generator, VcgenContour).approximationScale; }
	private inline function set_approximationScale(value:Float):Float { return cast(_generator, VcgenContour).approximationScale = value; }
	public var approximationScale(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function set_miterLimitTheta(value:Float):Float { return cast(_generator, VcgenContour).miterLimit = value; }
	public var miterLimitTheta(null, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_autoDetect():Bool { return cast(_generator, VcgenContour).autoDetect; }
	private inline function set_autoDetect(value:Bool):Bool { return cast(_generator, VcgenContour).autoDetect = value; }
	public var autoDetect(get, set):Bool;
}