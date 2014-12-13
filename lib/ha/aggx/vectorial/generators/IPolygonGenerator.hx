package lib.ha.aggx.vectorial.generators;
//=======================================================================================================
import lib.ha.core.memory.Ref;
//=======================================================================================================
interface IPolygonGenerator 
{
	public var autoClose(get, null):Bool;
	public var autoUnclose(get, null):Bool;
	public var approximationScale(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	public function reset():Void;
	public function getVertex(x:FloatRef, y:FloatRef):UInt;	
	public function moveTo(x:Float, y:Float):Void;
	public function lineTo(x:Float, y:Float):Void;
}