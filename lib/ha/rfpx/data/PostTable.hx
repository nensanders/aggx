package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.math.Calc;
import lib.ha.core.memory.MemoryReader;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
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
	public function new(record:TableRecord, ptr:Pointer) 
	{
		_tableRecord = record;
		
		//var ptr = data.ptr;
		
		_version = ptr.getInt();
		ptr += 4;
		_italicAngle = ptr.getInt();
		ptr += 4;
		_underlinePosition = ptr.getShort();
		ptr += 2;
		_underlineThickness =ptr.getShort();
		ptr += 2;
		_isFixedPitch = ptr.getUInt();
		ptr += 4;
		_minMemType42 = ptr.getUInt();
		ptr += 4;
		_maxMemType42 = ptr.getUInt();
		ptr += 4;
		_minMemType1 = ptr.getUInt();
		ptr += 4;
		_maxMemType1 = ptr.getUInt();
		ptr += 4;
		
		if (_version == 0x00020000)
		{
			_numGlyphs = ptr.getUShort();
			ptr += 2;
			_glyphNameIndex = new Vector(_numGlyphs);
			var i:UInt = 0;
			while (i < _numGlyphs)
			{
				_glyphNameIndex[i] = ptr.getUShort();
				ptr += 2;
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