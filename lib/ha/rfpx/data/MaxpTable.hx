package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class MaxpTable 
{
	private var _tableRecord:TableRecord;
	private var _version:Int;							//FIXED
	private var _numGlyphs:UInt;						//USHORT
	private var _maxPoints:UInt;						//USHORT
	private var _maxContours:UInt;						//USHORT
	private var _maxCompositePoints:UInt;				//USHORT
	private var _maxCompositeContours:UInt;				//USHORT
	private var _maxZones:UInt;							//USHORT
	private var _maxTwilightPoints:UInt;				//USHORT
	private var _maxStorage:UInt;						//USHORT
	private var _maxFunctionDefs:UInt;					//USHORT
	private var _maxInstructionDefs:UInt;				//USHORT
	private var _maxStackElements:UInt;					//USHORT
	private var _maxSizeOfInstructions:UInt;			//USHORT
	private var _maxComponentElements:UInt;				//USHORT
	private var _maxComponentDepth:UInt;				//USHORT
	//---------------------------------------------------------------------------------------------------	
	public function new(record:TableRecord, data:Pointer) 
	{
		_tableRecord = record;
		
		_version = data.getInt();
		data += 4;
		
		_numGlyphs = data.getUShort();
		data += 2;
		
		if (_version == 0x00010000) 
		{
			_maxPoints = data.getUShort();
			data += 2;
			_maxContours = data.getUShort();
			data += 2;
			_maxCompositePoints = data.getUShort();
			data += 2;
			_maxCompositeContours = data.getUShort();
			data += 2;
			_maxZones = data.getUShort();
			data += 2;
			_maxTwilightPoints = data.getUShort();
			data += 2;
			_maxStorage = data.getUShort();
			data += 2;
			_maxFunctionDefs = data.getUShort();
			data += 2;
			_maxInstructionDefs = data.getUShort();
			data += 2;
			_maxStackElements = data.getUShort();
			data += 2;
			_maxSizeOfInstructions = data.getUShort();
			data += 2;
			_maxComponentElements = data.getUShort();
			data += 2;
			_maxComponentDepth = data.getUShort();
		}
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_numGlyphs():UInt { return _numGlyphs; }
	public inline var numGlyphs(get_numGlyphs, null):UInt;
}