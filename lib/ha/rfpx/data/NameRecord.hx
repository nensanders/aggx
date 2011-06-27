package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class NameRecord 
{
	private var _platformID:UInt;			//USHORT
	private var _encodingID:UInt;			//USHORT
	private var _languageID:UInt;			//USHORT
	private var _nameID:UInt;				//USHORT
	private var _length:UInt;				//USHORT
	private var _offset:UInt;//USHORT
	private var _record:String;
	//---------------------------------------------------------------------------------------------------
	public function new(dataRef:PointerRef) 
	{
		var data = dataRef.value;
		
		_platformID = data.getUShort();
		data += 2;
		_encodingID = data.getUShort();
		data += 2;
		_languageID = data.getUShort();
		data += 2;
		_nameID = data.getUShort();
		data += 2;
		_length = data.getUShort();
		data += 2;
		_offset = data.getUShort();
		data += 2;
		
		dataRef.value = data;
	}
	//---------------------------------------------------------------------------------------------------
	public function readString(data:Pointer):Void
	{		
		var sb:String = "";
		var i:UInt = 0, len:UInt, c:UInt;
		data += _offset;
		if (_platformID == 0)
		{
			 //Unicode (big-endian)
			i = 0;
			len = _length >> 1;
			while (i < len)
			{
				c = data.getUShort();
				sb += String.fromCharCode(c);
				data += 2;
				++i;
			}
		}
		else if (_platformID == 1)
		{
			// Macintosh encoding, ASCII
			i = 0;
			while (i < _length)			
			{
				c = data.getByte();
				sb += String.fromCharCode(c);
				data++;
				++i;
			}
		}
		else if (_platformID == 2)
		{
			// ISO encoding, ASCII
			i = 0;
			while (i < _length)
			{
				c = data.getByte();
				sb += String.fromCharCode(c);
				data++;
				++i;
			}
		}
		else if (_platformID == 3)
		{
			// Microsoft encoding, Unicode
			i = 0;
			len = _length >> 1;
			while (i < len)
			{
				c = data.getUShort();
				sb += String.fromCharCode(c);
				data += 2;
				++i;
			}
		}
		_record = sb;
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_offset():UInt { return _offset; }
	public inline var offset(get_offset, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_length():UInt { return _length; }
	public inline var length(get_length, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_platformID():UInt { return _platformID; }
	public inline var platformID(get_platformID, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_languageID():UInt { return _languageID; }
	public inline var languageID(get_languageID, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_nameID():UInt { return _nameID; }
	public inline var nameID(get_nameID, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_encodingID():UInt { return _encodingID; }
	public inline var encodingID(get_encodingID, null):UInt;
}