import lib.ha.aggx.renderer.SolidScanlineRenderer;
import lib.ha.aggx.renderer.ClippingRenderer;
import lib.ha.aggx.renderer.PixelFormatRenderer;
import lib.ha.aggx.RenderingBuffer;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.aggx.rasterizer.Scanline;
import lib.ha.aggx.rasterizer.ScanlineRasterizer;
import lib.ha.svg.SVGData;
import lib.ha.svg.SVGRenderer;

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

        render.render(data, rasterizer, scanline, clippingRenderer, transform, 1.0);
    }
}