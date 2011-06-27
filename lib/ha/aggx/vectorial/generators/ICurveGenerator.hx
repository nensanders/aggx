package lib.ha.aggx.vectorial.generators;
//=======================================================================================================
import lib.ha.core.memory.Ref;
//=======================================================================================================
interface ICurveGenerator 
{
	public function rewind(pathId:UInt):Void;
	public function getVertex(x:FloatRef, y:FloatRef):UInt;	
	public function removeAll():Void;
	public function addVertex(x:Float, y:Float, cmd:UInt):Void;
}