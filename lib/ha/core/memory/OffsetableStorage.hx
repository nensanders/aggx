package lib.ha.core.memory;
//=======================================================================================================
import flash.Vector;
//=======================================================================================================
typedef OffsetableStorage<T> =
{
	public var offset:Int;
	public var data:Vector<T>;
}