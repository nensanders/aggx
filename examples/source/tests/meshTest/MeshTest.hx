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

import aggx.vectorial.Ellipse;
import aggx.color.RgbaColorF;
import aggx.renderer.ScanlineRenderer;
import aggx.color.SpanGradient;
import aggx.color.SpanAllocator;
import aggx.color.SpanInterpolatorLinear;
import aggx.color.GradientX;
import aggx.vectorial.converters.ConvSegmentator;
import aggx.vectorial.converters.ConvAdaptorVcgen;
import aggx.vectorial.converters.ConvBSpline;
import aggx.vectorial.converters.ConvContour;
import aggx.vectorial.PathCommands;
import tests.aggxtest.SVGTest;
import tests.aggxtest.Circles;
import tests.aggxtest.AATest;
import tests.aggxtest.AADemo;
import tests.aggxtest.AlphaGradient;
import tests.aggxtest.TransCurve1;
import aggx.vectorial.LineCap;
import aggx.vectorial.converters.ConvDash;
import aggx.core.memory.MemoryAccess;
import aggx.vectorial.converters.ConvStroke;
import aggx.vectorial.converters.ConvCurve;
import aggx.vectorial.VectorPath;
import aggx.core.geometry.AffineTransformer;
import tests.utils.Bitmap;
import tests.utils.ImageDecoder;
import tests.utils.AssetLoader;
import duellkit.DuellKit;
import tests.utils.Shader;
import types.Data;
import gl.GL;
import gl.GLDefines;

import aggx.typography.FontEngine;
import aggx.rfpx.TrueTypeCollection;
import aggx.rfpx.TrueTypeLoader;
import aggx.color.RgbaColor;
import aggx.renderer.SolidScanlineRenderer;
import aggx.rasterizer.ScanlineRasterizer;
import aggx.rasterizer.Scanline;
import aggx.renderer.ClippingRenderer;
import aggx.renderer.PixelFormatRenderer;
import aggx.RenderingBuffer;

class MeshTest extends OpenGLTest
{
    inline private static var VERTEXSHADER_PATH = "common/shaders/ScreenSpace_PosColorTex.vsh";
    inline private static var FRAGMENTSHADER_PATH = "common/shaders/ScreenSpace_PosColorTex.fsh";

    private var textureShader: Shader;
    private var animatedMesh: AnimatedMesh;

    static private var texture: GLTexture;

    //---------------------------------------------------------------------------------------------------
    public var pixelBufferWidth:UInt = 1024;
    public var pixelBufferHeight:UInt = 768;
    public var pixelBufferSize:UInt = 1024 * 768 * 4;
    //---------------------------------------------------------------------------------------------------

    var data: Data;
    var renderingBuffer: RenderingBuffer;
    var pixelFormatRenderer: PixelFormatRenderer;
    var clippingRenderer: ClippingRenderer;
    var scanline: Scanline;
    var rasterizer: ScanlineRasterizer;
    var scanlineRenderer: SolidScanlineRenderer;

    public var enterFrame: Void -> Void = null;

    // Create OpenGL objectes (Shaders, Buffers, Textures) here
    override private function onCreate(): Void
    {
        super.onCreate();

        data = new Data(pixelBufferSize);
        renderingBuffer = new RenderingBuffer(pixelBufferWidth, pixelBufferHeight, pixelBufferWidth * 4);
        pixelFormatRenderer = new PixelFormatRenderer(renderingBuffer);
        clippingRenderer = new ClippingRenderer(pixelFormatRenderer);
        scanline = new Scanline();
        rasterizer = new ScanlineRasterizer();
        scanlineRenderer = new SolidScanlineRenderer(clippingRenderer);

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

        bitmap.data.offset = 0;
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

    private function reuploadTexture()
    {
        var data: Data = MemoryAccess.domainMemory;
        data.offset = 0;
        data.offsetLength = pixelBufferSize;

        GL.bindTexture(GLDefines.TEXTURE_2D, texture);
       // GL.texImage2D(GLDefines.TEXTURE_2D, 0, GLDefines.RGBA, pixelBufferWidth, pixelBufferHeight, 0, GLDefines.RGBA, GLDefines.UNSIGNED_BYTE, data);
        GL.texSubImage2D(GLDefines.TEXTURE_2D, 0, 0, 0, pixelBufferWidth, pixelBufferHeight, GLDefines.RGBA, GLDefines.UNSIGNED_BYTE, data);
    }

    private function destroyTexture(): Void
    {
        GL.deleteTexture(texture);
    }

    public function testAggx(): Void
    {
        throw "not implemented";
    }

    private function update(deltaTime: Float, currentTime: Float)
    {
        if (enterFrame != null)
        {
            enterFrame();
        }
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