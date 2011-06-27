package lib.ha.rfpx.data;
//=======================================================================================================
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class GlyphRecord 
{
	private var _numberOfContours:Int;				//SHORT
	private var _xMin:Int;							//SHORT
	private var _yMin:Int;							//SHORT
	private var _xMax:Int;							//SHORT
	private var _yMax:Int;							//SHORT
	private var _simpleDescr:GlyphDescrSimple;
	private var _compositeDescr:GlyphDescrComp;
	private var _isSimple:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new(data:Pointer) 
	{
		_numberOfContours = data.getShort();
		data += 2;
		_xMin = data.getShort();
		data += 2;
		_yMin = data.getShort();
		data += 2;
		_xMax = data.getShort();
		data += 2;
		_yMax = data.getShort();
		data += 2;
		
		if (_numberOfContours > 0)
		{
			_simpleDescr = new GlyphDescrSimple(data, _numberOfContours);
			_isSimple = true;
		}
		else if(_numberOfContours < 0)
		{
			_compositeDescr = new GlyphDescrComp(data);
			_isSimple = false;
		}
		else
		{
			throw "Empty glyph";
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_isSimple():Bool { return _isSimple; }
	public inline var isSimple(get_isSimple, null):Bool;
	//---------------------------------------------------------------------------------------------------
	private inline function get_simpleDescr():GlyphDescrSimple { return _simpleDescr; }
	public inline var simpleDescr(get_simpleDescr, null):GlyphDescrSimple;
	//---------------------------------------------------------------------------------------------------
	private inline function get_compositeDescr():GlyphDescrComp { return _compositeDescr; }
	public inline var compositeDescr(get_compositeDescr, null):GlyphDescrComp;
	//---------------------------------------------------------------------------------------------------
	private inline function get_xMin():Int { return _xMin; }
	public inline var xMin(get_xMin, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_yMin():Int { return _yMin; }
	public inline var yMin(get_yMin, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_xMax():Int { return _xMax; }
	public inline var xMax(get_xMax, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_yMax():Int { return _yMax; }
	public inline var yMax(get_yMax, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_numberOfContours():Int { return _numberOfContours; }
	public inline var numberOfContours(get_numberOfContours, null):Int;
	
}