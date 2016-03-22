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
import haxe.ds.Vector;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class TTCHeader 
{
	private static var TTCTag = 0x74746366;
	//---------------------------------------------------------------------------------------------------
	private var _version:Int;						//FIXED
	private var _numFonts:UInt;						//ULONG
	private var _offsetTable:Vector<UInt>;			//ULONG[numFonts] // TODO unused?
	private var _dsigTag:UInt;						//ULONG
	private var _dsigLength:UInt;					//ULONG
	private var _dsigOffset:UInt;					//ULONG
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_version = data.dataGetInt();
	}
	//---------------------------------------------------------------------------------------------------
	public static function isTTC(data: Data):Bool
	{
		var check = data.dataGetInt();
		return check == TTCTag;
	}
}