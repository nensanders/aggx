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

package aggx.vectorial;
//=======================================================================================================
import aggx.core.memory.Ref;
//=======================================================================================================
class CubicCurveFitterInc implements IVertexSource
{
	private var _numSteps:Int;
	private var _step:Int;
	private var _scale:Float;
	private var _startX:Float;
	private var _startY:Float;
	private var _endX:Float;
	private var _endY:Float;
	private var _fx:Float;
	private var _fy:Float;
	private var _dfx:Float;
	private var _dfy:Float;
	private var _ddfx:Float;
	private var _ddfy:Float;
	private var _dddfx:Float;
	private var _dddfy:Float;	
	private var _fxSaved:Float;
	private var _fySaved:Float;
	private var _dfxSaved:Float;
	private var _dfySaved:Float;
	private var _ddfxSaved:Float;
	private var _ddfySaved:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(?x1:Float, ?y1:Float, ?x2:Float, ?y2:Float, ?x3:Float, ?y3:Float, ?x4:Float, ?y4:Float) 
	{
		_numSteps = 0;
		_scale = 1.0;
		_step = 0;			
		if (x1 != null && y1 != null && x2 != null && y2 != null && x3 != null && y3 != null && x4 != null && y4 != null)		
		{
			init(x1, y1, x2, y2, x3, y3, x4, y4);
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return _scale; }
	private inline function set_approximationScale(value:Float):Float { return _scale = value; }
	public var approximationScale(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_angleTolerance():Float { return 0.0; }
	private inline function set_angleTolerance(value:Float):Float { return value; }
	public var angleTolerance(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_cuspLimit():Float { return 0.0; }
	private inline function set_cuspLimit(value:Float):Float { return value; }
	public var cuspLimit(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	public function init(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):Void
	{
		_startX = x1;
		_startY = y1;
		_endX   = x4;
		_endY   = y4;

		var dx1 = x2 - x1;
		var dy1 = y2 - y1;
		var dx2 = x3 - x2;
		var dy2 = y3 - y2;
		var dx3 = x4 - x3;
		var dy3 = y4 - y3;

		var len = (Math.sqrt(dx1 * dx1 + dy1 * dy1) + Math.sqrt(dx2 * dx2 + dy2 * dy2) + Math.sqrt(dx3 * dx3 + dy3 * dy3)) * 0.25 * _scale;

		_numSteps = Std.int(len);

		if(_numSteps < 4)
		{
			_numSteps = 4;
		}

		var subdivide_step  = 1.0 / _numSteps;
		var subdivide_step2 = subdivide_step * subdivide_step;
		var subdivide_step3 = subdivide_step * subdivide_step * subdivide_step;

		var pre1 = 3.0 * subdivide_step;
		var pre2 = 3.0 * subdivide_step2;
		var pre4 = 6.0 * subdivide_step2;
		var pre5 = 6.0 * subdivide_step3;

		var tmp1x = x1 - x2 * 2.0 + x3;
		var tmp1y = y1 - y2 * 2.0 + y3;

		var tmp2x = (x2 - x3) * 3.0 - x1 + x4;
		var tmp2y = (y2 - y3) * 3.0 - y1 + y4;

		_fxSaved = _fx = x1;
		_fySaved = _fy = y1;

		_dfxSaved = _dfx = (x2 - x1) * pre1 + tmp1x * pre2 + tmp2x * subdivide_step3;
		_dfySaved = _dfy = (y2 - y1) * pre1 + tmp1y * pre2 + tmp2y * subdivide_step3;

		_ddfxSaved = _ddfx = tmp1x * pre4 + tmp2x * pre5;
		_ddfySaved = _ddfy = tmp1y * pre4 + tmp2y * pre5;

		_dddfx = tmp2x * pre5;
		_dddfy = tmp2y * pre5;

		_step = _numSteps;
	}
	//---------------------------------------------------------------------------------------------------
	public function reset():Void
	{
		_numSteps = 0;
		_step = -1;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void
	{
		if(_numSteps == 0)
		{
			_step = -1;
			return;
		}
		_step = _numSteps;
		_fx = _fxSaved;
		_fy = _fySaved;
		_dfx = _dfxSaved;
		_dfy = _dfySaved;
		_ddfx = _ddfxSaved;
		_ddfy = _ddfySaved;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		if(_step < 0) return PathCommands.STOP;
		if(_step == _numSteps)
		{
			x.value = _startX;
			y.value = _startY;
			--_step;
			return PathCommands.MOVE_TO;
		}

		if(_step == 0)
		{
			x.value = _endX;
			y.value = _endY;
			--_step;
			return PathCommands.LINE_TO;
		}

		_fx += _dfx;
		_fy += _dfy;
		_dfx += _ddfx;
		_dfy += _ddfy;
		_ddfx += _dddfx;
		_ddfy += _dddfy;

		x.value = _fx;
		y.value = _fy;
		--_step;
		return PathCommands.LINE_TO;
	}
}