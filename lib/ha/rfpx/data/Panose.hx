package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class Panose 
{
	private var _familyType:Int;			//BYTE
	private var _serifStyle:Int;			//BYTE
	private var _weight:Int;				//BYTE
	private var _proportion:Int;			//BYTE
	private var _contrast:Int;				//BYTE
	private var _strokeVariation:Int;		//BYTE
	private var _armStyle:Int;				//BYTE
	private var _letterform:Int;			//BYTE
	private var _midline:Int;				//BYTE
	private var _height:Int;				//BYTE
	//---------------------------------------------------------------------------------------------------
	public function new(dataRef:PointerRef) 
	{
		var ptr = dataRef.value;
		
		_familyType = ptr.getByte();
		ptr++;
		_serifStyle = ptr.getByte();
		ptr++;
		_weight = ptr.getByte();
		ptr++;
		_proportion = ptr.getByte();
		ptr++;
		_contrast = ptr.getByte();
		ptr++;
		_strokeVariation = ptr.getByte();
		ptr++;
		_armStyle = ptr.getByte();		
		ptr++;
		_letterform = ptr.getByte();
		ptr++;
		_midline = ptr.getByte();
		ptr++;
		_height = ptr.getByte();
		ptr++;
		
		dataRef.value = ptr;
	}
}