package tests;

import aggx.vectorial.converters.ConvDash;
import aggx.color.RgbaColorF;
import aggx.renderer.ScanlineRenderer;
import aggx.color.SpanGradient;
import tests.aggxtest.AATest.ColorArray;
import aggx.color.SpanAllocator;
import aggx.color.SpanInterpolatorLinear;
import aggx.color.GradientX;
import aggx.vectorial.Ellipse;
import aggx.vectorial.LineCap;
import aggx.renderer.SolidScanlineRenderer;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.converters.ConvCurve;
import aggx.vectorial.VectorPath;
import aggx.core.geometry.AffineTransformer;
import aggx.color.RgbaColor;
import tests.utils.AssetLoader;
import aggx.core.memory.MemoryAccess;
import tests.meshTest.MeshTest;

class GradientTest extends MeshTest
{
    public override function testAggx(): Void
    {
        MemoryAccess.select(data);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));

        var pixelOffset = 0.5;
        var tr = 10.;

        var path = new VectorPath();

        path.removeAll();
        path.moveTo(tr + pixelOffset, tr + pixelOffset);
        path.lineTo(pixelBufferWidth + pixelOffset - tr, tr + pixelOffset);
        path.lineTo(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr);
        path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
        path.lineTo(tr + pixelOffset, pixelBufferHeight + pixelOffset - tr);
        path.curve4(pixelBufferWidth + pixelOffset - tr, pixelBufferHeight + pixelOffset - tr, pixelBufferWidth + pixelOffset - tr, pixelOffset + tr, pixelOffset + tr, pixelOffset + tr);
        path.closePolygon();

        var curve = new ConvCurve(path);
        var stroke0 = new ConvStroke(curve);

        var dash = new ConvDash(stroke0);
        var stroke = new ConvStroke(dash);

        stroke0.width = 5;
        stroke0.lineCap = LineCap.ROUND;

        dash.addDash(10, 10);

        stroke.width = 1;
        stroke.lineCap = LineCap.ROUND;

        //rasterizer.addPath(curve);

        var storage = new VectorPath();
        var ellipse = new Ellipse(50, 50, 50, 50);
        rasterizer.addPath(ellipse);

        scanlineRenderer.color = new RgbaColor(160, 180, 80, 80);
        SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);

        /*rasterizer.addPath(stroke);
        scanlineRenderer.color = new RgbaColor(120, 100, 0);
        SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);*/

        var gradientFunction = new GradientX();
        var gradientMatrix = new AffineTransformer();
        gradientMatrix.premultiply(AffineTransformer.translator(50, 0));
        gradientMatrix.invert();
        var spanInterpolator = new SpanInterpolatorLinear(gradientMatrix);
        var spanAllocator = new SpanAllocator();
        var gradientColors = new ColorArray(256);
        var gradientSpan = new SpanGradient(spanInterpolator, gradientFunction, gradientColors, 0, 100);
        var gradientRenderer = new ScanlineRenderer(clippingRenderer, spanAllocator, gradientSpan);

        var begin = new RgbaColorF(1, 0, 0).toRgbaColor();
        var end = new RgbaColorF(0, 1, 0).toRgbaColor();

        var i = 0;
        while (i < 256)
        {
            gradientColors.set(begin.gradient(end, i / 255.0), i);
            ++i;
        }

        SolidScanlineRenderer.renderScanlines(rasterizer, scanline, gradientRenderer);
    }
}