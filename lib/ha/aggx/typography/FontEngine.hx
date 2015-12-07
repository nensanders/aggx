//----------------------------------------------------------------------------
// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)
//
// Permission to copy, use, modify, sell and distribute this software 
// is granted provided this copyright notice appears in all copies. 
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//
// Haxe port by: Hypeartist hypeartist@gmail.com
// Copyright (C) 2011 https://code.google.com/p/aggx
//
//----------------------------------------------------------------------------
// Contact: mcseem@antigrain.com
//          mcseemagg@yahoo.com
//          http://www.antigrain.com
//----------------------------------------------------------------------------

package lib.ha.aggx.typography;
//=======================================================================================================
import lib.ha.aggx.vectorial.IVertexSource;
import lib.ha.aggx.vectorial.converters.ConvStroke;
import types.Vector2;
import haxe.Utf8;
import lib.ha.core.utils.Debug;
import lib.ha.aggx.rasterizer.GammaPower;
import lib.ha.aggx.rasterizer.Scanline;
import lib.ha.aggx.rasterizer.ScanlineRasterizer;
import lib.ha.aggx.renderer.IRenderer;
import lib.ha.aggx.renderer.SolidScanlineRenderer;
import lib.ha.aggx.vectorial.converters.ConvCurve;
import lib.ha.aggx.vectorial.VectorPath;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.rfpx.Glyph;
import lib.ha.rfpx.TrueTypeCollection;
import lib.ha.rfpx.TrueTypeFont;
//=======================================================================================================
class FontEngine
{
	private var _currentFontIndex:UInt;
	private var _flipY:Bool;
	private var _fontCollection:TrueTypeCollection;
	private var _path:VectorPath;
	private var _curve:ConvCurve;
	private var _stroke:ConvStroke;
    private var _typefaceCache:TypefaceCache;

    public var currentFont(default, null): TrueTypeFont;
    public var rasterizer: ScanlineRasterizer;
    public var scanline: Scanline;

	//---------------------------------------------------------------------------------------------------
	public function new(ttc:TrueTypeCollection, ?scanline: Scanline, ?rasterizer: ScanlineRasterizer)
	{
        _flipY = true;
        _fontCollection = ttc;
		_currentFontIndex = 0;
		currentFont = ttc.getFont(_currentFontIndex);
        this.rasterizer = rasterizer;
		this.scanline = scanline;
		_typefaceCache = new TypefaceCache(currentFont);
		_path = new VectorPath();
		_curve = new ConvCurve(_path);
		_curve.approximationScale = 4.0;
        _stroke = new ConvStroke(_curve);
	}
	//---------------------------------------------------------------------------------------------------
	public function preCacheFaces(fromCharCode:UInt, toCharCode:UInt):Void
	{
		while (fromCharCode < toCharCode)
		{
			var glyph = currentFont.getGlyphByCharCode(fromCharCode);
			var face = new Typeface(glyph, fromCharCode);
			_typefaceCache.cache(face);
			++fromCharCode;
		}
	}

	public function getScale(fontSize:Float):Float
	{
		return fontSize / currentFont.unitsPerEm;
	}

	public function vectorizeCharacter(charCode:UInt, fontSize: Float, dx:Float, dy:Float):Typeface
	{
		_path.removeAll();
		var i:UInt = 0;
		var x = 0.;
		var scale = fontSize / currentFont.unitsPerEm;
		var y = currentFont.ascender * scale;
		var face = _typefaceCache.getFace(charCode);
		face.getOutline(_path);
		var transform = AffineTransformer.scaler(scale, scale);
		transform.multiply(AffineTransformer.translator(dx, dy));
		_path.transformAllPaths(transform);
		return face;
	}

    public function getFace(charCode:UInt): Typeface
    {
        return _typefaceCache.getFace(charCode);
    }

	public function vectorizeString(string:String, fontSize:Float, dx:Float, dy:Float):Void
	{
		_path.removeAll();
		var i:UInt = 0;
		var c:UInt = Utf8.length(string);
		var x = 0.;
		var scale = fontSize / currentFont.unitsPerEm;
		var y = currentFont.ascender * scale;
		while (i < c)
		{

			var face = _typefaceCache.getFace(Utf8.charCodeAt(string, i));
			face.getOutline(_path);
			var transform = AffineTransformer.scaler(scale, scale);
			transform.multiply(AffineTransformer.translator(x + dx, y + dy));
			_path.transformAllPaths(transform);
			x += face.glyph.advanceWidth * scale;
			++i;
		}
	}

    public function measureString(string: String, fontSize: Float, vector: Vector2, kern: Float = 0.0)
    {
        var scale = fontSize / currentFont.unitsPerEm;
        var x: Float = 0;
        var y = currentFont.ascender * scale;

        for (i in 0 ... Utf8.length(string))
        {
            var face = _typefaceCache.getFace(Utf8.charCodeAt(string, i));
            x += face.glyph.advanceWidth * scale + kern;
        }

        vector.setXY(x, y);
    }

	public function renderString(string:String, fontSize:Float, dx:Float, dy:Float, renderer:IRenderer, kern: Float = 0.0, vector: Vector2 = null):Void
    {
        renderStringInternal(_curve, string, fontSize, dx, dy, renderer, kern, vector);
    }

    public function renderStringStroke(string:String, fontSize:Float, dx:Float, dy:Float, renderer:IRenderer, width: Float, kern: Float = 0.0, vector: Vector2 = null):Void
    {
        _stroke.width = width * fontSize / 100;
        trace('${_stroke.width}');
        
        renderStringInternal(_stroke, string, fontSize, dx, dy, renderer, kern, vector);
    }

    private function renderStringInternal(path: IVertexSource, string:String, fontSize:Float, dx:Float, dy:Float, renderer:IRenderer, kern: Float = 0.0, vector: Vector2 = null):Void
	{
        if (rasterizer == null)
        {
            rasterizer = new ScanlineRasterizer();
        }

        if (scanline == null)
        {
            scanline = new Scanline();
        }

		rasterizer.reset();
		rasterizer.gamma(new GammaPower(1));
		var i:UInt = 0;
        var c:UInt = Utf8.length(string);
		var x = 0.;
		var scale = fontSize / currentFont.unitsPerEm;
		var y = currentFont.ascender * scale;
		while (i < c)
		{
			var face = _typefaceCache.getFace(Utf8.charCodeAt(string, i));
			var transform = AffineTransformer.scaler(scale, scale);
			transform.multiply(AffineTransformer.translator(x + dx, y + dy));
			_path.removeAll();
			face.getOutline(_path);
			_path.transformAllPaths(transform);
			x += face.glyph.advanceWidth * scale + kern;
            rasterizer.addPath(path);

			++i;
		}

		SolidScanlineRenderer.renderScanlines(rasterizer, scanline, renderer);

        if (vector != null)
        {
            vector.setXY(x, y);
        }
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_path():VectorPath { return _path; }
	public var path(get, null):VectorPath;
}