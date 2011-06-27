package lib.ha.rfpx.data;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.MemoryReaderEx;
using lib.ha.core.memory.MemoryReaderEx;
//=======================================================================================================
class HmtxTable
{
	private var _tableRecord:TableRecord;
	private var _hMetrics:Vector<LongHorMetric>;
	private var _leftSideBearing:Vector<Int>;			//SHORT[numGlyphs - numberOfHMetrics]
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data:Pointer, numGlyphs:UInt, numberOfHMetrics:UInt) 
	{
		_tableRecord = record;
		
		_hMetrics = new Vector(numberOfHMetrics);
		
		var i:UInt = 0;
		while (i < numberOfHMetrics) 
		{
			var advWidth = data.getUShort();
			data += 2;
			var lsb = data.getShort();
			data += 2;
			_hMetrics[i] = new LongHorMetric(advWidth, lsb);
			++i;
		}
		
		var lsbCount:UInt = numGlyphs - numberOfHMetrics;
		_leftSideBearing = new Vector(lsbCount);
		i = 0;
		while (i < lsbCount)
		{
			_leftSideBearing[i] = data.getShort();
			data += 2;
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getLSB(idx:UInt):Int
	{
		var lsb = 0;
		if (idx < _hMetrics.length)
		{
			lsb = _hMetrics[idx].lsb;
		}
		else
		{
			lsb = _leftSideBearing[idx - _hMetrics.length];
		}
		return lsb;
	}
	//---------------------------------------------------------------------------------------------------
	public function getLHM(idx:UInt):LongHorMetric
	{
		var lhm = null;
		if (idx < _hMetrics.length)
		{
			lhm = _hMetrics[idx];
		}
		else
		{
			lhm = _hMetrics[_hMetrics.length - 1];
		}
		return lhm;
	}
}