package lib.ha.svg;

import lib.ha.svg.SVGElement;
import lib.ha.svg.gradients.GradientManager;
import lib.ha.svg.gradients.SVGGradient;
import lib.ha.aggx.vectorial.PathFlags;
import lib.ha.aggx.vectorial.VectorPath;
import lib.ha.core.memory.Ref.FloatRef;
import lib.ha.core.memory.Ref.Ref;

class SVGData
{
    public var storage(default, null): VectorPath = new VectorPath();
    public var elementStorage(default, null): Array<SVGElement> = [];
    public var gradientManager(default, null): GradientManager = new GradientManager();

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
