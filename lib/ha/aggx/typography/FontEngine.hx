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
	private var _currentFont:TrueTypeFont;
	private var _scanline:Scanline;
	private var _rasterizerizer:ScanlineRasterizer;
	private var _typefaceCache:TypefaceCache;
	private var _path:VectorPath;
	private var _curve:ConvCurve;
	//---------------------------------------------------------------------------------------------------
	public function new(ttc:TrueTypeCollection) 
	{
        _flipY = true;
        _fontCollection = ttc;
		_currentFontIndex = 0;
		_currentFont = ttc.getFont(_currentFontIndex);
		_rasterizerizer = new ScanlineRasterizer();
		_scanline = new Scanline();
		_typefaceCache = new TypefaceCache(_currentFont);
		_path = new VectorPath();
		_curve = new ConvCurve(_path);
		_curve.approximationScale = 4.0;
	}
	//---------------------------------------------------------------------------------------------------
	public function preCacheFaces(fromCharCode:UInt, toCharCode:UInt):Void
	{
		while (fromCharCode < toCharCode)
		{
			var glyph = _currentFont.getGlyphByCharCode(fromCharCode);
			var face = new Typeface(glyph, fromCharCode);
			_typefaceCache.cache(face);
			++fromCharCode;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function getScale(fontSize:Float):Float
	{
		return fontSize / _currentFont.unitsPerEm;
	}
	//---------------------------------------------------------------------------------------------------
	public function vectorizeCharacter(charCode:UInt, fontSize, dx:Float, dy:Float):Typeface
	{
		_path.removeAll();
		var i:UInt = 0;
		var x = 0.;
		var scale = fontSize / _currentFont.unitsPerEm;
		var y = _currentFont.ascender * scale;
		var face = _typefaceCache.getFace(charCode);
		face.getOutline(_path);
		var transform = AffineTransformer.scaler(scale, scale);
		transform.multiply(AffineTransformer.translator(dx, dy));
		_path.transformAllPaths(transform);
		return face;
	}
	//---------------------------------------------------------------------------------------------------
	public function vectorizeString(string:String, fontSize:Float, dx:Float, dy:Float):Void
	{
		_path.removeAll();
		var i:UInt = 0;
		var c:UInt = string.length;
		var x = 0.;
		var scale = fontSize / _currentFont.unitsPerEm;
		var y = _currentFont.ascender * scale;
		while (i < c)
		{
			var face = _typefaceCache.getFace(string.charCodeAt(i));
			face.getOutline(_path);
			var transform = AffineTransformer.scaler(scale, scale);
			transform.multiply(AffineTransformer.translator(x + dx, y + dy));
			_path.transformAllPaths(transform);
			x += face.glyph.advanceWidth * scale;
			++i;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function renderString(string:String, fontSize:Float, dx:Float, dy:Float, renderer:IRenderer):Void
	{
		_rasterizerizer.reset();
		_rasterizerizer.gamma(new GammaPower(1));
		var i:UInt = 0;
		var c:UInt = string.length;
		var x = 0.;
		var scale = fontSize / _currentFont.unitsPerEm;
		var y = _currentFont.ascender * scale;

		while (i < string.length)
		{
			var face = _typefaceCache.getFace(string.charCodeAt(i));
			var transform = AffineTransformer.scaler(scale, scale);
			transform.multiply(AffineTransformer.translator(x + dx, y + dy));
			_path.removeAll();
			face.getOutline(_path);
			_path.transformAllPaths(transform);
			x += face.glyph.advanceWidth * scale;
			_rasterizerizer.addPath(_curve);

			++i;
		}

		SolidScanlineRenderer.renderScanlines(_rasterizerizer, _scanline, renderer);
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_path():VectorPath { return _path; }
	public var path(get, null):VectorPath;
}