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
import haxe.ds.Vector;
import aggx.core.memory.Pointer;
import aggx.core.math.Calc;
import aggx.core.memory.MemoryReader;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class PostTable 
{
	private var _tableRecord:TableRecord;
	private var _version:Int;						//FIXED
	private var _italicAngle:Int;					//FIXED
	private var _underlinePosition:Int;				//FWORD -> SHORT (in FUNITs)
	private var _underlineThickness:Int;			//FWORD -> SHORT (in FUNITs)
	private var _isFixedPitch:UInt;					//ULONG
	private var _minMemType42:UInt;					//ULONG
	private var _maxMemType42:UInt;					//ULONG
	private var _minMemType1:UInt;					//ULONG
	private var _maxMemType1:UInt;					//ULONG
	private var _numGlyphs:UInt;					//USHORT
	private var _glyphNameIndex:Vector<UInt>;		//USHORT[numGlyphs]
	private var _psGlyphName:Vector<String>;		//CHAR[]
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, ptr: Data)
	{
		_tableRecord = record;
		
		//var ptr = data.ptr;
		
		_version = ptr.dataGetInt();
		ptr.offset += 4;
		_italicAngle = ptr.dataGetInt();
		ptr.offset += 4;
		_underlinePosition = ptr.dataGetShort();
		ptr.offset += 2;
		_underlineThickness = ptr.dataGetShort();
		ptr.offset += 2;
		_isFixedPitch = ptr.dataGetUInt();
		ptr.offset += 4;
		_minMemType42 = ptr.dataGetUInt();
		ptr.offset += 4;
		_maxMemType42 = ptr.dataGetUInt();
		ptr.offset += 4;
		_minMemType1 = ptr.dataGetUInt();
		ptr.offset += 4;
		_maxMemType1 = ptr.dataGetUInt();
		ptr.offset += 4;
		
		if (_version == 0x00020000)
		{
			_numGlyphs = ptr.dataGetUShort();
			ptr.offset += 2;
			_glyphNameIndex = new Vector(_numGlyphs);
			var i:UInt = 0;
			while (i < _numGlyphs)
			{
				_glyphNameIndex[i] = ptr.dataGetUShort();
				ptr.offset += 2;
				++i;
			}			
			//var h = highestGlyphNameIndex();
			//if (h > 257)
			//{
				//h -= 257;
				//_psGlyphName = new Vector(h);
				//i = 0;
				//while (i < _numGlyphs)
				//{
					//var len = ptr.getByte();
					//ptr++;
					//_psGlyphName[i] = MemoryReader.getString(ptr, len);
					//ptr += len;
					//++i;
				//}
			//}
		}
		else if (_version == 0x00025000) { }
		else if (_version == 0x00030000) { }
	}
	//---------------------------------------------------------------------------------------------------
	private function highestGlyphNameIndex():UInt
	{
		var high:UInt = 0;
		var i:UInt = 0;
		while (i < _numGlyphs)		
		{
			high = Calc.umax(high, _glyphNameIndex[i]);
			++i;
		}
		return high;
	}	
}