package lib.ha.aggx.vectorial;
//=======================================================================================================
import lib.ha.core.memory.Ref;
//=======================================================================================================
interface IMarkerShape
{
	public function rewind(pathId:UInt):Void;
	public function vertex(x:FloatRef, y:FloatRef):UInt;
}