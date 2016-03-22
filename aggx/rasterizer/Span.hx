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

package aggx.rasterizer;
//=======================================================================================================
import types.Data;
import aggx.core.memory.Pointer;
//=======================================================================================================
class Span 
{
	public var x: Int = 0;
	public var len: Int = 0;
	private var data: Data;
	private var dataOffset: Int;
	//public var covers:Pointer = -1;
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data, offset: Int)
    {
        this.data = data;
        dataOffset = offset;
    }

    public function toString(): String
    {
        return '{x: $x, len: $len coversOffset: $dataOffset}';
    }

    public function getCovers(): Data
    {
        data.offset = dataOffset;
        return data;
    }
}