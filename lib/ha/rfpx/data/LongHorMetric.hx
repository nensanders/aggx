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
	public inline var advanceWidth(get_advanceWidth, null):UInt;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lsb():Int { return _lsb; }
	public inline var lsb(get_lsb, null):Int;
}