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
class GammaPower implements IGammaFunction
{
	private var _gamma:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(g:Float = 1.0)
	{
		_gamma = g;
	}
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		return Math.pow(x, _gamma);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_gamma():Float { return _gamma; }
	private inline function set_gamma(value:Float):Float { return _gamma = value; }
	public var gamma(get, set):Float;
}