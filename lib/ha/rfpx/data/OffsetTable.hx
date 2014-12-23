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
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class OffsetTable 
{
	private var _sfntVersion:Int; 		//FIXED
	private var _numTables:UInt; 		//USHORT
	private var _searchRange:UInt;		//USHORT
	private var _entrySelector:UInt;	//USHORT
	private var _rangeShift:UInt; 		//USHORT
	//---------------------------------------------------------------------------------------------------
	public function new(dataPtr:PointerRef) 
	{
		var ptr = dataPtr.value;
		
		_sfntVersion = ptr.getInt();
		ptr += 4;
		_numTables = ptr.getUShort();
		ptr += 2;
		_searchRange = ptr.getUShort();
		ptr += 2;
		_entrySelector = ptr.getUShort();
		ptr += 2;
		_rangeShift = ptr.getUShort();
		ptr += 2;
		
		dataPtr.value = ptr;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_numTables():UInt { return _numTables; }
	public var numTables(get, null):UInt;
}