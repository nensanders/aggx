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
class Panose 
{
	private var _familyType:Int;			//BYTE
	private var _serifStyle:Int;			//BYTE
	private var _weight:Int;				//BYTE
	private var _proportion:Int;			//BYTE
	private var _contrast:Int;				//BYTE
	private var _strokeVariation:Int;		//BYTE
	private var _armStyle:Int;				//BYTE
	private var _letterform:Int;			//BYTE
	private var _midline:Int;				//BYTE
	private var _height:Int;				//BYTE
	//---------------------------------------------------------------------------------------------------
	public function new(ptr: Data)
	{
		_familyType = ptr.readUInt8();
		ptr.offset++;
		_serifStyle = ptr.readUInt8();
		ptr.offset++;
		_weight = ptr.readUInt8();
		ptr.offset++;
		_proportion = ptr.readUInt8();
		ptr.offset++;
		_contrast = ptr.readUInt8();
		ptr.offset++;
		_strokeVariation = ptr.readUInt8();
		ptr.offset++;
		_armStyle = ptr.readUInt8();
		ptr.offset++;
		_letterform = ptr.readUInt8();
		ptr.offset++;
		_midline = ptr.readUInt8();
		ptr.offset++;
		_height = ptr.readUInt8();
		ptr.offset++;
	}
}