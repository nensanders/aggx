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
class GammaMultiply implements IGammaFunction
{
	private var _mul:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(m:Float = 1.0)
	{
		_mul = m;
	}	
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		var y = x * _mul;
		if (y > 1.0) y = 1.0;
		return y;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_value():Float { return _mul; }
	private inline function set_value(val:Float):Float { return _mul = val; }
	public var value(get, set):Float;
}