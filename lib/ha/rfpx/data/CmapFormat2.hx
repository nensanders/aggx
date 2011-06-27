package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapFormat2 
{
	private var _format:UInt;					//USHORT
	private var _length:UInt;					//USHORT
	private var _language:UInt;					//USHORT
	private var _subHeaderKeys:Vector<UInt>;	//USHORT[256]
	private var _subHeaders:Vector<Int>;		//INT[]
	private var _glyphIndexArray:Vector<UInt>;	//USHORT[]
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer) 
	{	
		_format = 2;
		
		_length = data.getUShort();
		data += 2;
		_language = data.getUShort();
		data += 2;
		
		var i:UInt = 0;
		while (i < 256) 
		{
			_subHeaderKeys[i] = data.getUShort();
			data += 2;
			++i;
		}
	}
}