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

package lib.ha.rfpx.data;
//=======================================================================================================
import types.Data;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class NameRecord 
{
	private var _platformID:UInt;			//USHORT
	private var _encodingID:UInt;			//USHORT
	private var _languageID:UInt;			//USHORT
	private var _nameID:UInt;				//USHORT
	private var _length:UInt;				//USHORT
	private var _offset:UInt;//USHORT
	private var _record:String;
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
		data.offset += _offset;
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
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_offset():UInt { return _offset; }
	public var offset(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_length():UInt { return _length; }
	public var length(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_platformID():UInt { return _platformID; }
	public var platformID(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_languageID():UInt { return _languageID; }
	public var languageID(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_nameID():UInt { return _nameID; }
	public var nameID(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_encodingID():UInt { return _encodingID; }
	public var encodingID(get, null):UInt;
}