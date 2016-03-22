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
class OffsetTable 
{
	private var _sfntVersion:Int; 		//FIXED
	private var _numTables:UInt; 		//USHORT
	private var _searchRange:UInt;		//USHORT
	private var _entrySelector:UInt;	//USHORT
	private var _rangeShift:UInt; 		//USHORT
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_sfntVersion = data.dataGetInt();
		data.offset += 4;
		_numTables = data.dataGetUShort();
		data.offset += 2;
		_searchRange = data.dataGetUShort();
		data.offset += 2;
		_entrySelector = data.dataGetUShort();
		data.offset += 2;
		_rangeShift = data.dataGetUShort();
		data.offset += 2;
	}

	public function toString(): String
	{
		return 'OffsetTable{version: $_sfntVersion numTables: $_numTables}';
	}

	private inline function get_numTables():UInt { return _numTables; }
	public var numTables(get, null):UInt;
}