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

package aggx;
//=======================================================================================================
import aggx.core.memory.Pointer;
//=======================================================================================================
class RowInfo
{
	public var x1:Int;
	public var x2:Int;
	public var ptr:Pointer;
	//---------------------------------------------------------------------------------------------------
	public function new(ax1:Int, ax2:Int, aptr:Pointer) 
	{
		x1 = ax1;
		x2 = ax2;
		ptr = aptr;
	}
	//---------------------------------------------------------------------------------------------------
}