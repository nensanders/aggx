package lib.ha.aggx.renderer;
//=======================================================================================================
import lib.ha.aggx.color.RgbaColor;
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.RgbaReaderWriter;
using lib.ha.core.memory.RgbaReaderWriter;
//=======================================================================================================
// implements: Blender
//=======================================================================================================
class BlenderBase
{
	public static function blendPix(p:Pointer, cr:Byte, cg:Byte, cb:Byte, alpha:Byte, cover:Byte=0):Void
	{
		var base_shift = RgbaColor.BASE_SHIFT;
		
		var r = p.getR();
		var g = p.getG();
		var b = p.getB();
		var a = p.getA();
		
		r = ((cr - r) * alpha + (r << base_shift)) >> base_shift;
		g = ((cg - g) * alpha + (g << base_shift)) >> base_shift;
		b = ((cb - b) * alpha + (b << base_shift)) >> base_shift;
		a = (alpha + a) - ((alpha * a + RgbaColor.BASE_MASK) >> base_shift);
		
		p.setFull(r, g, b, a);
	}
}