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

package aggx.renderer;
//=======================================================================================================
import aggx.color.GammaLookupTable;
import aggx.core.memory.Pointer;
import aggx.core.memory.RgbaReaderWriter;
using aggx.core.memory.RgbaReaderWriter;
//=======================================================================================================
class DirectGammaApplier
{
	var _gamma:GammaLookupTable;
	//---------------------------------------------------------------------------------------------------
	public function new(gamma:GammaLookupTable)
	{
		_gamma = gamma;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function apply(p:Pointer):Void
	{
		//var r = p.getR();
		//var g = p.getG();
		//var b = p.getB();
		//var a = p.getA();
		//
		//r = _gamma.getDirectGamma(r);
		//g = _gamma.getDirectGamma(g);
		//b = _gamma.getDirectGamma(b);
		//
		//p.setFull(r, g, b, a);
		p.setFull(_gamma.getDirectGamma(p.getR()), _gamma.getDirectGamma(p.getG()), _gamma.getDirectGamma(p.getB()), _gamma.getDirectGamma(p.getA()));		
	}	
}