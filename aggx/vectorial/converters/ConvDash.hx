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
import aggx.vectorial.generators.VcgenDash;
import aggx.vectorial.IVertexSource;
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
	public var shorten(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function set_dashStart(value:Float):Float { return cast(_generator, VcgenDash).dashStart = value; }
	public var dashStart(null, set):Float;
}