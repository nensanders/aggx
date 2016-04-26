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
import types.Data;
import aggx.core.memory.Ref;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class EncodingRecord 
{
	private var _platformID:UInt;		//USHORT	3 = Microsoft, 1 = Apple, 0 = Unicode
	private var _encodingID:UInt;		//USHORT
	private var _offset:UInt;			//ULONG
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_platformID = data.dataGetUShort();
		data.offset += 2;

		_encodingID = data.dataGetUShort();
		data.offset += 2;

		_offset = data.dataGetUInt();
		data.offset += 4;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_offset():UInt { return _offset; }
	public var offset(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_platformID():UInt { return _platformID; }
	public var platformID(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_encodingID():UInt { return _encodingID; }
	public var encodingID(get, null):UInt;
}