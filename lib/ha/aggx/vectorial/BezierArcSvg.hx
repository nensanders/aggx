package lib.ha.aggx.vectorial;

import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.memory.Ref.FloatRef;
class BezierArcSvg implements IVertexSource
{
    public var _radiiOk(default, null): Bool = false;
    var _bezierArc: BezierArc = new BezierArc();

    public function new()
    {

    }

    public function init(x0: Float, y0: Float, rx: Float, ry: Float, angle: Float, isLargeArc: Bool, isSweepArc: Bool, x2: Float, y2: Float)
    {
        _radiiOk = true;

        if(rx < 0.0) rx = -rx;
        if(ry < 0.0) ry = -rx;

        // Calculate the middle point between
        // the current and the final points
        //------------------------
        var dx2: Float = (x0 - x2) / 2.0;
        var dy2: Float = (y0 - y2) / 2.0;

        var cos_a: Float = Math.cos(angle);
        var sin_a: Float = Math.sin(angle);

        // Calculate (x1, y1)
        //------------------------
        var x1: Float =  cos_a * dx2 + sin_a * dy2;
        var y1: Float = -sin_a * dx2 + cos_a * dy2;

        // Ensure radii are large enough
        //------------------------
        var prx: Float = rx * rx;
        var pry: Float = ry * ry;
        var px1: Float = x1 * x1;
        var py1: Float = y1 * y1;

        // Check that radii are large enough
        //------------------------
        var radii_check: Float = px1/prx + py1/pry;
        if(radii_check > 1.0)
        {
            rx = Math.sqrt(radii_check) * rx;
            ry = Math.sqrt(radii_check) * ry;
            prx = rx * rx;
            pry = ry * ry;
            if(radii_check > 10.0)
            {
                _radiiOk = false;
            }
        }

        // Calculate (cx1, cy1)
        //------------------------
        var sign: Float = (isLargeArc == isSweepArc) ? -1.0 : 1.0;
        var sq: Float   = (prx*pry - prx*py1 - pry*px1) / (prx*py1 + pry*px1);
        var coef: Float = sign * Math.sqrt((sq < 0) ? 0 : sq);
        var cx1: Float  = coef *  ((rx * y1) / ry);
        var cy1: Float  = coef * -((ry * x1) / rx);

        //
        // Calculate (cx, cy) from (cx1, cy1)
        //------------------------
        var sx2: Float = (x0 + x2) / 2.0;
        var sy2: Float = (y0 + y2) / 2.0;
        var cx: Float = sx2 + (cos_a * cx1 - sin_a * cy1);
        var cy: Float = sy2 + (sin_a * cx1 + cos_a * cy1);

        // Calculate the start_angle (angle1) and the sweep_angle (dangle)
        //------------------------
        var ux: Float =  (x1 - cx1) / rx;
        var uy: Float =  (y1 - cy1) / ry;
        var vx: Float = (-x1 - cx1) / rx;
        var vy: Float = (-y1 - cy1) / ry;
        var p: Float, n: Float;

        // Calculate the angle start
        //------------------------
        n = Math.sqrt(ux*ux + uy*uy);
        p = ux; // (1 * ux) + (0 * uy)
        sign = (uy < 0) ? -1.0 : 1.0;
        var v: Float = p / n;
        if(v < -1.0) v = -1.0;
        if(v >  1.0) v =  1.0;
        var start_angle: Float = sign * Math.acos(v);

        // Calculate the sweep angle
        //------------------------
        n = Math.sqrt((ux*ux + uy*uy) * (vx*vx + vy*vy));
        p = ux * vx + uy * vy;
        sign = (ux * vy - uy * vx < 0) ? -1.0 : 1.0;
        v = p / n;
        if(v < -1.0) v = -1.0;
        if(v >  1.0) v =  1.0;
        var sweep_angle: Float = sign * Math.acos(v);
        if(!isSweepArc && sweep_angle > 0)
        {
            sweep_angle -= Math.PI * 2.0;
        }
        else if (isSweepArc && sweep_angle < 0)
        {
            sweep_angle += Math.PI * 2.0;
        }

        // We can now build and transform the resulting arc
        //------------------------
        _bezierArc.init(0.0, 0.0, rx, ry, start_angle, sweep_angle);

        var mtx: AffineTransformer = AffineTransformer.rotator(angle);
        mtx.multiply(AffineTransformer.translator(cx, cy));

        /*for(unsigned i = 2; i < m_arc.num_vertices()-2; i += 2)
        {
            mtx.transform(m_arc.vertices() + i, m_arc.vertices() + i + 1);
        }*/

        var i: UInt = 2;
        while (i < _bezierArc.numVertices() - 2)
        {
            mtx.transform(_bezierArc._vertices[i], _bezierArc._vertices[i + 1]);
            i += 2;
        }

        // We must make sure that the starting and ending points
        // exactly coincide with the initial (x0,y0) and (x2,y2)
        _bezierArc._vertices[0].value = x0;
        _bezierArc._vertices[1].value = y0;
        if(_bezierArc.numVertices() > 2)
        {
            var num = _bezierArc.numVertices();
            _bezierArc._vertices[num - 2].value = x2;
            _bezierArc._vertices[num - 1].value = y2;
        }
    }

    public function rewind(pathId:UInt):Void
    {
        return _bezierArc.rewind(pathId);
    }

    public function getVertex(x:FloatRef, y:FloatRef):UInt
    {
        return _bezierArc.getVertex(x, y);
    }
}