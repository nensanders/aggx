package lib.ha.rfpx.data;
//=======================================================================================================
class LangTagRecord 
{
	private var _length:UInt;			//USHORT
	private var _offset:UInt;			//USHORT
	//---------------------------------------------------------------------------------------------------
	public function new(len:UInt, ofs:UInt)
	{
		_length = len;
		_offset = ofs;
	}
}