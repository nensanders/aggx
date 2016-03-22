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
import types.Data;
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
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
	public function new(record:TableRecord, data: Data)
	{
		_tableRecord = record;
		
		_version = data.dataGetInt();
		data.offset += 4;
		
		_numGlyphs = data.dataGetUShort();
		data.offset += 2;
		
		if (_version == 0x00010000) 
		{
			_maxPoints = data.dataGetUShort();
			data.offset += 2;
			_maxContours = data.dataGetUShort();
			data.offset += 2;
			_maxCompositePoints = data.dataGetUShort();
			data.offset += 2;
			_maxCompositeContours = data.dataGetUShort();
			data.offset += 2;
			_maxZones = data.dataGetUShort();
			data.offset += 2;
			_maxTwilightPoints = data.dataGetUShort();
			data.offset += 2;
			_maxStorage = data.dataGetUShort();
			data.offset += 2;
			_maxFunctionDefs = data.dataGetUShort();
			data.offset += 2;
			_maxInstructionDefs = data.dataGetUShort();
			data.offset += 2;
			_maxStackElements = data.dataGetUShort();
			data.offset += 2;
			_maxSizeOfInstructions = data.dataGetUShort();
			data.offset += 2;
			_maxComponentElements = data.dataGetUShort();
			data.offset += 2;
			_maxComponentDepth = data.dataGetUShort();
		}
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_numGlyphs():UInt { return _numGlyphs; }
	public var numGlyphs(get, null):UInt;
}