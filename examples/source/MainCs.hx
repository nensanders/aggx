import aggx.vectorial.generators.VcgenDash;
import aggx.vectorial.converters.ConvDash;
import aggx.vectorial.Ellipse;
import aggx.renderer.SolidScanlineRenderer;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.RenderingBuffer;
import aggx.core.geometry.AffineTransformer;
import aggx.rasterizer.Scanline;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.svg.SVGData;
import aggx.svg.SVGRenderer;

class MainCs
{
    public static function main(): Void
    {
        var data = new SVGData();
        var render = new SVGRenderer();
        var rasterizer = new ScanlineRasterizer();
        var scanline = new Scanline();
        var svgRenderer = new SVGRenderer();
        var transform = new AffineTransformer();
        var renderingBuffer = new RenderingBuffer(512, 512, 4 * 512);
        var pixelFormatRenderer = new PixelFormatRenderer(renderingBuffer);
        var clippingRenderer = new ClippingRenderer(pixelFormatRenderer);
        var scanlineRenderer = new SolidScanlineRenderer(clippingRenderer);
        var ellipse = new Ellipse();
        var convDash = new ConvDash(null);
        var vcgenDash = new VcgenDash();

        render.render(data, rasterizer, scanline, clippingRenderer, transform, 1.0);
    }
}