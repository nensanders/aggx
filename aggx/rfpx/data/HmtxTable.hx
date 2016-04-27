//----------------------------------------------------------------------------
// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)
//
// Permission to copy, use, modify, sell and distribute this software 
// is granted provided this copyright notice appears in all copies. 
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//
// Haxe port by: Hypeartist hypeartist@gmail.com
// Copyright (C) 2011 https://code.google.com/p/aggx
//
//----------------------------------------------------------------------------
// Contact: mcseem@antigrain.com
//          mcseemagg@yahoo.com
//          http://www.antigrain.com
//----------------------------------------------------------------------------

package aggx.rfpx.data;
//=======================================================================================================
import types.Data;
import haxe.ds.Vector;
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class HmtxTable
{
	private var _tableRecord:TableRecord;
	private var _hMetrics:Vector<LongHorMetric>;
	private var _leftSideBearing:Array<Int>;			//SHORT[numGlyphs - numberOfHMetrics]
	//---------------------------------------------------------------------------------------------------
	public function new(record:TableRecord, data: Data, numGlyphs:UInt, numberOfHMetrics:UInt)
	{
		_tableRecord = record;
		
		_hMetrics = new Vector(numberOfHMetrics);
		
		var i:UInt = 0;
		while (i < numberOfHMetrics) 
		{
			var advWidth = data.dataGetUShort();
			data.offset += 2;
			var lsb = data.dataGetShort();
			data.offset += 2;
			_hMetrics[i] = new LongHorMetric(advWidth, lsb);
			++i;
		}
		
		var lsbCount:UInt = numGlyphs - numberOfHMetrics;
		_leftSideBearing = [];
		i = 0;
		while (i < lsbCount)
		{
			_leftSideBearing[i] = data.dataGetShort();
			data.offset += 2;
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getLSB(idx:UInt):Int
	{
		var lsb = 0;
		if (idx < cast _hMetrics.length)
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
		if (idx < cast _hMetrics.length)
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