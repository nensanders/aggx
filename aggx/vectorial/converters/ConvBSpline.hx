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
import aggx.vectorial.generators.VcgenBSpline;
import aggx.vectorial.IVertexSource;
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
	public var interpolationStep(get, set):Float;
}