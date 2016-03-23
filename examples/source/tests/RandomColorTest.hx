package tests;

import aggx.renderer.SolidScanlineRenderer;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.converters.ConvCurve;
import aggx.vectorial.VectorPath;
import aggx.core.geometry.AffineTransformer;
import aggx.color.RgbaColor;
import tests.utils.AssetLoader;
import aggx.core.memory.MemoryAccess;
import tests.meshTest.MeshTest;

class RandomColorTest extends MeshTest
{
    public override function testAggx(): Void
    {
        MemoryAccess.select(data);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));

        var pixelAligner = new AffineTransformer();
        pixelAligner.multiply(AffineTransformer.translator(.5, .5));
        var tr = 10.;
        var path = new VectorPath();

        path.moveTo(tr, tr);
        path.lineTo(pixelBufferWidth - tr, tr);
        path.lineTo(pixelBufferWidth - tr, pixelBufferHeight - tr);
        path.lineTo(tr, pixelBufferHeight - tr);
        path.curve4(pixelBufferWidth - tr, pixelBufferHeight - tr, pixelBufferWidth - tr, tr, tr, tr);

        path.closePolygon();

        path.transformAllPaths(pixelAligner);

        var curve = new ConvCurve(path);
        var stroke = new ConvStroke(curve);

        stroke.width = 0.3;
        rasterizer.addPath(stroke);

        scanlineRenderer.color = new RgbaColor(255, 0, 0, 255);
        SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);

        rasterizer.addPath(curve);
        scanlineRenderer.color = new RgbaColor(255, 0, 0, 20);
        SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
    }
}