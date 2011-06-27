package lib.ha.aggx.vectorial;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.IMarkerGenerator;
import lib.ha.core.memory.Ref;
//=======================================================================================================
class NullMarkers implements IMarkerGenerator
{
	public function new() { }
	//---------------------------------------------------------------------------------------------------
	public function removeAll() {}
	//---------------------------------------------------------------------------------------------------
	public function addVertex(x:Float, y:Float, cmd:Int) {}
	//---------------------------------------------------------------------------------------------------
	public function prepareSrc() { }
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void;
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt { return PathCommands.STOP; }
}