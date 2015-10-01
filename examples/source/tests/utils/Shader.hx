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

package tests.utils;

import gl.GLDefines;
import gl.GL;

class Shader
{
    public var shaderProgram(default, null): GLProgram;

    public var attributes(default, null): Array<String>;
    public var uniformLocations(default, null): Array<GLUniformLocation>;

    public var isLoaded(default, null): Bool;

    public function new()
    {
        this.isLoaded = false;
        this.attributes = [];
        this.uniformLocations = [];
    }

    public function createShader(vertexShader: String, fragmentShader: String, attributes: Array<String>, uniforms: Array<String>): Bool
    {
        if (isLoaded)
        {
            return true;
        }

        /// COMPILE

        var vs = compileShader(GLDefines.VERTEX_SHADER, vertexShader);

        if(vs == GL.nullShader)
        {
            trace("Failed to compile vertex shader");
            return false;
        }

        var fs = compileShader(GLDefines.FRAGMENT_SHADER, fragmentShader);

        if(fs == GL.nullShader)
        {
            trace("Failed to compile fragment shader");
            return false;
        }

        /// CREATE

        shaderProgram = GL.createProgram();
        GL.attachShader(shaderProgram, vs);
        GL.attachShader(shaderProgram, fs);

        /// BIND ATTRIBUTE LOCATIONS

        this.attributes = attributes;

        for (i in 0...attributes.length)
        {
            GL.bindAttribLocation(shaderProgram, i, attributes[i]);
        }

        /// LINK

        if(!linkShader(shaderProgram))
        {
            trace("Failed to link program");

            if(vs != GL.nullShader)
            {
                GL.deleteShader(vs);
            }
            if(fs != GL.nullShader)
            {
                GL.deleteShader(fs);
            }

            GL.deleteProgram(shaderProgram);
            return false;
        }

        /// BIND UNIFORM LOCATIONS

        for (uniform in uniforms)
        {
            var uniformLocation = GL.getUniformLocation(shaderProgram, uniform);

            if(uniformLocation == GL.nullUniformLocation)
            {
                trace("Failed to link uniform " + uniform + " in shader");
                return false;
            }

            uniformLocations.push(uniformLocation);
        }

        /// CLEANUP

        if(vs != GL.nullShader)
        {
            GL.detachShader(shaderProgram, vs);
            GL.deleteShader(vs);
        }
        if(fs != GL.nullShader)
        {
            GL.detachShader(shaderProgram, fs);
            GL.deleteShader(fs);
        }

        isLoaded = true;
        return true;
    }

    private function compileShader(type: Int, code: String): GLShader
    {
        var s = GL.createShader(type);
        GL.shaderSource(s, code);
        GL.compileShader(s);

        #if debug
        var log = GL.getShaderInfoLog(s);
        if(log.length > 0)
        {
            trace("Shader log:");
            trace(log);
        }
        #end

        if(GL.getShaderParameter(s, GLDefines.COMPILE_STATUS) != cast 1 )
        {
            GL.deleteShader(s);
            return GL.nullShader;
        }
        return s;
    }

    private function linkShader(shaderProgramName: GLProgram): Bool
    {
        GL.linkProgram(shaderProgramName);

        #if debug
        var log = GL.getProgramInfoLog(shaderProgramName);
        if(log.length > 0)
        {
            trace("Shader program log:");
            trace(log);
        }
        #end

        if(GL.getProgramParameter(shaderProgramName, GLDefines.LINK_STATUS) == 0)
            return false;
        return true;
    }

    public function destroyShader(): Void
    {
        if (isLoaded)
        {
            GL.deleteProgram(shaderProgram);
            isLoaded = false;
        }
    }

}
