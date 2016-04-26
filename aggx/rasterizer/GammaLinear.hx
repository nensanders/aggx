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
class GammaLinear implements IGammaFunction
{
	private var _start:Float;
	private var _end:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(s:Float = 0.0, e:Float = 1.0)
	{
		_start = s;
		_end = e;
	}
	//---------------------------------------------------------------------------------------------------
	public function set(s:Float, e:Float):Void
	{
		_start = s;
		_end = e;
	}
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float
	{
		if (x < _start) return 0.0;
		if (x > _end) return 1.0;
		return (x - _start) / (_end - _start);		
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_start():Float { return _start; }
	private inline function set_start(value:Float):Float { return _start = value; }
	public var start(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_end():Float { return _end; }
	private inline function set_end(value:Float):Float { return _end = value; }
	public var end(get, set):Float;
}