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

package aggx.rfpx;
//=======================================================================================================
import types.Data;
import haxe.ds.Vector;
import aggx.rfpx.data.TTCHeader;
//=======================================================================================================
class TrueTypeCollection
{
    private function new()
    {

    }

	private var _fonts:Vector<TrueTypeFont>;
	//---------------------------------------------------------------------------------------------------
	public function getFont(i:Int):TrueTypeFont
	{
		return _fonts[i];
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_fontCount():UInt { return _fonts.length; }
	public var fontCount(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public static function create(file:Data, pathName:String = "" ):TrueTypeCollection
	{
		var fc = new TrueTypeCollection();
		fc.read(file, pathName);
		return fc;
	}
	//---------------------------------------------------------------------------------------------------
	private function read(file:Data, pathName:String = ""):Void
	{
		if(TTCHeader.isTTC(file))
		{
			//_ttcHeader = new TTCHeader(_data);
			//_fonts = new Vector( _ttcHeader.getDirectoryCount());
			//var i = 0, z = _ttcHeader.getDirectoryCount();
			//while (i < z)
			//{
				//_fonts[i] = new TrueTypeFont(this);
				//_fonts[i].read(_data, _ttcHeader.getTableDirectory(i), 0);
				//++i;
			//}
		} else {
			// This is a standalone font
			_fonts = new Vector(1);
			_fonts[0] = new TrueTypeFont(this);
			_fonts[0].read(file);
		}
	}

	public function getFontName(): String
	{
		return _fonts[0].getName();
	}

}