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

package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.utils.Bits;
//=======================================================================================================
class GlyphDescrComp 
{
	private var _components:Array<GlyphRecordComp>;
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer) 
	{
		_components = new Array();
		var dataRef = Ref.getPointer().set(data);
		var comp:GlyphRecordComp;
		do
		{
			_components[_components.length] = comp = new GlyphRecordComp(dataRef);
		}
		while (Bits.hasBitAt(comp.flags, GlyphRecordComp.MORE_COMPONENTS));
	}
	//---------------------------------------------------------------------------------------------------
	public function getComponent(idx:UInt):GlyphRecordComp
	{
		return _components[idx];
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_componentsCount():UInt { return _components.length; }
	public var componentsCount(get, null):UInt;
}