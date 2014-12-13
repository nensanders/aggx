package lib.ha.aggx.color;
//=======================================================================================================
import lib.ha.core.memory.Byte;
//=======================================================================================================
interface IAlphaFunction 
{
	public var size(get, null):UInt;
	public function get(idx:UInt):Byte;
}