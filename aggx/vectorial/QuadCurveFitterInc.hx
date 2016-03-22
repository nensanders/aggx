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
class QuadCurveFitterInc implements IVertexSource
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
	private var _fxSaved:Float;
	private var _fySaved:Float;
	private var _dfxSaved:Float;
	private var _dfySaved:Float;
	//---------------------------------------------------------------------------------------------------
	public function new(?x1:Float, ?y1:Float, ?x2:Float, ?y2:Float, ?x3:Float, ?y3:Float) 
	{
		_numSteps = 0;
		_scale = 1.0;
		_step = 0;			
		if (x1 != null && y1 != null && x2 != null && y2 != null && x3 != null && y3 != null)		
		{
			init(x1, y1, x2, y2, x3, y3);
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
	public function init(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Void
	{
		_startX = x1;
		_startY = y1;
		_endX = x3;
		_endY = y3;

		var dx1 = x2 - x1;
		var dy1 = y2 - y1;
		var dx2 = x3 - x2;
		var dy2 = y3 - y2;

		var len = Math.sqrt(dx1 * dx1 + dy1 * dy1) + Math.sqrt(dx2 * dx2 + dy2 * dy2);

		_numSteps = Std.int(len * 0.25 * _scale);

		if(_numSteps < 4)
		{
			_numSteps = 4;
		}

		var subdivide_step  = 1.0 / _numSteps;
		var subdivide_step2 = subdivide_step * subdivide_step;

		var tmpx = (x1 - x2 * 2.0 + x3) * subdivide_step2;
		var tmpy = (y1 - y2 * 2.0 + y3) * subdivide_step2;

		_fxSaved = _fx = x1;
		_fySaved = _fy = y1;

		_dfxSaved = _dfx = tmpx + (x2 - x1) * (2.0 * subdivide_step);
		_dfySaved = _dfy = tmpy + (y2 - y1) * (2.0 * subdivide_step);

		_ddfx = tmpx * 2.0;
		_ddfy = tmpy * 2.0;

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
		x.value = _fx;
		y.value = _fy;
		--_step;
		return PathCommands.LINE_TO;
	}
}