package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.memory.Ref;
import lib.ha.core.utils.Bits;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
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
	public function new(dataRef:PointerRef) 
	{
		_xscale = 1.0;
		_yscale = 1.0;
		_scale01 = 0.0;
		_scale10 = 0.0;
		_xtranslate = 0;
		_ytranslate = 0;
		_point1 = 0;
		_point2 = 0;
		
		var data = dataRef.value;
		
		_flags = data.getUShort();
		data += 2;
		_glyphIndex = data.getUShort();
		data += 2;
		
		if (Bits.hasBitAt(_flags, ARG_1_AND_2_ARE_WORDS))
		{
			_argument1 = data.getShort();
			data += 2;
			_argument2 = data.getShort();
			data += 2;
		}
		else
		{
			_argument1 = data.getByte();
			data++;
			_argument2 = data.getByte();
			data++;
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
		
		dataRef.value = data;
		var i:Int;
		
		if (Bits.hasBitAt(_flags, WE_HAVE_A_SCALE))
		{
			_xscale = _yscale = readF2Dot14(dataRef);
		}
		else if (Bits.hasBitAt(_flags, WE_HAVE_AN_X_AND_Y_SCALE))
		{
			_xscale = readF2Dot14(dataRef);
			_yscale = readF2Dot14(dataRef);
		}
		else if (Bits.hasBitAt(_flags, WE_HAVE_A_TWO_BY_TWO))
		{
			_xscale = readF2Dot14(dataRef);
			_scale01 = readF2Dot14(dataRef);
			_scale10 = readF2Dot14(dataRef);
			_yscale = readF2Dot14(dataRef);
		}
	}
	//---------------------------------------------------------------------------------------------------
    private static function readF2Dot14(dataRef:PointerRef):Float
	{
		var data = dataRef.value;
		
        var major = data.getByte();
		data++;
        var minor = data.getByte();
		data++;
        var fraction = minor + ((major & 0x3f) << 8);
        var mantissa = major >> 6;
        if (mantissa >= 2) mantissa -= 4;
		
		dataRef.value = data;
        return mantissa + fraction / 16384.0;
    }	
	//---------------------------------------------------------------------------------------------------
	private inline function get_flags():UInt { return _flags; }
	public inline var flags(get_flags, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_glyphIndex():UInt { return _glyphIndex; }
	public inline var glyphIndex(get_glyphIndex, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_xtranslate():Int { return _xtranslate; }
	public inline var tx(get_xtranslate, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_ytranslate():Int { return _ytranslate; }
	public inline var ty(get_ytranslate, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_transformer():AffineTransformer 
	{
		var m = AffineTransformer.scaler(_xscale, _yscale);
		m.multiply(AffineTransformer.translator(_xtranslate, _ytranslate));
		return m;
	}
	public inline var transformer(get_transformer, null):AffineTransformer;
}