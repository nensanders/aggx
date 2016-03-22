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
class TableRecord 
{
	private var _tag:UInt; 			//ULONG
	private var _checkSum:UInt; 	//ULONG
	private var _offset:UInt; 		//ULONG
	private var _length:UInt; 		//ULONG

	public function toString(): String
	{
		return 'TableRecord {tag: $_tag offset: $_offset length: $_length}';
	}

	public function new(data: Data)
	{
		_tag = data.dataGetUInt();
		data.offset += 4;
		_checkSum = data.dataGetUInt();
		data.offset += 4;
		_offset = data.dataGetUInt();
		data.offset += 4;
		_length = data.dataGetUInt();
		data.offset += 4;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_tag():UInt { return _tag; }
	public var tag(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_offset():UInt { return _offset; }
	public var offset(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_length():UInt { return _length; }
	public var length(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
}