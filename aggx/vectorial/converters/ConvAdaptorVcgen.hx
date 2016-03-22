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
import aggx.vectorial.generators.ICurveGenerator;
import aggx.vectorial.generators.IMarkerGenerator;
import aggx.vectorial.IVertexSource;
import aggx.vectorial.NullMarkers;
import aggx.core.memory.Ref;
//=======================================================================================================
class ConvAdaptorVcgen implements IVertexSource
{
	private static inline var INITIAL = 0;
	private static inline var ACCUMULATE = 1;
	private static inline var GENERATE = 2;
	//---------------------------------------------------------------------------------------------------
	private var _source:IVertexSource;
	private var _generator:ICurveGenerator;
	private var _markers:IMarkerGenerator;
	private var _status:Int;
	private var _lastCmd:Int;
	private var _startX:Float = 0.0;
	private var _startY:Float = 0.0;
	//---------------------------------------------------------------------------------------------------
	private function new(vs:IVertexSource, ?markers:IMarkerGenerator) 
	{
		_source = vs;
		_status = INITIAL;
		if (markers == null)		
		{
			markers = new NullMarkers();
		}
		_markers = markers;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(source:IVertexSource):Void
	{
		_source = source;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_generator():ICurveGenerator { return _generator; }
	public var generator(get, null):ICurveGenerator;
	//---------------------------------------------------------------------------------------------------
	private inline function get_markers():IMarkerGenerator { return _markers; }
	public var markers(get, null):IMarkerGenerator;
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void
	{
		_source.rewind(pathId);
		_status = INITIAL;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		var cmd = PathCommands.STOP;
		var done = false;
		while(!done)
		{
			switch(_status)
			{
			case INITIAL:
				_markers.removeAll();
				var rm_start_x = Ref.getFloat().set(_startX);
				var rm_start_y = Ref.getFloat().set(_startY);
				_lastCmd = _source.getVertex(rm_start_x, rm_start_y);
				_startX = Ref.putFloat(rm_start_x).value;
				_startY = Ref.putFloat(rm_start_y).value;
				_status = ACCUMULATE;

			case ACCUMULATE:
				if(PathUtils.isStop(_lastCmd)) return PathCommands.STOP;

				_generator.removeAll();
				_generator.addVertex(_startX, _startY, PathCommands.MOVE_TO);
				_markers.addVertex(_startX, _startY, PathCommands.MOVE_TO);

				while(true)
				{
					cmd = _source.getVertex(x, y);
					if(PathUtils.isVertex(cmd))
					{
						_lastCmd = cmd;
						if(PathUtils.isMoveTo(cmd))
						{
							_startX = x.value;
							_startY = y.value;
							break;
						}
						_generator.addVertex(x.value, y.value, cmd);
						_markers.addVertex(x.value, y.value, PathCommands.LINE_TO);
					}
					else
					{
						if(PathUtils.isStop(cmd))
						{
							_lastCmd = PathCommands.STOP;
							break;
						}
						if(PathUtils.isEndPoly(cmd))
						{
							_generator.addVertex(x.value, y.value, cmd);
							break;
						}
					}
				}
				_generator.rewind(0);
				_status = GENERATE;

			case GENERATE:
				cmd = _generator.getVertex(x, y);
				if(PathUtils.isStop(cmd))
				{
					_status = ACCUMULATE;
				}
				else 
				{
					done = true;
				}
			}
		}
		return cmd;
	}
}