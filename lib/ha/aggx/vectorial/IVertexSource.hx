package lib.ha.aggx.vectorial;
//=======================================================================================================
import lib.ha.core.memory.Ref;
//=======================================================================================================
interface IVertexSource
{
	public function rewind(pathId:UInt):Void;
	public function getVertex(x:FloatRef, y:FloatRef):UInt;
}