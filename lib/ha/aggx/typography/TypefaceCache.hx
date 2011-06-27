package lib.ha.aggx.typography;
//=======================================================================================================
import flash.Vector;
import lib.ha.rfpx.TrueTypeFont;
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
			//trace("cached");
		}
		if (face == null) 
		{
			var glyph = _font.getGlyphByCharCode(charCode);
			face = new Typeface(glyph, charCode);
			cache(face);
			//trace("missed");
		}
		return face;
	}
}