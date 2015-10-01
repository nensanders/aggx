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

package tests;

import gl.GL;
import gl.GLDefines;

import duellkit.DuellKit;

class OpenGLTest
{
    public function new()
    {
        resetOpenGLState();
        onCreate();
    }

    // OpenGL behaves like a state machine. To be sure about the initial state, we set it.
    public function resetOpenGLState(): Void
    {
        GL.enable(GLDefines.BLEND);
        GL.blendFunc(GLDefines.SRC_ALPHA, GLDefines.ONE_MINUS_SRC_ALPHA);
        //GL.blendFunc(GLDefines.ONE, GLDefines.ONE_MINUS_SRC_ALPHA); // This is the correct blend function if your textures have premultiplied alpha

        GL.depthFunc(GLDefines.LEQUAL);
        GL.depthMask(false);
        GL.disable(GLDefines.DEPTH_TEST);

        GL.disable(GLDefines.STENCIL_TEST);

        GL.stencilFunc(GLDefines.ALWAYS, 0, 0xFF);
        GL.stencilOp(GLDefines.KEEP, GLDefines.KEEP, GLDefines.KEEP);
        GL.stencilMask(0xFF);

        GL.frontFace(GLDefines.CW);

        GL.enable(GLDefines.CULL_FACE);
        GL.cullFace(GLDefines.BACK);

        GL.disable(GLDefines.SCISSOR_TEST);

        GL.clearColor(0.0, 0.0, 0.0, 1.0);

        // There are even more states to set
    }

    // Override and call super();
    private function onCreate(): Void
    {
        DuellKit.instance().onRender.add(render);
    }

    // Needs to be called from the outside, since we are in a garbage collected environment
    public function onDestroy(): Void
    {
        // Override and call super();
        DuellKit.instance().onRender.remove(render);
    }

    // Override this function
    private function render(): Void
    {
        GL.clear(GLDefines.COLOR_BUFFER_BIT);

        // Draw calls here
    }
}
