package lib.ha.aggx.color;
//=======================================================================================================
import lib.ha.core.memory.Byte;
//=======================================================================================================
interface IAlphaFunction 
{
	public var size(get_size, null):UInt;
	public function get(idx:UInt):Byte;
}