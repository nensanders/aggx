package tests.aggxtest;

import aggx.svg.SVGDataBuilder;
import aggx.svg.SVGRenderer;
import aggx.core.geometry.AffineTransformer;
import aggx.color.RgbaColor;
import aggx.svg.SVGParser;
import aggx.svg.SVGData;
import types.Data;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.rasterizer.Scanline;
import aggx.renderer.SolidScanlineRenderer;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.RenderingBuffer;

class SVGTest
{
//---------------------------------------------------------------------------------------------------
    private var _renderingBuffer:RenderingBuffer;
    private var _pixelFormatRenderer:PixelFormatRenderer;
    private var _clippingRenderer:ClippingRenderer;
    private var _scanlineRenderer:SolidScanlineRenderer;
    private var _scanline:Scanline;
    private var _rasterizer:ScanlineRasterizer;

    private var _path: SVGDataBuilder;
    private var _svgRenderer: SVGRenderer;

//---------------------------------------------------------------------------------------------------
    public function new(rbuf:RenderingBuffer, svgData: Data)
    {
        _renderingBuffer = rbuf;
        _pixelFormatRenderer = new PixelFormatRenderer(_renderingBuffer);
        _clippingRenderer = new ClippingRenderer(_pixelFormatRenderer);
        _scanline = new Scanline();
        _rasterizer = new ScanlineRasterizer();
        _svgRenderer = new SVGRenderer();
        //_scanlineRenderer = new SolidScanlineRenderer(_clippingRenderer);

        _path = new SVGDataBuilder();

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

        _path.data.expandValue = 0.1;
        var alpha: Float = 1.0;

        _svgRenderer.render(_path.data, _rasterizer, _scanline, _clippingRenderer, mtx, alpha);
    }

}
