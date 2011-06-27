package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
import lib.ha.core.memory.Ref;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class Os2Table 
{
	private var _tableRecord:TableRecord;
	private var _version:UInt;					//USHORT
	private var _avgCharWidth:Int;				//SHORT
	private var _weightClass:UInt;			//USHORT
	private var _widthClass:UInt;				//USHORT
	private var _type:UInt;					//USHORT
	private var _subscriptXSize:Int;			//SHORT
	private var _subscriptYSize:Int;			//SHORT
	private var _subscriptXOffset:Int;			//SHORT
	private var _subscriptYOffset:Int;			//SHORT
	private var _superscriptXSize:Int;			//SHORT
	private var _superscriptYSize:Int;			//SHORT
	private var _superscriptXOffset:Int;		//SHORT
	private var _superscriptYOffset:Int;		//SHORT
	private var _strikeoutSize:Int;			//SHORT
	private var _strikeoutPosition:Int;		//SHORT
	private var _familyClass:Int;				//SHORT
	private var _panose:Panose;
	private var _unicodeRange1:UInt;			//ULONG
	private var _unicodeRange2:UInt;			//ULONG
	private var _unicodeRange3:UInt;			//ULONG
	private var _unicodeRange4:UInt;			//ULONG
	private var _vendorID:Int;					//INT
	private var _selection:UInt;				//USHORT
	private var _rirstCharIndex:UInt;			//USHORT
	private var _lastCharIndex:UInt;			//USHORT
	private var _typoAscender:Int;				//SHORT
	private var _typoDescender:Int;				//SHORT
	private var _typoLineGap:Int;				//SHORT
	private var _winAscent:UInt;				//USHORT
	private var _winDescent:UInt;				//USHORT
	private var _codePageRange1:UInt;			//ULONG
	private var _codePageRange2:UInt;			//ULONG
	private var _height:Int;					//SHORT
	private var _capHeight:Int;					//SHORT
	private var _defaultChar:Int;				//USHORT
	private var _breakChar:Int;					//USHORT
	private var _maxContext:Int;				//USHORT
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, ptr:Pointer)
	{
		_tableRecord = record;

		_version = ptr.getUShort();
		ptr += 2;
		_avgCharWidth = ptr.getShort();
		ptr += 2;
		_weightClass = ptr.getUShort();
		ptr += 2;
		_widthClass = ptr.getUShort();
		ptr += 2;
		_type = ptr.getUShort();
		ptr += 2;
		_subscriptXSize = ptr.getShort();
		ptr += 2;
		_subscriptYSize = ptr.getShort();
		ptr += 2;
		_subscriptXOffset = ptr.getShort();
		ptr += 2;
		_subscriptYOffset = ptr.getShort();
		ptr += 2;
		_superscriptXSize = ptr.getShort();
		ptr += 2;
		_superscriptYSize = ptr.getShort();
		ptr += 2;
		_superscriptXOffset = ptr.getShort();
		ptr += 2;
		_superscriptYOffset = ptr.getShort();
		ptr += 2;
		_strikeoutSize = ptr.getShort();
		ptr += 2;
		_strikeoutPosition = ptr.getShort();
		ptr += 2;
		_familyClass = ptr.getShort();
		ptr += 2;
		
		var refPtr = Ref.pointer1.set(ptr);
		_panose = new Panose(refPtr);
		ptr = refPtr.value;
		
		_unicodeRange1 = ptr.getUInt();
		ptr += 4;
		_unicodeRange2 = ptr.getUInt();
		ptr += 4;
		_unicodeRange3 = ptr.getUInt();
		ptr += 4;
		_unicodeRange4 = ptr.getUInt();
		ptr += 4;
		_vendorID = ptr.getInt();
		ptr += 4;
		_selection = ptr.getUShort();
		ptr += 2;
		_rirstCharIndex = ptr.getUInt();
		ptr += 2;
		_lastCharIndex  = ptr.getUInt();
		ptr += 2;
		_typoAscender = ptr.getShort();
		ptr += 2;
		_typoDescender = ptr.getShort();
		ptr += 2;
		_typoLineGap = ptr.getShort();
		ptr += 2;
		_winAscent = ptr.getUShort();
		ptr += 2;
		_winDescent = ptr.getUShort();
		ptr += 2;
		_codePageRange1 = ptr.getUInt();
		ptr += 4;
		_codePageRange2 = ptr.getUInt();
		ptr += 4;		
	}
}