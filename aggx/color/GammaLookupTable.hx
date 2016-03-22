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
import haxe.ds.Vector;
//=======================================================================================================
class GammaLookupTable
{
	public static inline var GAMMA_SHIFT = 8;
	public static inline var GAMMA_SIZE = 1 << GAMMA_SHIFT;
	public static inline var GAMMA_MASK = GAMMA_SIZE-1;
	//---------------------------------------------------------------------------------------------------
	public static inline var HI_RES_SHIFT = 8;
	public static inline var HI_RES_SIZE = 1 << HI_RES_SHIFT;
	public static inline var HI_RES_MASK = HI_RES_SIZE-1;
	//---------------------------------------------------------------------------------------------------
    private var _gamma:Float;
    private var _dirGamma:Vector<Int>;
    private var _invGamma:Vector<Int>;
	//---------------------------------------------------------------------------------------------------
	public function new(?g:Float) 
	{
		_gamma = 1.0;
		_dirGamma = new Vector(GAMMA_SIZE);
		_invGamma = new Vector(HI_RES_SIZE);
		
		if (g != null)		
		{
			gamma = g;
		}
		else 
		{
			var i = 0;
			while (i < GAMMA_SIZE)		
			{
				_dirGamma[i] = i << (HI_RES_SHIFT - GAMMA_SHIFT);
				i++;
			}

			i = 0;
			while (i < HI_RES_SIZE)
			{
				_invGamma[i] = i >> (HI_RES_SHIFT - GAMMA_SHIFT);
				i++;
			}
		}	
	}
	//---------------------------------------------------------------------------------------------------
	public function getDirectGamma(v:Int):Int
	{
		return _dirGamma[v];
	}
	//---------------------------------------------------------------------------------------------------
	public function getInverseGamma(v:Int):Int
	{
		return _invGamma[v];
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_gamma():Float { return _gamma; }
	private inline function set_gamma(value:Float):Float
	{
		_gamma = value;

		var i = 0;
		while (i < GAMMA_SIZE)	
		{
			_dirGamma[i] = Std.int(Math.pow(i / GAMMA_MASK, _gamma) * HI_RES_MASK);
			i++;
		}

		var inv_g = 1.0 / value;
		i = 0;
		while (i < HI_RES_SIZE)
		{
			_invGamma[i] = Std.int(Math.pow(i / HI_RES_MASK, inv_g) * GAMMA_MASK);
			i++;
		}
		return _gamma;
	}
	public var gamma(get, set):Float;
}