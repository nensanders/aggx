package lib.ha.rfpx.data;
//=======================================================================================================
class LongHorMetric 
{
	private var _advanceWidth:UInt;			//USHORT
	private var _lsb:Int;					//SHORT
	//---------------------------------------------------------------------------------------------------
	public function new(advWidth:UInt, leftSb:Int) 
	{
		_advanceWidth = advWidth;
		_lsb = leftSb;
	}	
	//---------------------------------------------------------------------------------------------------
	private inline function get_advanceWidth():UInt { return _advanceWidth; }
	public var advanceWidth(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lsb():Int { return _lsb; }
	public var lsb(get, null):Int;
}