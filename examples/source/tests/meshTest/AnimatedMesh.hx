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

import gl.GLDefines;
import gl.GL;
import types.Data;
import types.DataType;
import tests.utils.IMesh;

class AnimatedMesh implements IMesh
{
    inline static private var sizeOfFloat: Int = 4;
    inline static private var sizeOfShort: Int = 2;

    inline static private var positionAttributeCount: Int = 4;
    inline static private var colorAttributeCount: Int = 4;
    inline static private var texCoordAttributeCount: Int = 2;

    inline static private var positionAttributeIndex: Int = 0;
    inline static private var colorAttributeIndex: Int = 1;
    inline static private var texCoordAttributeIndex: Int = 2;

    inline static private var indexCount: Int = 6;

    public var width: Float = 2.0;
    public var height: Float = 2.0;
    public var uMultiplier: Float = 1.0;
    public var vMultiplier: Float = 1.0;

    private var vertexBufferData: Data;

    private var vertexBuffer: GLBuffer;
    private var indexBuffer: GLBuffer;

    public function new ()
    {
    }

    public function createBuffers(): Void
    {
        /// VertexBuffer also called Array Buffer

        var vertexCount: Int = 4;
        var vertexBufferSize: Int = vertexCount * (sizeOfFloat * positionAttributeCount + sizeOfFloat * colorAttributeCount + sizeOfFloat * texCoordAttributeCount);
        vertexBufferData = new Data(vertexBufferSize);
                                            //  x      y       z    w    r    g    b    a    u            v
        var vertexBufferValues: Array<Float> = [-width*0.5,   -height*0.5,    0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0,         vMultiplier,     // vertex 0
                                                width*0.5, height*0.5, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, uMultiplier, 0.0,             // vertex 1
                                                width*0.5, -height*0.5,    0.0, 1.0, 1.0, 1.0, 1.0, 1.0, uMultiplier, vMultiplier,     // vertex 2
                                                -width*0.5,   height*0.5, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0,         0.0];            // vertex 3

        vertexBufferData.writeFloatArray(vertexBufferValues, DataType.DataTypeFloat32);
        vertexBufferData.offset = 0;

        vertexBuffer = GL.createBuffer();
        GL.bindBuffer(GLDefines.ARRAY_BUFFER, vertexBuffer);
        GL.bufferData(GLDefines.ARRAY_BUFFER, vertexBufferData, GLDefines.DYNAMIC_DRAW);
        GL.bindBuffer(GLDefines.ARRAY_BUFFER, GL.nullBuffer);


        /// IndexBuffer also called Element (Array) Buffer

        var indexBufferSize: Int = indexCount * sizeOfShort;
        var indexBufferData: Data = new Data(indexBufferSize);

        var indexBufferValues: Array<Int> = [0, 1, 2, 0, 3, 1];  // These indices reference the vertices above.

        indexBufferData.writeIntArray(indexBufferValues, DataType.DataTypeUInt16);
        indexBufferData.offset = 0;

        indexBuffer = GL.createBuffer();
        GL.bindBuffer(GLDefines.ELEMENT_ARRAY_BUFFER, indexBuffer);
        GL.bufferData(GLDefines.ELEMENT_ARRAY_BUFFER, indexBufferData, GLDefines.STATIC_DRAW);
        GL.bindBuffer(GLDefines.ELEMENT_ARRAY_BUFFER, GL.nullBuffer);
    }

    public function updateBuffers(): Void
    {
        // Update width and height
        vertexBufferData.offset = 10 * sizeOfFloat;
        vertexBufferData.writeFloat(width, DataType.DataTypeFloat32);
        vertexBufferData.offset = 11 * sizeOfFloat;
        vertexBufferData.writeFloat(height, DataType.DataTypeFloat32);
        vertexBufferData.offset = 20 * sizeOfFloat;
        vertexBufferData.writeFloat(width, DataType.DataTypeFloat32);
        vertexBufferData.offset = 31 * sizeOfFloat;
        vertexBufferData.writeFloat(height, DataType.DataTypeFloat32);

        // Update texture coordinates
        vertexBufferData.offset = 9 * sizeOfFloat;
        vertexBufferData.writeFloat(vMultiplier, DataType.DataTypeFloat32);
        vertexBufferData.offset = 18 * sizeOfFloat;
        vertexBufferData.writeFloat(uMultiplier, DataType.DataTypeFloat32);
        vertexBufferData.offset = 28 * sizeOfFloat;
        vertexBufferData.writeFloat(uMultiplier, DataType.DataTypeFloat32);
        vertexBufferData.offset = 29 * sizeOfFloat;
        vertexBufferData.writeFloat(vMultiplier, DataType.DataTypeFloat32);

        vertexBufferData.offset = 0;

        GL.bindBuffer(GLDefines.ARRAY_BUFFER, vertexBuffer);
        var offset: Int = 0;
        // If it is the same size or smaller we override the already existing gpu memory with our updated data
        GL.bufferSubData(GLDefines.ARRAY_BUFFER, offset, vertexBufferData);
        GL.bindBuffer(GLDefines.ARRAY_BUFFER, GL.nullBuffer);
    }

    public function destroyBuffers(): Void
    {
        GL.deleteBuffer(indexBuffer);
        GL.deleteBuffer(vertexBuffer);
    }

    public function bindMesh(): Void
    {
        GL.bindBuffer(GLDefines.ARRAY_BUFFER, vertexBuffer);
        GL.bindBuffer(GLDefines.ELEMENT_ARRAY_BUFFER, indexBuffer);

        GL.enableVertexAttribArray(positionAttributeIndex); // 0
        GL.enableVertexAttribArray(colorAttributeIndex);    // 1
        GL.enableVertexAttribArray(texCoordAttributeIndex); // 2

        GL.disableVertexAttribArray(3);
        GL.disableVertexAttribArray(4);
        GL.disableVertexAttribArray(5);
        GL.disableVertexAttribArray(6);
        GL.disableVertexAttribArray(7);

        var stride: Int = positionAttributeCount * sizeOfFloat + colorAttributeCount * sizeOfFloat + texCoordAttributeCount * sizeOfFloat;

        var attributeOffset: Int = 0;
        GL.vertexAttribPointer(positionAttributeIndex, positionAttributeCount, GLDefines.FLOAT, false, stride, attributeOffset);

        attributeOffset = positionAttributeCount * sizeOfFloat;
        GL.vertexAttribPointer(colorAttributeIndex, colorAttributeCount, GLDefines.FLOAT, false, stride, attributeOffset);

        attributeOffset = positionAttributeCount * sizeOfFloat + colorAttributeCount * sizeOfFloat;
        GL.vertexAttribPointer(texCoordAttributeIndex, texCoordAttributeCount, GLDefines.FLOAT, false, stride, attributeOffset);
    }

    public function unbindMesh(): Void
    {
        GL.bindBuffer(GLDefines.ARRAY_BUFFER, GL.nullBuffer);
        GL.bindBuffer(GLDefines.ELEMENT_ARRAY_BUFFER, GL.nullBuffer);
    }

    public function draw(): Void
    {
        var indexOffset: Int = 0;
        GL.drawElements(GLDefines.TRIANGLES, indexCount, GLDefines.UNSIGNED_SHORT, indexOffset);
    }
}
