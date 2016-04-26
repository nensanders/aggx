package aggx.svg;

import aggx.svg.SVGElement;
import aggx.svg.gradients.GradientManager;
import aggx.svg.gradients.SVGGradient;
import aggx.vectorial.PathFlags;
import aggx.vectorial.VectorPath;
import aggx.core.memory.Ref.FloatRef;
import aggx.core.memory.Ref.Ref;
import types.RectF;

class SVGData
{
    public var storage(default, null): VectorPath = new VectorPath();
    public var elementStorage: Array<SVGElement> = [];
    public var gradientManager(default, null): GradientManager = new GradientManager();
    public var viewBox: RectF = new RectF();

    public var expandValue: Float = 0;

    public function new()
    {

    }

    public function removeAll(): Void
    {
        storage.removeAll();
        elementStorage = [];
        gradientManager.removeAll();
    }

    // Make all polygons CCW-oriented
    public function arrange_orientations(): Void
    {
        storage.arrangeOrientationsAllPaths(PathFlags.CCW);
    }

    public function addGradient(gradient: SVGGradient): Void
    {
        gradientManager.addGradient(gradient);
    }
}
