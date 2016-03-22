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
import aggx.core.geometry.ITransformer;
import aggx.core.memory.Ref;
//=======================================================================================================
class TransSinglePath implements ITransformer
{
	private inline static var INITIAL = 0;
	private inline static var MAKING_PATH = 0;
	private inline static var READY = 0;
	//---------------------------------------------------------------------------------------------------
	private var _srcVertices:VertexSequence;
	private var _baseLength:Float;
	private var _kindex:Float;
	private var _status:Int;
	private var _preserveXScale:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_baseLength = 0.0;
		_kindex = 0;
		_status = INITIAL;
		_preserveXScale = true;
		_srcVertices = new VertexSequence();
	}
	//---------------------------------------------------------------------------------------------------
	public function reset():Void
	{
		_kindex = 0;
		_status = INITIAL;
		_srcVertices.removeAll();
	}
	//---------------------------------------------------------------------------------------------------
	public function moveTo(x:Float, y:Float):Void
	{
		if(_status == INITIAL)
		{
			_srcVertices.modifyLast(new VertexDistance(x, y));
			_status = MAKING_PATH;
		}
		else
		{
			lineTo(x, y);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function lineTo(x:Float, y:Float):Void
	{
		if(_status == MAKING_PATH)
		{
			_srcVertices.add(new VertexDistance(x, y));
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function finalizePath():Void
	{
		if(_status == MAKING_PATH && _srcVertices.size > 1)
		{
			var dist:Float;
			var d:Float;

			_srcVertices.close(false);
			if(_srcVertices.size > 2)
			{
				if(_srcVertices.get(_srcVertices.size - 2).dist * 10.0 < _srcVertices.get(_srcVertices.size - 3).dist)
				{
					d = _srcVertices.get(_srcVertices.size - 3).dist + _srcVertices.get(_srcVertices.size - 2).dist;

					_srcVertices.set(_srcVertices.size - 2, _srcVertices.get(_srcVertices.size - 1));

					_srcVertices.removeLast();
					_srcVertices.get(_srcVertices.size - 2).dist = d;
				}
			}

			dist = 0.0;
			var i:UInt = 0;
			while (i < _srcVertices.size)
			{
				var v = _srcVertices.get(i);
				var d = v.dist;
				v.dist = dist;
				dist += d;
				++i;
			}
			_kindex = (_srcVertices.size - 1) / dist;
			_status = READY;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function transform(x:FloatRef, y:FloatRef):Void
	{
		if(_status == READY)
		{
			if(_baseLength > 1e-10)
			{
				x.value *= _srcVertices.get(_srcVertices.size - 1).dist / _baseLength;
			}

			var x1 = 0.0;
			var y1 = 0.0;
			var dx = 1.0;
			var dy = 1.0;
			var d  = 0.0;
			var dd = 1.0;
			if(x.value < 0.0)
			{
				// Extrapolation on the left
				//--------------------------
				x1 = _srcVertices.get(0).x;
				y1 = _srcVertices.get(0).y;
				dx = _srcVertices.get(1).x - x1;
				dy = _srcVertices.get(1).y - y1;
				dd = _srcVertices.get(1).dist - _srcVertices.get(0).dist;
				d  = x.value;
			}
			else
			if(x.value > _srcVertices.get(_srcVertices.size - 1).dist)
			{
				// Extrapolation on the right
				//--------------------------
				var i:UInt = _srcVertices.size - 2;
				var j:UInt = _srcVertices.size - 1;
				x1 = _srcVertices.get(j).x;
				y1 = _srcVertices.get(j).y;
				dx = x1 - _srcVertices.get(i).x;
				dy = y1 - _srcVertices.get(i).y;
				dd = _srcVertices.get(j).dist - _srcVertices.get(i).dist;
				d  = x.value - _srcVertices.get(j).dist;
			}
			else
			{
				// Interpolation
				//--------------------------
				var i:UInt = 0;
				var j:UInt = _srcVertices.size - 1;
				if(_preserveXScale)
				{
					var k:UInt;
					while((j - i) > 1)
					{
						if(x.value < _srcVertices.get(k = (i + j) >> 1).dist) 
						{
							j = k; 
						}
						else 
						{
							i = k;
						}
					}
					d  = _srcVertices.get(i).dist;
					dd = _srcVertices.get(j).dist - d;
					d  = x.value - d;
				}
				else
				{
					i = Std.int(x.value * _kindex);
					j = i + 1;
					dd = _srcVertices.get(j).dist - _srcVertices.get(i).dist;
					d = ((x.value * _kindex) - i) * dd;
				}
				x1 = _srcVertices.get(i).x;
				y1 = _srcVertices.get(i).y;
				dx = _srcVertices.get(j).x - x1;
				dy = _srcVertices.get(j).y - y1;
			}
			var x2 = x1 + dx * d / dd;
			var y2 = y1 + dy * d / dd;
			x.value = x2 - y.value * dy / dd;
			y.value = y2 + y.value * dx / dd;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function addPath(vs:IVertexSource, pathId:UInt = 0):Void
	{
		var x = Ref.getFloat();
		var y = Ref.getFloat();

		var cmd:UInt;
		vs.rewind(pathId);
		while(!PathUtils.isStop(cmd = vs.getVertex(x, y)))
		{
			if(PathUtils.isMoveTo(cmd)) 
			{
				moveTo(x.value, y.value);
			}
			else 
			{
				if(PathUtils.isVertex(cmd))
				{
					lineTo(x.value, y.value);
				}
			}
		}

        Ref.putFloat(x);
        Ref.putFloat(y);
		finalizePath();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_totalLength():Float 
	{
		var ret = 0.0;
		if (_baseLength >= 1e-10) ret = _baseLength;
		else 
		{
			ret = (_status == READY) ? _srcVertices.get(_srcVertices.size - 1).dist : 0.0;
		}
		return ret;
	}
	public var totalLength(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_baseLength():Float { return _baseLength; }
	private inline function set_baseLength(value:Float):Float { return _baseLength = value; }
	public var baseLength(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_preserveXScale():Bool { return _preserveXScale; }
	private inline function set_preserveXScale(value:Bool):Bool { return _preserveXScale = value; }
	public var preserveXScale(get, set):Bool;
}