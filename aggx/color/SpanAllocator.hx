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

package aggx.color;
//=======================================================================================================
import aggx.core.utils.ArrayUtil;
using aggx.core.utils.ArrayUtil;
//=======================================================================================================
class SpanAllocator implements ISpanAllocator
{
	private var _span:Array<RgbaColor>;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_span = new Array();
	}
	//---------------------------------------------------------------------------------------------------
	public function allocate(spanLen:UInt):RgbaColorStorage
	{
		if (spanLen > cast _span.length)
		{
			_span = ArrayUtil.alloc(((spanLen + 255) >> 8) << 8);
		}
		return { data: _span, offset:0 };
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_span():RgbaColorStorage { return { data: _span, offset:0 }; }
	public var span(get, null):RgbaColorStorage;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxSpanLength():UInt { return _span.length; }
	public var maxSpanLength(get, null):UInt;
}