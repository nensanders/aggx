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
import haxe.ds.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapFormat6 
{
	private var _format:UInt;				//USHORT
	private var _length:UInt;				//USHORT
	private var _language:UInt;				//USHORT
	private var _firstCode:UInt;			//USHORT
	private var _entryCount:UInt;			//USHORT
	private var _glyphIdArray:Vector<UInt>;	//USHORT[entryCount]
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer) 
	{
		_format = 0;
		
		_length = data.getUShort();
		data += 2;
		_language = data.getUShort();
		data += 2;
		_firstCode = data.getUShort();
		data += 2;
		_entryCount =data.getUShort();
		data += 2;
		
		_glyphIdArray = new Vector(_entryCount);
		
		var i:UInt = 0;
		while (i < _entryCount)
		{
			_glyphIdArray[i] = data.getUShort();
			data += 2;
			++i;
		}
	}	
}