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

package lib.ha.core.memory;
//=======================================================================================================
import flash.system.ApplicationDomain;
import lib.ha.core.memory.MemoryWriter;
using lib.ha.core.memory.MemoryWriter;
//=======================================================================================================
class MemoryUtils 
{
	public static function copy(dst:Pointer, src:Pointer, size:UInt):Void
	{
		var pos = ApplicationDomain.currentDomain.domainMemory.position;
		ApplicationDomain.currentDomain.domainMemory.position = src;
		ApplicationDomain.currentDomain.domainMemory.readBytes(ApplicationDomain.currentDomain.domainMemory, dst, size);
		ApplicationDomain.currentDomain.domainMemory.position = pos;
	}
	//---------------------------------------------------------------------------------------------------
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
}