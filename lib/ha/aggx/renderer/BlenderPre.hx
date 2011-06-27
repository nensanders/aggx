package lib.ha.aggx.renderer;
//=======================================================================================================
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.RgbaReaderWriter;
using lib.ha.core.memory.RgbaReaderWriter;
//=======================================================================================================
class BlenderPre
{
	public static function blendPix(p:Pointer, cr:Byte, cg:Byte, cb:Byte, alpha:Byte, cover:Byte=0):Void
	{
		var base_shift = RgbaColor.BASE_SHIFT;
		var base_mask = RgbaColor.BASE_MASK;
		
		var r = p.getR();
		var g = p.getG();
		var b = p.getB();
		var a = p.getA();
		
		if (cover == null)
		{
			alpha = base_mask - alpha;
			r = ((r * alpha) >> base_shift) + cr;
			g = ((g * alpha) >> base_shift) + cg;
			b = ((b * alpha) >> base_shift) + cb;
			a = base_mask - ((alpha * (base_mask - a)) >> base_shift);
			
			p.setFull(r, g, b, a);
		}
		else
		{
			alpha = base_mask - alpha;
			cover = (cover + 1) << (base_shift - 8);
			r = (r * alpha + cr * cover) >> base_shift;
			g = (g * alpha + cg * cover) >> base_shift;
			b = (b * alpha + cb * cover) >> base_shift;
			a = base_mask - ((alpha * (base_mask - a)) >> base_shift);
			
			p.setFull(r, g, b, a);
		}
	}
}