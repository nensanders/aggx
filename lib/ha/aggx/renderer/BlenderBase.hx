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
	public static inline function blendPix(p:Pointer, cr:Byte, cg:Byte, cb:Byte, alpha:Byte, cover:Byte=0):Void
	{
		var r = p.getR();
		var g = p.getG();
		var b = p.getB();
		var a = p.getA();
		
		p.setFull(
			((cr - r) * alpha + (r << RgbaColor.BASE_SHIFT)) >> RgbaColor.BASE_SHIFT,
			((cg - g) * alpha + (g << RgbaColor.BASE_SHIFT)) >> RgbaColor.BASE_SHIFT, 
			((cb - b) * alpha + (b << RgbaColor.BASE_SHIFT)) >> RgbaColor.BASE_SHIFT, 
			(alpha + a) - ((alpha * a + RgbaColor.BASE_MASK) >> RgbaColor.BASE_SHIFT));
	}
}