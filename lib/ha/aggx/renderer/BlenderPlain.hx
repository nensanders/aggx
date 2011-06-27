package lib.ha.aggx.renderer;
//=======================================================================================================
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.RgbaReaderWriter;
using lib.ha.core.memory.RgbaReaderWriter;
//=======================================================================================================
// implements: Blender
//=======================================================================================================
class BlenderPlain
{
	public static function blendPix(p:Pointer, cr:Byte, cg:Byte, cb:Byte, alpha:Byte, cover:Byte=0):Void
	{
		var base_shift = RgbaColor.BASE_SHIFT;
		
		if (alpha == 0) return;
		
		var a = p.getA();
		var r = p.getR() * a;
		var g = p.getG() * a;
		var b = p.getB() * a;
		
		a = ((alpha + a) << base_shift) - alpha * a;
		
		a = (a >> base_shift);
		r = ((((cr << base_shift) - r) * alpha + (r << base_shift)) / a);
		g = ((((cg << base_shift) - g) * alpha + (g << base_shift)) / a);
		b = ((((cb << base_shift) - b) * alpha + (b << base_shift)) / a);
		
		p.setFull(r, g, b, a);
	}
}