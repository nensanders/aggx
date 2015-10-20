package lib.ha.aggx.vectorial;

import haxe.ds.Vector;
import lib.ha.core.memory.Ref.FloatRef;

class BezierArc implements IVertexSource
{
    public var _vertices(default, null): Vector<FloatRef> = new Vector<FloatRef>(26);
    var _vertex: UInt = 0;
    var _numVertices(default, null): UInt = 0;
    var _cmd: UInt = PathCommands.LINE_TO;

    static var bezierArcAngleEpsilon = 0.01;

    private function arcToBezier(cx: Float, cy: Float, rx: Float, ry: Float,
                                 startAngle: Float, sweepAngle: Float,
                                 curve: Vector<FloatRef>, curvePos: UInt): Void
    {
        var x0: Float = Math.cos(sweepAngle / 2.0);
        var y0: Float = Math.sin(sweepAngle / 2.0);
        var tx: Float = (1.0 - x0) * 4.0 / 3.0;
        var ty: Float = y0 - tx * x0 / y0;
        var px: Array<Float> = [x0, x0 + tx, x0 + tx, x0];
        var py: Array<Float> = [-y0, -ty, ty, y0];

        var sn: Float = Math.sin(startAngle + sweepAngle / 2.0);
        var cs: Float = Math.cos(startAngle + sweepAngle / 2.0);

        for(i in  0 ... 4)
        {
            curve[curvePos + i * 2].value     = cx + rx * (px[i] * cs - py[i] * sn);
            curve[curvePos + i * 2 + 1].value = cy + ry * (px[i] * sn + py[i] * cs);
        }
    }

    public function new ()
    {
    }

    public function init(x: Float, y: Float, rx: Float, ry: Float, startAngle: Float, sweepAngle: Float)
    {
        startAngle = startAngle % (2.0 * Math.PI);

        if(sweepAngle >=  2.0 * Math.PI) sweepAngle =  2.0 * Math.PI;
        if(sweepAngle <= -2.0 * Math.PI) sweepAngle = -2.0 * Math.PI;

        if(Math.abs(sweepAngle) < 1e-10)
        {
            _numVertices = 4;
            _cmd = PathCommands.LINE_TO;
            _vertices[0].value = x + rx * Math.cos(startAngle);
            _vertices[1].value = y + ry * Math.sin(startAngle);
            _vertices[2].value = x + rx * Math.cos(startAngle + sweepAngle);
            _vertices[3].value = y + ry * Math.sin(startAngle + sweepAngle);
            return;
        }

        var total_sweep = 0.0;
        var local_sweep = 0.0;
        var prev_sweep;
        _numVertices = 2;
        _cmd = PathCommands.CURVE4;
        var done = false;
        do
        {
            if(sweepAngle < 0.0)
            {
                prev_sweep  = total_sweep;
                local_sweep = -Math.PI * 0.5;
                total_sweep -= Math.PI * 0.5;
                if(total_sweep <= sweepAngle + bezierArcAngleEpsilon)
                {
                    local_sweep = sweepAngle - prev_sweep;
                    done = true;
                }
            }
            else
            {
                prev_sweep  = total_sweep;
                local_sweep =  Math.PI * 0.5;
                total_sweep += Math.PI * 0.5;
                if(total_sweep >= sweepAngle - bezierArcAngleEpsilon)
                {
                    local_sweep = sweepAngle - prev_sweep;
                    done = true;
                }
            }

            arcToBezier(x, y, rx, ry, startAngle, local_sweep, _vertices, _numVertices - 2);

            _numVertices += 6;
            startAngle += local_sweep;
        }
        while(!done && _numVertices < 26);
    }


    public function rewind(pathId:UInt):Void
    {
        _vertex = 0;
    }

    public function getVertex(x:FloatRef, y:FloatRef):UInt
    {
        if(_vertex >= _numVertices)
        {
            return PathCommands.STOP;
        }

        x = _vertices[_vertex];
        y = _vertices[_vertex + 1];
        _vertex += 2;

        return (_vertex == 2) ? PathCommands.MOVE_TO : _cmd;
    }

    public function numVertices(): UInt
    {
        return _numVertices;
    }
}