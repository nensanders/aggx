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
import aggx.core.memory.Byte;
import aggx.core.memory.Pointer;
import aggx.core.memory.RgbaReaderWriter;
using aggx.core.memory.RgbaReaderWriter;
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