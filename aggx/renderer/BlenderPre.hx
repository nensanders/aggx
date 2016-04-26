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