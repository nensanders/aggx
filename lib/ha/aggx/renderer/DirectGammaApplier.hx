package lib.ha.aggx.renderer;
//=======================================================================================================
import lib.ha.aggx.color.GammaLookupTable;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.RgbaReaderWriter;
using lib.ha.core.memory.RgbaReaderWriter;
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