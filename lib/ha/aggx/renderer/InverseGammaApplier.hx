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
	public function apply(p:Pointer):Void
	{
		var r = p.getR();
		var g = p.getG();
		var b = p.getB();
		var a = p.getA();
		
		r = _gamma.getInverseGamma(r);
		g = _gamma.getInverseGamma(g);
		b = _gamma.getInverseGamma(b);
		
		p.setFull(r, g, b, a);
	}
}