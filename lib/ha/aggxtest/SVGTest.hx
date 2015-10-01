package lib.ha.aggxtest;

import lib.ha.aggx.vectorial.converters.ConvStroke;
import lib.ha.aggx.vectorial.converters.ConvCurve;
import lib.ha.aggx.vectorial.VectorPath;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.aggx.color.RgbaColor;
import lib.ha.svg.SVGParser;
import lib.ha.svg.SVGPathRenderer;
import types.Data;
import lib.ha.aggx.rasterizer.ScanlineRasterizer;
import lib.ha.aggx.rasterizer.Scanline;
import lib.ha.aggx.renderer.SolidScanlineRenderer;
import lib.ha.aggx.renderer.ClippingRenderer;
import lib.ha.aggx.renderer.PixelFormatRenderer;
import lib.ha.aggx.RenderingBuffer;

class SVGTest
{
//---------------------------------------------------------------------------------------------------
    private var _renderingBuffer:RenderingBuffer;
    private var _pixelFormatRenderer:PixelFormatRenderer;
    private var _clippingRenderer:ClippingRenderer;
    private var _scanlineRenderer:SolidScanlineRenderer;
    private var _scanline:Scanline;
    private var _rasterizer:ScanlineRasterizer;

    private var _path: SVGPathRenderer;

//---------------------------------------------------------------------------------------------------
    public function new(rbuf:RenderingBuffer, svgData: Data)
    {
        _renderingBuffer = rbuf;
        _pixelFormatRenderer = new PixelFormatRenderer(_renderingBuffer);
        _clippingRenderer = new ClippingRenderer(_pixelFormatRenderer);
        _scanline = new Scanline();
        _rasterizer = new ScanlineRasterizer();
        //_scanlineRenderer = new SolidScanlineRenderer(_clippingRenderer);

        _path = new SVGPathRenderer();

        parseSVG(svgData);
    }

    private function parseSVG(svgData: Data): Void
    {
        var parser: SVGParser = new SVGParser(_path);
        parser.parse(svgData);
        //_path.bounding_rect(0.0, 0.0, 0.0, 0.0);
    }

//---------------------------------------------------------------------------------------------------
    public function run():Void
    {
        draw();
    }
//---------------------------------------------------------------------------------------------------
    private function draw():Void
    {
        _clippingRenderer.clear(new RgbaColor(255, 255, 255, 255));

        var mtx: AffineTransformer = AffineTransformer.translator(0.0, 0.0);

        _path.expand(0.1); // Important value
        var alpha: Float = 1.0;
        _path.render(_rasterizer, _scanline, _clippingRenderer, mtx, alpha);
    }

}
