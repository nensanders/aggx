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

package aggx.vectorial.converters;
//=======================================================================================================
import aggx.vectorial.generators.IPolygonGenerator;
import aggx.vectorial.IVertexSource;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathFlags;
import aggx.vectorial.PathUtils;
import aggx.core.memory.Ref;
//=======================================================================================================
class ConvAdaptorVpgen implements IVertexSource 
{
	private var _source:IVertexSource;
	private var _generator:IPolygonGenerator;
	private var _startX:Float;
	private var _startY:Float;
	private var _polyFlags:UInt;
	private var _vertices:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(vs:IVertexSource) 
	{
		_source = vs;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(vs:IVertexSource):Void
	{
		_source = vs;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void 
	{
		_source.rewind(pathId);
		_generator.reset();
		_startX = 0;
		_startY = 0;
		_polyFlags = 0;
		_vertices = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt 
	{
		var cmd = PathCommands.STOP;
        var count: Int = 0;
		while(true)
		{
			cmd = _generator.getVertex(x, y);
			if(!PathUtils.isStop(cmd)) break;

			if(_polyFlags !=0 && !_generator.autoUnclose)
			{
				x.value = 0.0;
				y.value = 0.0;
				cmd = _polyFlags;
				_polyFlags = 0;
				break;
			}

			if(_vertices < 0)
			{
				if(_vertices < -1) 
				{
					_vertices = 0;
					return PathCommands.STOP;
				}
				_generator.moveTo(_startX, _startY);
				_vertices = 1;
				continue;
			}

			var rtx = Ref.getFloat();
			var rty = Ref.getFloat();
			cmd = _source.getVertex(rtx, rty);
			var tx = Ref.putFloat(rtx).value;
			var ty = Ref.putFloat(rty).value;

			if(PathUtils.isVertex(cmd))
			{
				if(PathUtils.isMoveTo(cmd)) 
				{
					if(_generator.autoClose && _vertices > 2)
					{
						_generator.lineTo(_startX, _startY);
						_polyFlags = PathCommands.END_POLY | PathFlags.CLOSE;
						_startX = tx;
						_startY = ty;
						_vertices = -1;
						continue;
					}
					_generator.moveTo(tx, ty);
					_startX = tx;
					_startY = ty;
					_vertices = 1;
				}
				else 
				{
					_generator.lineTo(tx, ty);
					++_vertices;
				}
			}
			else
			{
				if(PathUtils.isEndPoly(cmd))
				{
					_polyFlags = cmd;
					if(PathUtils.isClosed(cmd) || _generator.autoClose)
					{
						if(_generator.autoClose) _polyFlags |= PathFlags.CLOSE;
						if(_vertices > 2)
						{
							_generator.lineTo(_startX, _startY);
						}
						_vertices = 0;
					}
				}
				else
				{
					// STOP
					if(_generator.autoClose && _vertices > 2)
					{
						_generator.lineTo(_startX, _startY);
						_polyFlags = PathCommands.END_POLY | PathFlags.CLOSE;
						_vertices = -2;
						continue;
					}
					break;
				}
			}
		}
		return cmd;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_generator():IPolygonGenerator { return _generator; }
	public var generator(get, null):IPolygonGenerator;
	
}