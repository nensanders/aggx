package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapFormat6 
{
	private var _format:UInt;				//USHORT
	private var _length:UInt;				//USHORT
	private var _language:UInt;				//USHORT
	private var _firstCode:UInt;			//USHORT
	private var _entryCount:UInt;			//USHORT
	private var _glyphIdArray:Vector<UInt>;	//USHORT[entryCount]
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer) 
	{
		_format = 0;
		
		_length = data.getUShort();
		data += 2;
		_language = data.getUShort();
		data += 2;
		_firstCode = data.getUShort();
		data += 2;
		_entryCount =data.getUShort();
		data += 2;
		
		_glyphIdArray = new Vector(_entryCount);
		
		var i:UInt = 0;
		while (i < _entryCount)
		{
			_glyphIdArray[i] = data.getUShort();
			data += 2;
			++i;
		}
	}	
}