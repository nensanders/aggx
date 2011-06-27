package lib.ha.aggx.vectorial.converters;
//=======================================================================================================
import lib.ha.aggx.vectorial.generators.IPolygonGenerator;
import lib.ha.aggx.vectorial.IVertexSource;
import lib.ha.aggx.vectorial.PathCommands;
import lib.ha.aggx.vectorial.PathFlags;
import lib.ha.aggx.vectorial.PathUtils;
import lib.ha.core.memory.Ref;
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

			var rtx = Ref.float11;
			var rty = Ref.float12;
			cmd = _source.getVertex(rtx, rty);
			var tx = rtx.value;
			var ty = rty.value;
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
	private inline function get_vpgen():IPolygonGenerator { return _generator; }
	public inline var generator(get_vpgen, null):IPolygonGenerator;
	
}