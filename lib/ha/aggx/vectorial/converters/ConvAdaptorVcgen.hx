package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.ICurveGenerator;
import lib.ha.aggx.vectorial.generators.IMarkerGenerator;
import lib.ha.aggx.vectorial.IVertexSource;
import lib.ha.aggx.vectorial.NullMarkers;
import lib.ha.core.memory.Ref;
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
	private var _startX:Float;
	private var _startY:Float;
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
	public inline var generator(get_generator, null):ICurveGenerator;
	//---------------------------------------------------------------------------------------------------
	private inline function get_markers():IMarkerGenerator { return _markers; }
	public inline var markers(get_markers, null):IMarkerGenerator;
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
				var rm_start_x = Ref.float11.set(_startX);
				var rm_start_y = Ref.float12.set(_startY);
				_lastCmd = _source.getVertex(rm_start_x, rm_start_y);
				_startX = rm_start_x.value;
				_startY = rm_start_y.value;
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