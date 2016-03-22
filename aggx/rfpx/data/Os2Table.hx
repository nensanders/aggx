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
import aggx.core.memory.Ref;
using aggx.core.memory.MemoryReaderEx;
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
	public function new(record:TableRecord, ptr: Data)
	{
		_tableRecord = record;

		_version = ptr.dataGetUShort();
		ptr.offset += 2;
		_avgCharWidth = ptr.dataGetShort();
		ptr.offset += 2;
		_weightClass = ptr.dataGetUShort();
		ptr.offset += 2;
		_widthClass = ptr.dataGetUShort();
		ptr.offset += 2;
		_type = ptr.dataGetUShort();
		ptr.offset += 2;
		_subscriptXSize = ptr.dataGetShort();
		ptr.offset += 2;
		_subscriptYSize = ptr.dataGetShort();
		ptr.offset += 2;
		_subscriptXOffset = ptr.dataGetShort();
		ptr.offset += 2;
		_subscriptYOffset = ptr.dataGetShort();
		ptr.offset += 2;
		_superscriptXSize = ptr.dataGetShort();
		ptr.offset += 2;
		_superscriptYSize = ptr.dataGetShort();
		ptr.offset += 2;
		_superscriptXOffset = ptr.dataGetShort();
		ptr.offset += 2;
		_superscriptYOffset = ptr.dataGetShort();
		ptr.offset += 2;
		_strikeoutSize = ptr.dataGetShort();
		ptr.offset += 2;
		_strikeoutPosition = ptr.dataGetShort();
		ptr.offset += 2;
		_familyClass = ptr.dataGetShort();
		ptr.offset += 2;

		_panose = new Panose(ptr);
		
		_unicodeRange1 = ptr.dataGetUInt();
		ptr.offset += 4;
		_unicodeRange2 = ptr.dataGetUInt();
		ptr.offset += 4;
		_unicodeRange3 = ptr.dataGetUInt();
		ptr.offset += 4;
		_unicodeRange4 = ptr.dataGetUInt();
		ptr.offset += 4;
		_vendorID = ptr.dataGetInt();
		ptr.offset += 4;
		_selection = ptr.dataGetUShort();
		ptr.offset += 2;
		_rirstCharIndex = ptr.dataGetUInt();
		ptr.offset += 2;
		_lastCharIndex  = ptr.dataGetUInt();
		ptr.offset += 2;
		_typoAscender = ptr.dataGetShort();
		ptr.offset += 2;
		_typoDescender = ptr.dataGetShort();
		ptr.offset += 2;
		_typoLineGap = ptr.dataGetShort();
		ptr.offset += 2;
		_winAscent = ptr.dataGetUShort();
		ptr.offset += 2;
		_winDescent = ptr.dataGetUShort();
		ptr.offset += 2;
		_codePageRange1 = ptr.dataGetUInt();
		ptr.offset += 4;
		_codePageRange2 = ptr.dataGetUInt();
		ptr.offset += 4;
	}
}