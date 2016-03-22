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

package aggx.typography;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.rfpx.TrueTypeFont;
//=======================================================================================================
class TypefaceCache 
{
	private var _font:TrueTypeFont;
	private var _faces:Vector<Vector<Typeface>>;
	//---------------------------------------------------------------------------------------------------
	public function new(font:TrueTypeFont)
	{
		_faces = new Vector(256);
		_font = font;
	}
	//---------------------------------------------------------------------------------------------------
	public function cache(face:Typeface):Void
	{
		var msb = (face.charCode >> 8) & 0xFF;
		if (_faces[msb] == null)
		{
			_faces[msb] = new Vector(256);
		}
		var lsb = face.charCode & 0xFF;
		var test = _faces[msb][lsb];
		if (test == null) 
		{
			_faces[msb][lsb] = face;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getFace(charCode:UInt):Typeface
	{
		var face:Typeface = null;
		var msb = (charCode >> 8) & 0xFF;
		if (_faces[msb] != null)
		{
			face = _faces[msb][charCode & 0xFF];
		}
		if (face == null) 
		{
			var glyph = _font.getGlyphByCharCode(charCode);
			face = new Typeface(glyph, charCode);
			cache(face);
		}
		return face;
	}
}