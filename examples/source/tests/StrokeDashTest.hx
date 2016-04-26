package tests;

import aggx.vectorial.LineCap;
import aggx.vectorial.converters.ConvDash;
import aggx.renderer.SolidScanlineRenderer;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.converters.ConvCurve;
import aggx.vectorial.VectorPath;
import aggx.core.geometry.AffineTransformer;
import aggx.color.RgbaColor;
import tests.utils.AssetLoader;
import aggx.core.memory.MemoryAccess;
import tests.meshTest.MeshTest;

class StrokeDashTest extends MeshTest
{
    public override function testAggx(): Void
    {
        MemoryAccess.select(data);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));

        var tr = 4.5;

        var path = new VectorPath();

        path.moveTo(tr, tr);
        path.lineTo(pixelBufferWidth-tr, tr);
        path.lineTo(pixelBufferWidth-tr, pixelBufferHeight-tr);
        path.lineTo(tr, pixelBufferHeight-tr);
        path.lineTo(tr, pixelBufferHeight-2*tr);
        path.curve4(pixelBufferWidth-2*tr, pixelBufferHeight-2*tr, pixelBufferWidth-2*tr, 2*tr,  tr, 2*tr);
        path.closePolygon();

        var curve = new ConvCurve(path);
        var dash = new ConvDash(curve);
        var stroke = new ConvStroke(dash);

        dash.addDash(50, 30);

        stroke.width = 5;
        stroke.lineCap = LineCap.SQUARE;
        rasterizer.addPath(curve);

        scanlineRenderer.color = new RgbaColor(255, 0, 0, 80);
        SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);

        rasterizer.reset();

        rasterizer.addPath(stroke);
        scanlineRenderer.color = new RgbaColor(255, 0, 0);
        SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
    }
}