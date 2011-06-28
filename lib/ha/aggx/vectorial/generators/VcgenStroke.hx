package lib.ha.aggx.vectorial.generators;
//=======================================================================================================
import flash.Vector;
import lib.ha.aggx.vectorial.IVertexSource;
import lib.ha.aggx.vectorial.MathStroke;
import lib.ha.aggx.vectorial.PathCommands;
import lib.ha.aggx.vectorial.PathFlags;
import lib.ha.aggx.vectorial.PathUtils;
import lib.ha.aggx.vectorial.VertexDistance;
import lib.ha.aggx.vectorial.VertexSequence;
import lib.ha.core.geometry.Coord;
import lib.ha.core.memory.Ref;
//=======================================================================================================
class VcgenStroke implements ICurveGenerator, implements IVertexSource //Vertex Curve Generator
{
	private static var INITIAL = 0;
	private static var READY = 1;
	private static var CAP1 = 2;
	private static var CAP2 = 3;
	private static var OUTLINE1 = 4;
	private static var CLOSE_FIRST = 5;
	private static var OUTLINE2 = 6;
	private static var OUT_VERTICES = 7;
	private static var END_POLY1 = 8;
	private static var END_POLY2 = 9;
	private static var STOP = 10;
	//---------------------------------------------------------------------------------------------------
	private var _stroker:MathStroke;
	private var _srcVertices:VertexSequence;
	private var _outVertices:Vector<Coord>;
	private var _shorten:Float;
	private var _isClosed:Int;
	private var _status:Int;
	private var _prevStatus:Int;
	private var _srcVertexIndex:UInt;
	private var _outVertexIndex:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_stroker = new MathStroke();
		_srcVertices = new VertexSequence();
		_outVertices = new Vector();
		_outVertexIndex = 0;
		_srcVertexIndex = 0;
		_status = INITIAL;
		_isClosed = 0;
		_shorten = 0.0;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_width():Float { return _stroker.width; }
	private inline function set_width(value:Float):Float { return _stroker.width = value; }
	public inline var width(get_width, set_width):Float;		
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineCap():Int { return _stroker.lineCap; }
	private inline function set_lineCap(value:Int):Int { return _stroker.lineCap = value; }
	public inline var lineCap(get_lineCap, set_lineCap):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lineJoin():Int { return _stroker.lineJoin; }
	private inline function set_lineJoin(value:Int):Int { return _stroker.lineJoin = value; }
	public inline var lineJoin(get_lineJoin, set_lineJoin):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerJoin():Int { return _stroker.innerJoin; }
	private inline function set_innerJoin(value:Int):Int { return _stroker.innerJoin = value; }
	public inline var innerJoin(get_innerJoin, set_innerJoin):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_miterLimit():Float { return _stroker.miterLimit; }
	private inline function set_miterLimit(value:Float):Float { return _stroker.miterLimit = value; }
	public inline var miterLimit(get_miterLimit, set_miterLimit):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_innerMiterLimit():Float { return _stroker.innerMiterLimit; }
	private inline function set_innerMiterLimit(value:Float):Float { return _stroker.innerMiterLimit = value; }
	public inline var innerMiterLimit(get_innerMiterLimit, set_innerMiterLimit):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return _stroker.approximationScale; }
	private inline function set_approximationScale(value:Float):Float { return _stroker.approximationScale = value; }
	public inline var approximationScale(get_approximationScale, set_approximationScale):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function set_miterLimitTheta(value:Float):Float { return _stroker.miterLimit = value; }
	public inline var miterLimitTheta(null, set_miterLimitTheta):Float;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_shorten():Float { return _shorten; }
	private inline function set_shorten(value:Float):Float { return _shorten = value; }
	public inline var shorten(get_shorten, set_shorten):Float;
	//---------------------------------------------------------------------------------------------------
	public function removeAll()
	{
		_srcVertices.removeAll();
		_isClosed = 0;
		_status = INITIAL;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function addVertex(x:Float, y:Float, cmd:UInt):Void
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
		if(_status == INITIAL)
		{
			_srcVertices.close(_isClosed != 0);
			PathUtils.shortenPath(_srcVertices, _shorten, _isClosed);
			if(_srcVertices.size < 3) _isClosed = 0;
		}
		_status = READY;
		_srcVertexIndex = 0;
		_outVertexIndex = 0;
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
				if(_srcVertices.size < cast (2 + (_isClosed != 0 ? 1 : 0)))
				{
					cmd = PathCommands.STOP;
				}
				else
				{
					_status = _isClosed != 0 ? OUTLINE1 : CAP1;
					cmd = PathCommands.MOVE_TO;
					_srcVertexIndex = 0;
					_outVertexIndex = 0;
				}

			case CAP1:
				_stroker.calcCap(_outVertices, _srcVertices.get(0), _srcVertices.get(1), _srcVertices.get(0).dist);
				_srcVertexIndex = 1;
				_prevStatus = OUTLINE1;
				_status = OUT_VERTICES;
				_outVertexIndex = 0;

			case CAP2:
				_stroker.calcCap(_outVertices, _srcVertices.get(_srcVertices.size - 1), _srcVertices.get(_srcVertices.size - 2), _srcVertices.get(_srcVertices.size - 2).dist);
				_prevStatus = OUTLINE2;
				_status = OUT_VERTICES;
				_outVertexIndex = 0;

			case OUTLINE1:
				var proceed = true;
				if(_isClosed != 0)
				{
					if(_srcVertexIndex >= _srcVertices.size)
					{
						_prevStatus = CLOSE_FIRST;
						_status = END_POLY1;
						proceed = false;
					}
				}
				else
				{
					if(_srcVertexIndex >= cast(_srcVertices.size - 1))
					{
						_status = CAP2;
						proceed = false;
					}
				}
				if (proceed) 
				{
					_stroker.calcJoin(_outVertices,
										_srcVertices.prev(_srcVertexIndex),
										_srcVertices.curr(_srcVertexIndex),
										_srcVertices.next(_srcVertexIndex),
										_srcVertices.prev(_srcVertexIndex).dist,
										_srcVertices.curr(_srcVertexIndex).dist);
					++_srcVertexIndex;
					_prevStatus = _status;
					_status = OUT_VERTICES;
					_outVertexIndex = 0;					
				}

			case CLOSE_FIRST:
				_status = OUTLINE2;
				cmd = PathCommands.MOVE_TO;

			case OUTLINE2:
				if(_srcVertexIndex <= cast(_isClosed == 0 ? 1 : 0))
				{
					_status = END_POLY2;
					_prevStatus = STOP;
				}
				else 
				{
					--_srcVertexIndex;
					_stroker.calcJoin(_outVertices,
										_srcVertices.next(_srcVertexIndex),
										_srcVertices.curr(_srcVertexIndex),
										_srcVertices.prev(_srcVertexIndex),
										_srcVertices.curr(_srcVertexIndex).dist,
										_srcVertices.prev(_srcVertexIndex).dist);

					_prevStatus = _status;
					_status = OUT_VERTICES;
					_outVertexIndex = 0;		
				}

			case OUT_VERTICES:
				if(_outVertexIndex >= _outVertices.length)
				{
					_status = _prevStatus;
				}
				else
				{
					var c = _outVertices[_outVertexIndex++];
					x.value = c.x;
					y.value = c.y;
					return cmd;
				}

			case END_POLY1:
				_status = _prevStatus;
				return PathCommands.END_POLY | PathFlags.CLOSE | PathFlags.CCW;

			case END_POLY2:
				_status = _prevStatus;
				return PathCommands.END_POLY | PathFlags.CLOSE | PathFlags.CW;

			case STOP:
				cmd = PathCommands.STOP;
			}
		}
		return cmd;
	}
}