package lib.ha.aggx.vectorial.generators;
//=======================================================================================================
import lib.ha.aggx.vectorial.IVertexSource;
import lib.ha.aggx.vectorial.MathStroke;
import lib.ha.aggx.vectorial.PathCommands;
import lib.ha.aggx.vectorial.PathFlags;
import lib.ha.aggx.vectorial.PathUtils;
import lib.ha.aggx.vectorial.VertexDistance;
import lib.ha.aggx.vectorial.VertexSequence;
import lib.ha.core.math.Calc;
import lib.ha.core.memory.Ref;
//=======================================================================================================
class VcgenContour implements ICurveGenerator, implements IVertexSource
{
	private static inline var INITIAL = 0;
	private static inline var READY = 1;
	private static inline var OUTLINE = 2;
	private static inline var OUT_VERTICES = 3;
	private static inline var END_POLY = 4;
	private static inline var STOP = 5;
	//---------------------------------------------------------------------------------------------------
	private var _stroker:MathStroke;
	private var _width:Float;
	private var _srcVertices:VertexSequence;
	private var _outVertices:VertexSequence;
	private var _status:UInt;
	private var _srcVertex:UInt;
	private var _outVertex:UInt;
	private var _closed:UInt;
	private var _orientation:UInt;
	private var _autoDetect:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_stroker = new MathStroke();
		_width = 1.;
		_srcVertices = new VertexSequence();
		_outVertices = new VertexSequence();
		_status = INITIAL;
		_srcVertex = 0;
		_outVertex = 0;
		_closed = 0;
		_orientation = 0;
		_autoDetect = false;
	}
	//---------------------------------------------------------------------------------------------------
	public function removeAll():Void
	{
        _srcVertices.removeAll();
        _closed = 0;
        _orientation = 0;
        _status = INITIAL;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void 
	{
        if(_status == INITIAL)
        {
            _srcVertices.close(true);
            if(_autoDetect)
            {
                if(!PathUtils.isOriented(_orientation))
                {
                    _orientation = (calc_polygon_area(_srcVertices) > 0.0) ? PathFlags.CCW : PathFlags.CW;
                }
            }
            if(PathUtils.isOriented(_orientation))
            {
                _stroker.width(PathUtils.isCCW(_orientation) ? _width : -_width);
            }
        }
        _status = READY;
        _srcVertex = 0;
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
				_status = READY;

            case READY:
                if(_srcVertices.size < (2 + Calc.int(_closed != 0)))
                {
                    cmd = PathCommands.STOP;
                    //break;
                }
				else 
				{
					_status = OUTLINE;
					cmd = PathCommands.MOVE_TO;
					_srcVertex = 0;
					_outVertex = 0;
				}

            case OUTLINE:
                if(_srcVertex >= _srcVertices.size)
                {
                    _status = END_POLY;
                    //break;
                }
				else 
				{
					_stroker.calcJoin(_outVertices, 
										_srcVertices.prev(_srcVertex), 
										_srcVertices.curr(_srcVertex), 
										_srcVertices.next(_srcVertex), 
										_srcVertices.prev(_srcVertex).dist,
										_srcVertices.curr(_srcVertex).dist);
					++_srcVertex;
					_status = OUT_VERTICES;
					_outVertex = 0;
				}

            case OUT_VERTICES:
                if(_outVertex >= _outVertices.size)
                {
                    _status = OUTLINE;
                }
                else
                {
                    var c = _outVertices.get(_outVertex++);
                    x.value = c.x;
                    y.value = c.y;
                    return cmd;
                }
                //break;

            case END_POLY:
                if(_closed!=0) return PathCommands.STOP;
                _status = STOP;
                return PathCommands.END_POLY | PathFlags.CLOSE | PathFlags.CCW;

            case STOP:
                return PathCommands.STOP;
            }
        }
        return cmd;
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
                if(PathUtils.isEndPoly(cmd))
                {
                    _closed = PathUtils.getCloseFlag(cmd);
                    if(_orientation == PathFlags.NONE) 
                    {
                        _orientation = get_orientation(cmd);
                    }
                }
            }
        }
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
	private inline function get_autoDetect():Bool { return _autoDetect; }
	private inline function set_autoDetect(value:Bool):Bool { return _autoDetect = value; }
	public inline var autoDetect(get_autoDetect, set_autoDetect):Bool;
}