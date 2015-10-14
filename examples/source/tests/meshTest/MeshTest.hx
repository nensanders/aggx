/*
 * Copyright (c) 2011-2015, 2time.net | Sven Otto
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package tests.meshTest;

import lib.ha.aggx.vectorial.Ellipse;
import lib.ha.aggx.color.RgbaColorF;
import lib.ha.aggx.renderer.ScanlineRenderer;
import lib.ha.aggx.color.SpanGradient;
import lib.ha.aggx.color.SpanAllocator;
import lib.ha.aggx.color.SpanInterpolatorLinear;
import lib.ha.aggx.color.GradientX;
import lib.ha.aggx.vectorial.converters.ConvSegmentator;
import lib.ha.aggx.vectorial.converters.ConvAdaptorVcgen;
import lib.ha.aggx.vectorial.converters.ConvBSpline;
import lib.ha.aggx.vectorial.converters.ConvContour;
import lib.ha.aggx.vectorial.PathCommands;
import lib.ha.aggxtest.SVGTest;
import lib.ha.aggxtest.Circles;
import lib.ha.aggxtest.AATest;
import lib.ha.aggxtest.AADemo;
import lib.ha.aggxtest.AlphaGradient;
import lib.ha.aggxtest.TransCurve1;
import lib.ha.aggx.vectorial.LineCap;
import lib.ha.aggx.vectorial.converters.ConvDash;
import lib.ha.core.memory.MemoryAccess;
import lib.ha.aggx.vectorial.converters.ConvStroke;
import lib.ha.aggx.vectorial.converters.ConvCurve;
import lib.ha.aggx.vectorial.VectorPath;
import lib.ha.core.geometry.AffineTransformer;
import tests.utils.Bitmap;
import tests.utils.ImageDecoder;
import tests.utils.AssetLoader;
import duellkit.DuellKit;
import tests.utils.Shader;
import types.Data;
import gl.GL;
import gl.GLDefines;

import lib.ha.aggx.typography.FontEngine;
import lib.ha.rfpx.TrueTypeCollection;
import lib.ha.rfpx.TrueTypeLoader;
import lib.ha.aggx.color.RgbaColor;
import lib.ha.aggx.renderer.SolidScanlineRenderer;
import lib.ha.aggx.rasterizer.ScanlineRasterizer;
import lib.ha.aggx.rasterizer.Scanline;
import lib.ha.aggx.renderer.ClippingRenderer;
import lib.ha.aggx.renderer.PixelFormatRenderer;
import lib.ha.aggx.RenderingBuffer;
import lib.ha.core.memory.MemoryManager;
import lib.ha.core.memory.MemoryBlock;

class MeshTest extends OpenGLTest
{
    inline private static var IMAGE_PATH = "meshTest/images/lena.png";
    inline private static var FONT_PATH_ARIAL = "meshTest/fonts/arial.ttf";
    inline private static var FONT_PATH_COMIC = "meshTest/fonts/Pacifico.ttf";
    inline private static var FONT_PATH_JAPAN = "meshTest/fonts/font_1_ant-kaku.ttf";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/tiger.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/car.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/rect.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/rect_transform.svg";
    inline private static var VECTOR_PATH_TIGER = "meshTest/vector/rect_gradientTransform.svg";
    inline private static var VERTEXSHADER_PATH = "common/shaders/ScreenSpace_PosColorTex.vsh";
    inline private static var FRAGMENTSHADER_PATH = "common/shaders/ScreenSpace_PosColorTex.fsh";

    private var textureShader: Shader;
    private var animatedMesh: AnimatedMesh;

    static private var texture: GLTexture;

    //---------------------------------------------------------------------------------------------------
    static var pixelBufferWidth:UInt = 1024;
    static var pixelBufferHeight:UInt = 768;
    static var pixelBufferSize:UInt = pixelBufferWidth * pixelBufferHeight * 4;
    //---------------------------------------------------------------------------------------------------
    static var pixelBuffer:MemoryBlock = MemoryManager.malloc(pixelBufferSize);
    static var renderingBuffer = new RenderingBuffer(pixelBuffer, pixelBufferWidth, pixelBufferHeight, pixelBufferWidth * 4);
    static var pixelFormatRenderer = new PixelFormatRenderer(renderingBuffer);
    static var clippingRenderer = new ClippingRenderer(pixelFormatRenderer);
    static var scanline = new Scanline();
    static var rasterizer = new ScanlineRasterizer();
    static var scanlineRenderer = new SolidScanlineRenderer(clippingRenderer);

    static var enterFrame: Void -> Void = null;

    // Create OpenGL objectes (Shaders, Buffers, Textures) here
    override private function onCreate(): Void
    {
        super.onCreate();

        configureOpenGLState();
        createShader();
        createMesh();

        testAggx();

        createTexture();
    }

    // Destroy your created OpenGL objectes
    override public function onDestroy(): Void
    {
        destroyTexture();
        destroyMesh();
        destroyShader();

        super.onDestroy();
    }

    private function configureOpenGLState(): Void
    {
        GL.clearColor(0.0, 0.4, 0.6, 1.0);
    }

    private function createShader()
    {
        var vertexShader: String = AssetLoader.getStringFromFile(VERTEXSHADER_PATH);
        var fragmentShader: String = AssetLoader.getStringFromFile(FRAGMENTSHADER_PATH);

        textureShader = new Shader();
        textureShader.createShader(vertexShader, fragmentShader, ["a_Position", "a_Color", "a_TexCoord"], ["u_Tint", "s_Texture"]);
    }

    private function destroyShader(): Void
    {
        textureShader.destroyShader();
    }

    private function createMesh()
    {
        animatedMesh = new AnimatedMesh();
        animatedMesh.createBuffers();
    }

    private function destroyMesh()
    {
        animatedMesh.destroyBuffers();
    }

    private function createTexture(): Void
    {
        var data: Data = MemoryAccess.domainMemory;
        data.offset = pixelBuffer.start;
        data.offsetLength = pixelBufferSize;

        var bitmap: Bitmap = new Bitmap(data, pixelBufferWidth, pixelBufferHeight, 4);

        /// Create, configure and upload opengl texture

        texture = GL.createTexture();

        GL.bindTexture(GLDefines.TEXTURE_2D, texture);

        // Configure Filtering Mode
        GL.texParameteri(GLDefines.TEXTURE_2D, GLDefines.TEXTURE_MAG_FILTER, GLDefines.LINEAR);
        GL.texParameteri(GLDefines.TEXTURE_2D, GLDefines.TEXTURE_MIN_FILTER, GLDefines.LINEAR);

        // Configure wrapping
        GL.texParameteri(GLDefines.TEXTURE_2D, GLDefines.TEXTURE_WRAP_S, GLDefines.CLAMP_TO_EDGE);
        GL.texParameteri(GLDefines.TEXTURE_2D, GLDefines.TEXTURE_WRAP_T, GLDefines.CLAMP_TO_EDGE);

        // Copy data to gpu memory
        switch (bitmap.components)
        {
            case 3:
                {
                    GL.pixelStorei(GLDefines.UNPACK_ALIGNMENT, 2);
                    GL.texImage2D(GLDefines.TEXTURE_2D, 0, GLDefines.RGB, bitmap.width, bitmap.height, 0, GLDefines.RGB, GLDefines.UNSIGNED_SHORT_5_6_5, bitmap.data);
                }
            case 4:
                {
                    GL.pixelStorei(GLDefines.UNPACK_ALIGNMENT, 4);
                    GL.texImage2D(GLDefines.TEXTURE_2D, 0, GLDefines.RGBA, bitmap.width, bitmap.height, 0, GLDefines.RGBA, GLDefines.UNSIGNED_BYTE, bitmap.data);
                }
            case 1:
                {
                    GL.pixelStorei(GLDefines.UNPACK_ALIGNMENT, 1);
                    GL.texImage2D(GLDefines.TEXTURE_2D, 0, GLDefines.ALPHA, bitmap.width, bitmap.height, 0, GLDefines.ALPHA, GLDefines.UNSIGNED_BYTE, bitmap.data);
                }
            default: throw("Unsupported number of components");
        }

        GL.bindTexture(GLDefines.TEXTURE_2D, GL.nullTexture);
    }

    static private function reuploadTexture()
    {
        var data: Data = MemoryAccess.domainMemory;
        data.offset = pixelBuffer.start;
        data.offsetLength = pixelBufferSize;

        GL.bindTexture(GLDefines.TEXTURE_2D, texture);
       // GL.texImage2D(GLDefines.TEXTURE_2D, 0, GLDefines.RGBA, pixelBufferWidth, pixelBufferHeight, 0, GLDefines.RGBA, GLDefines.UNSIGNED_BYTE, data);
        GL.texSubImage2D(GLDefines.TEXTURE_2D, 0, 0, 0, pixelBufferWidth, pixelBufferHeight, GLDefines.RGBA, GLDefines.UNSIGNED_BYTE, data);
    }

    private function destroyTexture(): Void
    {
        GL.deleteTexture(texture);
    }

    private function testAggx(): Void
    {
        //clippingRenderer.setClippingBounds(0, 0, 512, 512);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));

        //t0();
        //t3();
        //t4();
        //t5();
        //t6();
        //t7();
        ///t8();
        //t9();
        //t10();
        t11();
        //t12();
    }

//---------------------------------------------------------------------------------------------------
    static function t0():Void
    {
        var loader = new TrueTypeLoader(AssetLoader.getDataFromFile(FONT_PATH_JAPAN));
        loader.load(t1);
        //loader.load(t2);
    }
//---------------------------------------------------------------------------------------------------
    static function t1(ttc:TrueTypeCollection):Void
    {
        var string1 = "ABCDEFGHJIKLMNOPQRSTUVWXYZ";
        var string2 = "abcdefghjiklmnopqrstuvwxyz";
        var string3 = "1234567890";
        var string4 = "!@#$%^&*()_+|{}:?><~`';/.,";
        var string5 = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦШЩЭЮЯ";
        var string6 = "абвгдеёжзийклмнопрстуфхцшщэюя";
        var japanString1 = '「ほのかアンティーク角」フォントは角ゴシックの漢字に合わせたウロコの付きの文字を組み合わせたアンチック体（アンティーク体）の日本語フォントです。';
        var japanString2 = '漢字等についてはオープンソースフォント「源柔ゴシック」を使用させて頂いております（詳細は後述）。';
        var japanString3 = '個人での利用のほか、商用利用においてデザイナーやクリエイターの方もご活用いただけます。';

        var fontEngine = new FontEngine(ttc);
        var fontSize = 80;

        scanlineRenderer.color = new RgbaColor(240, 27, 106);

        var x = 10;
        var y = 0 * fontSize / 20;

        fontEngine.renderString(string1, fontSize, x, y, scanlineRenderer);


        scanlineRenderer.color = new RgbaColor(27, 106, 240);

        var x = 10;
        var y = 20 * fontSize / 20;

        fontEngine.renderString(string2, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(227, 200, 26);

        var x = 10;
        var y = 40 * fontSize / 20;

        fontEngine.renderString(string3, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(106, 27, 240);

        var x = 10;
        var y = 60 * fontSize / 20;

        fontEngine.renderString(string4, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(136, 207, 100);

        var x = 10;
        var y = 80 * fontSize / 20;

        fontEngine.renderString(string5, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(136, 20, 50);

        var x = 10;
        var y = 100 * fontSize / 20;

        fontEngine.renderString(string6, fontSize, x, y, scanlineRenderer);

        var x = 10;
        var y = 120 * fontSize / 20;

        fontEngine.renderString(japanString1, fontSize, x, y, scanlineRenderer);

        var x = 10;
        var y = 140 * fontSize / 20;

        fontEngine.renderString(japanString2, fontSize, x, y, scanlineRenderer);

        var x = 10;
        var y = 160 * fontSize / 20;

        fontEngine.renderString(japanString3, fontSize, x, y, scanlineRenderer);
    }

//---------------------------------------------------------------------------------------------------
    static function t2(ttc:TrueTypeCollection):Void
    {
        var t = new TransCurve1(renderingBuffer, ttc);
        t.run();

        enterFrame = function()
        {
            clippingRenderer.clear(new RgbaColor(255, 255, 255));
            t.animate();
            reuploadTexture();
        }
    }

    //---------------------------------------------------------------------------------------------------
    static function t3():Void
    {
        var t = new AlphaGradient(renderingBuffer);

        t.run();
    }
    //---------------------------------------------------------------------------------------------------
    static function t4():Void
    {
        var t = new AADemo(renderingBuffer);
        t.run();
    }
    //---------------------------------------------------------------------------------------------------
    static function t5():Void
    {
        var t = new AATest(renderingBuffer);
        t.run();
    }

    static function t6():Void
    {
        var pixelOffset = 0.5;
        var pexelAligner = new AffineTransformer();
        pexelAligner.multiply(AffineTransformer.translator(.5, .5));
        var tr = 10.;
        var path = new VectorPath();

        path.moveTo(tr, tr);
        path.lineTo(pixelBufferWidth - tr, tr);
        path.lineTo(pixelBufferWidth - tr, pixelBufferHeight - tr);
        path.lineTo(tr, pixelBufferHeight - tr);
        path.curve4(pixelBufferWidth - tr, pixelBufferHeight - tr, pixelBufferWidth - tr, tr, tr, tr);

        path.closePolygon();

        path.transformAllPaths(pexelAligner);

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

//---------------------------------------------------------------------------------------------------
    static function t7():Void
    {
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
//---------------------------------------------------------------------------------------------------
    static function t8():Void
    {
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

//---------------------------------------------------------------------------------------------------
    static function t9():Void
    {
        var t = new Circles(renderingBuffer);
        t.run();
//blit();
        enterFrame = function()
        {
            t.animate();
            reuploadTexture();
        };
    }
//---------------------------------------------------------------------------------------------------
    static function t10():Void
    {
        var pixelOffset = 0.5;
        var pexelAligner = new AffineTransformer();
        pexelAligner.multiply(AffineTransformer.translator(.5, .5));

        var tr = 10.;
        var toCenter = true;

        var path = new VectorPath();
        path.transformAllPaths(pexelAligner);

        var curve = new ConvCurve(path);
        var dash = new ConvDash(curve);
        var stroke = new ConvStroke(dash);

        dash.addDash(10, 10);
        stroke.width = 7;

        enterFrame = function()
        {
            var r = Std.int(Math.random() * 255);
            var g = Std.int(Math.random() * 255);
            var b = Std.int(Math.random() * 255);
            var a = Std.int(Math.random() * 255);

            clippingRenderer.clear(new RgbaColor(255, 255, 255));
//t5();

            path.removeAll();

            path.moveTo(tr, tr);
            path.lineTo(pixelBufferWidth - tr, tr);
            path.lineTo(pixelBufferWidth - tr, pixelBufferHeight - tr);
            path.lineTo(tr, pixelBufferHeight - tr);
            path.lineTo(tr, tr);
            path.closePolygon();

            if (toCenter)
            {
                tr += 3;
                stroke.width -= 0.04;
                if (tr > pixelBufferHeight / 2)
                {
                    tr = pixelBufferHeight / 2;
                    toCenter = false;
                    stroke.width = 0.5;
                }
            }
            else
            {
                tr -= 3;
                stroke.width += 0.06;
                if (tr < 10.)
                {
                    tr = 10.;
                    toCenter = true;
                    stroke.width = 7;
                }
            }

            rasterizer.addPath(stroke);
            scanlineRenderer.color = new RgbaColor(g, r, b);
            SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);

            rasterizer.addPath(curve);
            scanlineRenderer.color = new RgbaColor(r, g, b, a);
            SolidScanlineRenderer.renderScanlines(rasterizer, scanline, scanlineRenderer);
//
            reuploadTexture();
//t6();
        };
    }

//---------------------------------------------------------------------------------------------------
    static function t11():Void
    {
        var t = new SVGTest(renderingBuffer, AssetLoader.getDataFromFile(VECTOR_PATH_TIGER));
        t.run();
    }

    private function update(deltaTime: Float, currentTime: Float)
    {
        if (enterFrame != null)
        {
            enterFrame();
        }

//        var tween = (Math.sin(currentTime * 0.5) + 1.0) / 2.0;
//
//        animatedMesh.width = 0.75 + 0.25 * tween;
//        animatedMesh.height = 1.0 - 0.25 * tween;
//
//        animatedMesh.uMultiplier = 1.0 + Math.sin(currentTime * 0.125);
//        animatedMesh.vMultiplier = 1.0 + Math.cos(currentTime * 0.125);
//
//        animatedMesh.updateBuffers();
    }

    override private function render()
    {
        GL.clear(GLDefines.COLOR_BUFFER_BIT);

        update(DuellKit.instance().frameDelta, DuellKit.instance().time);

        GL.useProgram(textureShader.shaderProgram);

        GL.uniform4f(textureShader.uniformLocations[0], 1.0, 1.0, 1.0, 1.0);

        GL.activeTexture(GLDefines.TEXTURE0);
        GL.bindTexture(GLDefines.TEXTURE_2D, texture);

        animatedMesh.bindMesh();

        animatedMesh.draw();

        animatedMesh.unbindMesh();
        GL.bindTexture(GLDefines.TEXTURE_2D, GL.nullTexture);
        GL.useProgram(GL.nullProgram);
    }
}