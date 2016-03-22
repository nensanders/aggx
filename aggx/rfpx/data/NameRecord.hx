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

package aggx.rfpx.data;
//=======================================================================================================
import aggx.core.utils.Debug;
import types.Data;
import aggx.core.memory.Pointer;
import aggx.core.memory.Ref;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class NameRecord 
{
	public var _platformID:UInt;			//USHORT
    public var _encodingID:UInt;			//USHORT
    public var _languageID:UInt;			//USHORT
	private var _nameID:UInt;				//USHORT
	private var _length:UInt;				//USHORT
	private var _offset:UInt;//USHORT
    public var _record:String;
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_platformID = data.dataGetUShort();
		data.offset += 2;
		_encodingID = data.dataGetUShort();
		data.offset += 2;
		_languageID = data.dataGetUShort();
		data.offset += 2;
		_nameID = data.dataGetUShort();
		data.offset += 2;
		_length = data.dataGetUShort();
		data.offset += 2;
		_offset = data.dataGetUShort();
		data.offset += 2;
	}
	//---------------------------------------------------------------------------------------------------
	public function readString(data: Data):Void
	{
		var sb:String = "";
		var i:UInt = 0, len:UInt, c:UInt;
		data.offset = data.offset + _offset;

		if (_platformID == 0)
		{
			 //Unicode (big-endian)
			i = 0;
			len = _length >> 1;
			while (i < len)
			{
				c = data.dataGetUShort();
				sb += String.fromCharCode(c);
				data.offset += 2;
				++i;
			}
		}
		else if (_platformID == 1)
		{
			// Macintosh encoding, ASCII
			i = 0;
			while (i < _length)			
			{
				c = data.readUInt8();
				sb += String.fromCharCode(c);
				data.offset++;
				++i;
			}
		}
		else if (_platformID == 2)
		{
			// ISO encoding, ASCII
			i = 0;
			while (i < _length)
			{
				c = data.readUInt8();
				sb += String.fromCharCode(c);
				data.offset++;
				++i;
			}
		}
		else if (_platformID == 3)
		{
			// Microsoft encoding, Unicode
			i = 0;
			len = _length >> 1;
			while (i < len)
			{
				c = data.dataGetUShort();
				sb += String.fromCharCode(c);
				data.offset += 2;
				++i;
			}
		}
		_record = sb;

		//intentionally left here for debugging
        //trace('name: $_nameID lang: $_languageID: string: $_record');
	}
    public function isFontName()
    {
        if (_languageID == 0 && _nameID == 4)
        {
            return true;
        }

        return false;
    }
}