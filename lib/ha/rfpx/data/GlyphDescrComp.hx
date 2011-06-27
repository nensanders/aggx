package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.utils.Bits;
//=======================================================================================================
class GlyphDescrComp 
{
	private var _components:Vector<GlyphRecordComp>;
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer) 
	{
		_components = new Vector();
		var dataRef = Ref.pointer1.set(data);
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
	public inline var componentsCount(get_componentsCount, null):UInt;
}