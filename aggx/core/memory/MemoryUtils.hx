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

package aggx.core.memory;
//=======================================================================================================
import types.Data;
import aggx.core.memory.MemoryWriter;
using aggx.core.memory.MemoryWriter;
//=======================================================================================================
class MemoryUtils 
{

	public static function set(dst:Pointer, val:Byte, size:UInt):Void
	{
		var i:UInt = 0;
		while (i < size)		
		{
			dst.setByte(val);
			dst++;
			++i;
		}
	}

	public static function dataSet(data: Data, dst: Int, val: Byte, size: UInt)
	{
		var tmpOffset = data.offset;
		data.offset = dst;
		for (i in 0 ... size)
		{
			data.writeUInt8(val);
			data.offset++;
		}

		data.offset = tmpOffset;
	}
}