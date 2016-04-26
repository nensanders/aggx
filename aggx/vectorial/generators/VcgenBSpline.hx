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

package aggx.vectorial.generators;
//=======================================================================================================
import aggx.calculus.BSpline;
import aggx.vectorial.IVertexSource;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathUtils;
import aggx.vectorial.VertexDistance;
import aggx.vectorial.VertexSequence;
import aggx.core.memory.Ref;
//=======================================================================================================
class VcgenBSpline implements ICurveGenerator implements IVertexSource
{
	private static inline var INITIAL = 0;
	private static inline var READY = 1;
	private static inline var POLYGON = 2;
	private static inline var END_POLY = 3;
	private static inline var STOP = 4;
	//---------------------------------------------------------------------------------------------------
	private var _srcVertices:VertexSequence;
	private var _splineX:BSpline;
	private var _splineY:BSpline;
	private var _interpolationStep:Float;
	private var _isClosed:UInt;
	private var _status:Int;
	private var _srcVertex:UInt;
	private var _curAbscissa:Float;
	private var _maxAbscissa:Float;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_interpolationStep = 1 / 50;
		_splineX = new BSpline();
		_splineY = new BSpline();
		_srcVertices = new VertexSequence();
		_status = INITIAL;
		_isClosed = 0;
		_srcVertex = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function removeAll():Void
	{
		_srcVertices.removeAll();
		_isClosed = 0;
		_status = INITIAL;
		_srcVertex = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function addVertex(x:Float, y:Float, cmd:UInt):Void
	{
		_status = INITIAL;
		if(PathUtils.isMoveTo(cmd))
		{
			_srcVertices.modifyLast(new VertexDistance(x, y));
		}
		else
		{
			if(PathUtils.isVertex(cmd))
			{
				_srcVertices.add(new VertexDistance(x, y));
			}
			else
			{
				_isClosed = PathUtils.getCloseFlag(cmd);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void 
	{
		_curAbscissa = 0.0;
		_maxAbscissa = 0.0;
		_srcVertex = 0;
		if(_status == INITIAL && _srcVertices.size > 2)
		{
			if(_isClosed != 0)
			{
				_splineX.init(_srcVertices.size + 8);
				_splineY.init(_srcVertices.size + 8);
				_splineX.addPoint(0.0, _srcVertices.prev(_srcVertices.size - 3).x);
				_splineY.addPoint(0.0, _srcVertices.prev(_srcVertices.size - 3).y);
				_splineX.addPoint(1.0, _srcVertices.get(_srcVertices.size - 3).x);
				_splineY.addPoint(1.0, _srcVertices.get(_srcVertices.size - 3).y);
				_splineX.addPoint(2.0, _srcVertices.get(_srcVertices.size - 2).x);
				_splineY.addPoint(2.0, _srcVertices.get(_srcVertices.size - 2).y);
				_splineX.addPoint(3.0, _srcVertices.get(_srcVertices.size - 1).x);
				_splineY.addPoint(3.0, _srcVertices.get(_srcVertices.size - 1).y);
			}
			else
			{
				_splineX.init(_srcVertices.size);
				_splineY.init(_srcVertices.size);
			}
			var i:UInt = 0;
			while (i < _srcVertices.size)
			{
				var x = _isClosed != 0 ? i + 4 : i;
				_splineX.addPoint(x, _srcVertices.get(i).x);
				_splineY.addPoint(x, _srcVertices.get(i).y);
				++i;
			}
			_curAbscissa = 0.0;
			_maxAbscissa = _srcVertices.size - 1;
			if(_isClosed != 0)
			{
				_curAbscissa = 4.0;
				_maxAbscissa += 5.0;
				_splineX.addPoint(_srcVertices.size + 4, _srcVertices.get(0).x);
				_splineY.addPoint(_srcVertices.size + 4, _srcVertices.get(0).y);
				_splineX.addPoint(_srcVertices.size + 5, _srcVertices.get(1).x);
				_splineY.addPoint(_srcVertices.size + 5, _srcVertices.get(1).y);
				_splineX.addPoint(_srcVertices.size + 6, _srcVertices.get(2).x);
				_splineY.addPoint(_srcVertices.size + 6, _srcVertices.get(2).y);
				_splineX.addPoint(_srcVertices.size + 7, _srcVertices.next(2).x);
				_splineY.addPoint(_srcVertices.size + 7, _srcVertices.next(2).y);
			}
			_splineX.prepare();
			_splineY.prepare();
		}
		_status = READY;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt 
	{
		var cmd = PathCommands.LINE_TO;
		while(!PathUtils.isStop(cmd))
		{
			switch(_status)
			{
			case INITIAL:
				rewind(0);

			case READY:
				if(_srcVertices.size < 2)
				{
					cmd = PathCommands.STOP;
				}
				else if(_srcVertices.size == 2)
				{
					x.value = _srcVertices.get(_srcVertex).x;
					y.value = _srcVertices.get(_srcVertex).y;
					_srcVertex++;
					if(_srcVertex == 1) return PathCommands.MOVE_TO;
					if(_srcVertex == 2) return PathCommands.LINE_TO;
					cmd = PathCommands.STOP;
				}
				else 
				{
					cmd = PathCommands.MOVE_TO;
					_status = POLYGON;
					_srcVertex = 0;
				}

			case POLYGON:
				var brk = false;
				if(_curAbscissa >= _maxAbscissa)
				{
					if(_isClosed != 0)
					{
						_status = END_POLY;
						brk = true;
					}
					else
					{
						x.value = _srcVertices.get(_srcVertices.size - 1).x;
						y.value = _srcVertices.get(_srcVertices.size - 1).y;
						_status = END_POLY;
						return PathCommands.LINE_TO;
					}
				}
				if (!brk) 
				{
					x.value = _splineX.getStateful(_curAbscissa);
					y.value = _splineY.getStateful(_curAbscissa);
					_srcVertex++;
					_curAbscissa += _interpolationStep;
					return (_srcVertex == 1) ? PathCommands.MOVE_TO : PathCommands.LINE_TO;	
				}

			case END_POLY:
				_status = STOP;
				return PathCommands.END_POLY | _isClosed;

			case STOP:
				return PathCommands.STOP;
			}
		}
		return cmd;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_interpolationStep():Float { return _interpolationStep; }
	private inline function set_interpolationStep(value:Float):Float { return _interpolationStep = value; }
	public var interpolationStep(get, set):Float;
}