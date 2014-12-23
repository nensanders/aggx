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
	public function new(dataRef:PointerRef) 
	{
		var ptr = dataRef.value;
		
		_familyType = ptr.getByte();
		ptr++;
		_serifStyle = ptr.getByte();
		ptr++;
		_weight = ptr.getByte();
		ptr++;
		_proportion = ptr.getByte();
		ptr++;
		_contrast = ptr.getByte();
		ptr++;
		_strokeVariation = ptr.getByte();
		ptr++;
		_armStyle = ptr.getByte();		
		ptr++;
		_letterform = ptr.getByte();
		ptr++;
		_midline = ptr.getByte();
		ptr++;
		_height = ptr.getByte();
		ptr++;
		
		dataRef.value = ptr;
	}
}