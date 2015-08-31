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
class TableRecord 
{
	private var _tag:UInt; 			//ULONG
	private var _checkSum:UInt; 	//ULONG
	private var _offset:UInt; 		//ULONG
	private var _length:UInt; 		//ULONG
	//---------------------------------------------------------------------------------------------------
	public function new(dataPtr:PointerRef) 
	{
		var ptr = dataPtr.value;
		
		_tag = ptr.getUInt();
		ptr += 4;
		_checkSum = ptr.getUInt();
		ptr += 4;
		_offset = ptr.getUInt();
		ptr += 4;
		_length = ptr.getUInt();
		ptr += 4;

		dataPtr.value = ptr;
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