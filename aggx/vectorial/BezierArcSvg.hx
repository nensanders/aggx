package aggx.vectorial;

import aggx.core.geometry.Vector2D;
import aggx.core.math.Calc;
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Ref.FloatRef;

class BezierArcSvg
{

    var _start: Vector2D = new Vector2D();
    var _end: Vector2D = new Vector2D();
    var _radius: Vector2D = new Vector2D();
    var _angle: Float;
    var _isLargeArc: Bool;
    var _isSweepArc: Bool;

    public function new()
    {

    }

    public function init(x0: Float, y0: Float, rx: Float, ry: Float, angle: Float, isLargeArc: Bool, isSweepArc: Bool, x2: Float, y2: Float)
    {
        _start.setXY(x0, y0);
        _end.setXY(x2, y2);
        _radius.setXY(rx, ry);
        _isLargeArc = isLargeArc;
        _angle = angle;
        _isSweepArc = isSweepArc;
    }

    private static function calculateVectorAngle(ux: Float, uy: Float, vx: Float, vy: Float): Float
    {
        var ta = Math.atan2(uy, ux);
        var tb = Math.atan2(vy, vx);

        if (tb >= ta)
        {
            return tb - ta;
        }

        return Calc.PI2 - (ta - tb);
    }

    public function addToPath(storage: VectorPath)
    {
        if (Vector2D.distance(_start, _end) < Calc.VERTEX_DIST_EPSILON)
        {
            return;
        }

        if (Math.abs(_radius.x) <= Calc.INTERSECTION_EPSILON || Math.abs(_radius.y) <= Calc.INTERSECTION_EPSILON)
        {
            storage.lineTo(_end.x, _end.y);
            return;
        }

        var sinPhi: Float = Math.sin(_angle * Calc.PI180);
        var cosPhi: Float = Math.cos(_angle * Calc.PI180);
        var x1dash: Float = cosPhi * (_start.x - _end.x) / 2.0 + sinPhi * (_start.y - _end.y) / 2.0;
        var y1dash: Float = -sinPhi * (_start.x - _end.x) / 2.0 + cosPhi * (_start.y - _end.y) / 2.0;

        var root: Float;
        var numerator: Float = _radius.x * _radius.x * _radius.y * _radius.y -
            _radius.x * _radius.x * y1dash * y1dash -
            _radius.y * _radius.y * x1dash * x1dash;

        var rx = _radius.x;
        var ry = _radius.y;

        if (numerator < 0.0)
        {
            var s = Math.sqrt(1.0 - numerator / (_radius.x * _radius.x * _radius.y * _radius.y));
            rx *= s;
            ry *= s;
            root = 0.0;
        }
        else
        {
            root = ((_isLargeArc && _isSweepArc) || (!_isLargeArc && !_isSweepArc) ? -1.0 : 1.0);
            root *= Math.sqrt(numerator / (_radius.x * _radius.x * y1dash * y1dash + _radius.y * _radius.y * x1dash * x1dash));
        }

        var cxdash = root * rx * y1dash / ry;
        var cydash = -root * ry * x1dash / rx;

        var cx = cosPhi * cxdash - sinPhi * cydash + (_start.x + _end.x) / 2.0;
        var cy = sinPhi * cxdash + cosPhi * cydash + (_start.y + _end.y) / 2.0;

        var theta1 = calculateVectorAngle(1.0, 0.0, (x1dash - cxdash) / rx, (y1dash - cydash) / ry);
        var dtheta = calculateVectorAngle((x1dash - cxdash) / rx, (y1dash - cydash) / ry, (-x1dash - cxdash) / rx, (-y1dash - cydash) / ry);

        if (_isSweepArc && dtheta < 0)
        {
            dtheta += 2.0 * Math.PI;
        }
        else if (!_isSweepArc && dtheta > 0)
        {
            dtheta -= 2.0 * Math.PI;
        }

        var segments: Int = Math.ceil(Math.abs(dtheta / (Math.PI / 2.0)));
        var delta = dtheta / segments;
        var t = 8.0 / 3.0 * Math.sin(delta / 4.0) * Math.sin(delta / 4.0) / Math.sin(delta / 2.0);

        var startX = _start.x;
        var startY = _start.y;

        for (i in 0 ... segments)
        {
            var cosTheta1 = Math.cos(theta1);
            var sinTheta1 = Math.sin(theta1);
            var theta2 = theta1 + delta;
            var cosTheta2 = Math.cos(theta2);
            var sinTheta2 = Math.sin(theta2);

            var endpointX = cosPhi * rx * cosTheta2 - sinPhi * ry * sinTheta2 + cx;
            var endpointY = sinPhi * rx * cosTheta2 + cosPhi * ry * sinTheta2 + cy;

            var dx1 = t * (-cosPhi * rx * sinTheta1 - sinPhi * ry * cosTheta1);
            var dy1 = t * (-sinPhi * rx * sinTheta1 + cosPhi * ry * cosTheta1);

            var dxe = t * (cosPhi * rx * sinTheta2 + sinPhi * ry * cosTheta2);
            var dye = t * (sinPhi * rx * sinTheta2 - cosPhi * ry * cosTheta2);

            storage.curve4(startX + dx1, startY + dy1, endpointX + dxe, endpointY + dye, endpointX, endpointY);

            theta1 = theta2;
            startX = endpointX;
            startY = endpointY;
        }
    }
}