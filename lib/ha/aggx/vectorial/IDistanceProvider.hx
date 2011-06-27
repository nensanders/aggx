package lib.ha.aggx.vectorial;
//=======================================================================================================
interface IDistanceProvider
{
	public var x:Float;
	public var y:Float;
	public var dist:Float;
	public function calc(val:IDistanceProvider):Bool;
}