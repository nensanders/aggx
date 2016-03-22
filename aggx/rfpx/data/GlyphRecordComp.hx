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
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Ref;
import aggx.core.utils.Bits;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class GlyphRecordComp 
{
	public static var ARG_1_AND_2_ARE_WORDS = 0;
	public static var ARGS_ARE_XY_VALUES = 1;
	public static var ROUND_XY_TO_GRID = 2;
	public static var WE_HAVE_A_SCALE = 3;
	public static var MORE_COMPONENTS = 5;
	public static var WE_HAVE_AN_X_AND_Y_SCALE = 6;
	public static var WE_HAVE_A_TWO_BY_TWO = 7;
	public static var WE_HAVE_INSTRUCTIONS = 8;
	public static var USE_MY_METRICS = 9;
	//---------------------------------------------------------------------------------------------------
	private var _flags:UInt;				//USHORT
	private var _glyphIndex:UInt;			//USHORT
	private var _argument1:Int;				//SHORT/FWORD
	private var _argument2:Int;				//SHORT/FWORD
	private var _xscale:Float;
	private var _yscale:Float;
	private var _scale01:Float;
	private var _scale10:Float;
	private var _xtranslate:Int;
	private var _ytranslate:Int;
	private var _point1:Int;
	private var _point2:Int;	
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data)
	{
		_xscale = 1.0;
		_yscale = 1.0;
		_scale01 = 0.0;
		_scale10 = 0.0;
		_xtranslate = 0;
		_ytranslate = 0;
		_point1 = 0;
		_point2 = 0;

		
		_flags = data.dataGetUShort();
		data.offset += 2;
		_glyphIndex = data.dataGetUShort();
		data.offset += 2;
		
		if (Bits.hasBitAt(_flags, ARG_1_AND_2_ARE_WORDS))
		{
			_argument1 = data.dataGetShort();
			data.offset += 2;
			_argument2 = data.dataGetShort();
			data.offset += 2;
		}
		else
		{
			_argument1 = data.readInt8();
			data.offset++;
			_argument2 = data.readUInt8();
			data.offset++;
		}
		
		if (Bits.hasBitAt(_flags, ARGS_ARE_XY_VALUES))
		{
			_xtranslate = _argument1;
			_ytranslate = _argument2;
		}
		else
		{
			_point1 = _argument1;
			_point2 = _argument2;
		}

		var i:Int;
		
		if (Bits.hasBitAt(_flags, WE_HAVE_A_SCALE))
		{
			_xscale = _yscale = readF2Dot14(data);
		}
		else if (Bits.hasBitAt(_flags, WE_HAVE_AN_X_AND_Y_SCALE))
		{
			_xscale = readF2Dot14(data);
			_yscale = readF2Dot14(data);
		}
		else if (Bits.hasBitAt(_flags, WE_HAVE_A_TWO_BY_TWO))
		{
			_xscale = readF2Dot14(data);
			_scale01 = readF2Dot14(data);
			_scale10 = readF2Dot14(data);
			_yscale = readF2Dot14(data);
		}
	}
	//---------------------------------------------------------------------------------------------------
    private static function readF2Dot14(data: Data):Float
	{
        var major = data.readUInt8();
		data.offset++;
        var minor = data.readUInt8();
		data.offset++;
        var fraction = minor + ((major & 0x3f) << 8);
        var mantissa = major >> 6;
        if (mantissa >= 2) mantissa -= 4;

        return mantissa + fraction / 16384.0;
    }	
	//---------------------------------------------------------------------------------------------------
	private inline function get_flags():UInt { return _flags; }
	public var flags(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_glyphIndex():UInt { return _glyphIndex; }
	public var glyphIndex(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_tx():Int { return _xtranslate; }
	public var tx(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_ty():Int { return _ytranslate; }
	public var ty(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_transformer():AffineTransformer 
	{
		var m = AffineTransformer.scaler(_xscale, _yscale);
		m.multiply(AffineTransformer.translator(_xtranslate, _ytranslate));
		return m;
	}
	public var transformer(get, null):AffineTransformer;
}