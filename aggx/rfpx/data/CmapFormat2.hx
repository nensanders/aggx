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
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapFormat2 
{
	private var _format:UInt;					//USHORT
	private var _length:UInt;					//USHORT
	private var _language:UInt;					//USHORT
	private var _subHeaderKeys:Vector<UInt>;	//USHORT[256]
	private var _subHeaders:Vector<Int>;		//INT[]   // TODO Unused?
	private var _glyphIndexArray:Vector<UInt>;	//USHORT[] // TODO Unused?
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_format = 2;

        _subHeaderKeys = new Vector(256);

		_length = data.dataGetUShort();
		data.offset += 2;
		_language = data.dataGetUShort();
		data.offset += 2;
		var i:UInt = 0;
		while (i < 256) 
		{
			_subHeaderKeys[i] = data.dataGetUShort();
			data.offset += 2;
			++i;
		}
	}
}