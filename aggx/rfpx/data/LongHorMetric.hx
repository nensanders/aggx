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

package aggx.rfpx.data;
//=======================================================================================================
class LongHorMetric 
{
	private var _advanceWidth:UInt;			//USHORT
	private var _lsb:Int;					//SHORT
	//---------------------------------------------------------------------------------------------------
	public function new(advWidth:UInt, leftSb:Int) 
	{
		_advanceWidth = advWidth;
		_lsb = leftSb;
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_advanceWidth():UInt { return _advanceWidth; }
	public var advanceWidth(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lsb():Int { return _lsb; }
	public var lsb(get, null):Int;
}