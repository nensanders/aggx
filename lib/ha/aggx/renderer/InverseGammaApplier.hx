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

package lib.ha.aggx.renderer;
//=======================================================================================================
import lib.ha.aggx.color.GammaLookupTable;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.RgbaReaderWriter;
using lib.ha.core.memory.RgbaReaderWriter;
//=======================================================================================================
class InverseGammaApplier 
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
		//r = _gamma.getInverseGamma(r);
		//g = _gamma.getInverseGamma(g);
		//b = _gamma.getInverseGamma(b);
		
		//p.setFull(r, g, b, a);
		p.setFull(_gamma.getInverseGamma(p.getR()), _gamma.getInverseGamma(p.getG()), _gamma.getInverseGamma(p.getB()), _gamma.getInverseGamma(p.getA()));
	}
}