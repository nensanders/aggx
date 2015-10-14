package lib.ha.svg.gradients;

import lib.ha.aggxtest.AATest.ColorArray;
import lib.ha.core.memory.Ref.FloatRef;
import lib.ha.core.memory.Ref;
import lib.ha.core.geometry.AffineTransformer;

class GradientManager
{
    private var _gradients: Map<String, SVGGradient> = new Map<String, SVGGradient>();

    public function new()
    {

    }

    public function getGradient(id: String): SVGGradient
    {
        return _gradients.get(id);
    }

    public function addGradient(gradient: SVGGradient): Void
    {
        _gradients.set(gradient.id, gradient);
    }

    private function eachGradiendAncestor(id: String, callback: SVGGradient -> Bool): Int
    {
        var iteration: Int = 0;
        var cur: SVGGradient = _gradients.get(id);
        while (cur != null)
        {
            if (!callback(cur))
            {
                return iteration;
                break;
            }

            cur = _gradients.get(cur.link);
            iteration++;
        }

        return iteration;
    }

    @:generic private function gradientProperty<T>(id: String, def: T, get: SVGGradient -> T, set: SVGGradient -> T -> Void): T
    {
        var value: T = null;

        var depth: Int = eachGradiendAncestor(id, function(grad: SVGGradient)
        {
            var current: T = get(grad);
            if (current != null)
            {
                value = current;
                return false;
            }

            return true;
        });

        if (value == null)
        {
            value = def;
        }

        if (depth != 0)
        {
            var gradient: SVGGradient = _gradients.get(id);
            set(gradient, value);
        }

        return value;
    }

    public function getGradientColors(id: String): ColorArray
    {
        var get = function (grad: SVGGradient){return grad.gradientColors;};
        var set = function (grad: SVGGradient, colors: ColorArray){grad.gradientColors = colors;};
        return gradientProperty(id, null, get, set);
    }

    public function getGradientTransformation(id: String): AffineTransformer
    {
        var get = function (grad: SVGGradient){return grad.transform;};
        var set = function (grad: SVGGradient, transform: AffineTransformer){grad.transform = transform;};
        return gradientProperty(id, defaultTransform, get, set);
    }
    private static var defaultTransform = new AffineTransformer();

    public function calculateLinearGradientTransform(gradinetId: String,
                                                      bounds: SVGPathBounds,
                                                      transform: AffineTransformer,
                                                      output: AffineTransformer): Void
    {
        var gradientTransform: AffineTransformer = getGradientTransformation(gradinetId);
        var gradientD2: Float = 100;

        var x1: FloatRef = Ref.getFloat();
        var y1: FloatRef = Ref.getFloat();
        var x2: FloatRef = Ref.getFloat();
        var y2: FloatRef = Ref.getFloat();

        x1.value = 0;
        x2.value = 1;
        y1.value = 0;
        y2.value = 0;

//trace('{${x1.value}, ${y1.value}} - {${x2.value}, ${y2.value}}');

        gradientTransform.transform(x1, y1);
        gradientTransform.transform(x2, y2);

//trace('{${x1.value}, ${y1.value}} - {${x2.value}, ${y2.value}}');

        var bboxWidth: Float = bounds.maxX - bounds.minX;
        var bboxHeight: Float = bounds.maxY - bounds.minY;

        x1.value = bounds.minX + x1.value * bboxWidth;
        x2.value = bounds.minX + x2.value * bboxWidth;
        y1.value = bounds.minY + y1.value * bboxHeight;
        y2.value = bounds.minY + y2.value * bboxHeight;

//trace('{${x1.value}, ${y1.value}} - {${x2.value}, ${y2.value}}');

        transform.transform(x1, y1);
        transform.transform(x2, y2);

//trace('{${x1.value}, ${y1.value}} - {${x2.value}, ${y2.value}}');

        output.reset();
        var dx = x2.value - x1.value;
        var dy = y2.value - y1.value;

        var scale: Float = Math.sqrt(dx * dx + dy * dy) / gradientD2;
//trace('{${x1.value}, ${y1.value}} - {${x2.value}, ${y2.value}} scale:$scale');

        output.multiply(AffineTransformer.scaler(scale));
        output.multiply(AffineTransformer.rotator(Math.atan2(dy, dx)));
        output.multiply(AffineTransformer.translator(x1.value, y1.value));

        output.invert();
    }
}