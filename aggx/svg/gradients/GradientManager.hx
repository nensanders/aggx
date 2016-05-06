package aggx.svg.gradients;

import aggx.color.GradientRadialFocus;
import aggx.color.SpanGradient.SpreadMethod;
import aggx.color.ColorArray;
import aggx.core.memory.Ref.FloatRef;
import aggx.core.memory.Ref;
import aggx.core.geometry.AffineTransformer;

class GradientManager
{
    private var _gradients: Map<String, SVGGradient> = new Map<String, SVGGradient>();
    private var _count: Int = 0;
    private var _bboxTransform: AffineTransformer = new AffineTransformer();
    private var _zeroFloatRef: FloatRef = Ref.getFloat();
    private var _oneFloatRef: FloatRef = Ref.getFloat();
    private var _halfFloatRef: FloatRef = Ref.getFloat();

    public function new()
    {
        _zeroFloatRef.value = 0;
        _oneFloatRef.value = 1;
        _halfFloatRef.value = 0.5;
    }

    public function removeAll(): Void
    {
        _gradients = new Map<String, SVGGradient>();
        _count = 0;
    }

    public function getGradient(id: String): SVGGradient
    {
        return _gradients.get(id);
    }

    public function addGradient(gradient: SVGGradient): Void
    {
        if (!_gradients.exists(gradient.id))
        {
            _count++;
        }

        _gradients.set(gradient.id, gradient);
    }

    public function getCount(): Int
    {
        return _count;
    }

    public function iterator()
    {
        return _gradients.iterator();
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

            if (cur.link != null)
            {
                cur = _gradients.get(cur.link);
            }
            else
            {
                cur = null;
            }

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

    private static var defaultTransform = new AffineTransformer();
    private function getGradientTransformation(id: String): AffineTransformer
    {
        var get = function (grad: SVGGradient){return grad.transform;};
        var set = function (grad: SVGGradient, transform: AffineTransformer){grad.transform = transform;};
        return gradientProperty(id, defaultTransform, get, set);
    }

    private static var useUserSpaceDefault: Null<Bool> = false;
    private function isUserspaceGradient(id: String): Bool
    {
        var get = function (grad: SVGGradient): Null<Bool> {return grad.userSpace;};
        var set = function (grad: SVGGradient, userspace: Null<Bool>){grad.userSpace = userspace;};
        var out: Null<Bool> = gradientProperty(id, useUserSpaceDefault, get, set);
        return out;
    }

    private function getGradientVectorElement(id: String, element: Int): FloatRef
    {
        var output: FloatRef = Ref.getFloat();
        var defaultValue: FloatRef = element == 2 ? _oneFloatRef : _zeroFloatRef;
        var get = function (grad: SVGGradient){return grad.gradientVector[element];};
        var set = function (grad: SVGGradient, value: FloatRef){grad.gradientVector[element] = value;};

        output.value = gradientProperty(id, defaultValue, get, set).value;
        return output;
    }

    private function getGradientFocalParameter(id: String, element: Int): FloatRef
    {
        var output: FloatRef = Ref.getFloat();

        var defaultValue: FloatRef = element == 2 ? _oneFloatRef : _zeroFloatRef;

        var get = function (grad: SVGGradient){return grad.focalGradientParameters[element];};
        var set = function (grad: SVGGradient, value: FloatRef){grad.focalGradientParameters[element] = value;};

        output.value = gradientProperty(id, defaultValue, get, set).value;
        return output;
    }

    private static var defaultSpread: Null<SpreadMethod> = SpreadMethod.Pad;
    public function getSpreadMethod(id: String): SpreadMethod
    {
        var get = function (grad: SVGGradient){return grad.spreadMethod;};
        var set = function (grad: SVGGradient, m: SpreadMethod){grad.spreadMethod = m;};

        var out: Null<SpreadMethod> = gradientProperty(id, defaultSpread, get, set);
        return out;
    }

    private function calculateBBoxTransform(bounds: SVGPathBounds, transform: AffineTransformer)
    {
        var bboxWidth: Float = bounds.maxX - bounds.minX;
        var bboxHeight: Float = bounds.maxY - bounds.minY;
        
        transform.multiply(AffineTransformer.scaler(bboxWidth, bboxHeight));
        transform.multiply(AffineTransformer.translator(bounds.minX, bounds.minY));
    }

    public function calculateRadialGradientParameters(gradientId: String,
                                                      bounds: SVGPathBounds,
                                                      transform: AffineTransformer,
                                                      output: AffineTransformer,
                                                      outputFunction: GradientRadialFocus): Void
    {
        var gradientTransform: AffineTransformer = getGradientTransformation(gradientId);
        var gradientD2: Float = 100;

        var cx: FloatRef = getGradientFocalParameter(gradientId, 0);
        var cy: FloatRef = getGradientFocalParameter(gradientId, 1);
        var r: FloatRef = getGradientFocalParameter(gradientId, 2);
        var fx: FloatRef = getGradientFocalParameter(gradientId, 3);
        var fy: FloatRef = getGradientFocalParameter(gradientId, 4);

        _bboxTransform.reset();
        if (!isUserspaceGradient(gradientId))
        {
            calculateBBoxTransform(bounds, _bboxTransform);
        }

        outputFunction.init(r.value, fx.value - cx.value, fy.value - cy.value);

        output.reset();
        output.multiply(AffineTransformer.scaler(r.value / gradientD2));
        output.multiply(AffineTransformer.translator(cx.value, cy.value));
        output.multiply(_bboxTransform);
        output.multiply(transform);
        output.multiply(gradientTransform);
        output.invert();
    }

    public function calculateLinearGradientTransform(gradientId: String,
                                                      bounds: SVGPathBounds,
                                                      transform: AffineTransformer,
                                                      output: AffineTransformer): Void
    {
        var gradientTransform: AffineTransformer = getGradientTransformation(gradientId);
        var gradientD2: Float = 100;

        var x1: FloatRef = getGradientVectorElement(gradientId, 0);
        var y1: FloatRef = getGradientVectorElement(gradientId, 1);
        var x2: FloatRef = getGradientVectorElement(gradientId, 2);
        var y2: FloatRef = getGradientVectorElement(gradientId, 3);

        //intentionally left here for debugging
        //trace('{${x1.value}, ${y1.value}} - {${x2.value}, ${y2.value}}');

        gradientTransform.transform(x1, y1);
        gradientTransform.transform(x2, y2);

        _bboxTransform.reset();
        if (!isUserspaceGradient(gradientId))
        {
            calculateBBoxTransform(bounds, _bboxTransform);
        }

        _bboxTransform.transform(x1, y1);
        _bboxTransform.transform(x2, y2);

        transform.transform(x1, y1);
        transform.transform(x2, y2);

        output.reset();
        var dx = x2.value - x1.value;
        var dy = y2.value - y1.value;

        var scale: Float = Math.sqrt(dx * dx + dy * dy) / gradientD2;

        output.multiply(AffineTransformer.scaler(scale));
        output.multiply(AffineTransformer.rotator(Math.atan2(dy, dx)));
        output.multiply(AffineTransformer.translator(x1.value, y1.value));

        output.invert();
    }
}