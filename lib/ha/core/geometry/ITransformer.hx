package lib.ha.core.geometry;
//=======================================================================================================
import lib.ha.core.memory.Ref;
//=======================================================================================================
interface ITransformer 
{
	function transform(x:FloatRef, y:FloatRef):Void;
}