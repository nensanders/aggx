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
class GammaThreshold implements IGammaFunction
{
	private var _threshold:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(t:Float = 0.5)
	{
		_threshold = t;
	}
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		return (x < _threshold) ? 0.0 : 1.0;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_threshold():Float { return _threshold; }
	private inline function set_threshold(value:Float):Float { return _threshold = value; }
	public var threshold(get, set):Float;
}