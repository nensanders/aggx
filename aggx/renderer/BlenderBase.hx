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
import aggx.color.RgbaColor;
import aggx.core.memory.Byte;
import aggx.core.memory.Pointer;
import aggx.core.memory.RgbaReaderWriter;
using aggx.core.memory.RgbaReaderWriter;
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