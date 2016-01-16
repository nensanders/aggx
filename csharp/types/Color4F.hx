/*
 * Copyright (c) 2003-2015, GameDuell GmbH
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

package types;

class Color4F
{
// This is the float distance between UINT8(0) and UINT8(1)
    inline static private var COLOR_EPSILON: Float = 1.0 / 256.0;

    public var r: Float = 0.0;
    public var g: Float = 0.0;
    public var b: Float = 0.0;
    public var a: Float = 1.0;

    inline public function new(r: Float = 0.0, g: Float = 0.0, b: Float = 0.0, a: Float = 1.0)
    {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    inline public function setRGBA(r: Float, g: Float, b: Float, a: Float = 1.0)
    {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    inline public function set(other: Color4F): Void
    {
        r = other.r;
        g = other.g;
        b = other.b;
        a = other.a;
    }

    inline public function isEqual(other: Color4F): Bool
    {
        return Math.abs(a - other.a) < COLOR_EPSILON &&
        Math.abs(r - other.r) < COLOR_EPSILON &&
        Math.abs(g - other.g) < COLOR_EPSILON &&
        Math.abs(b - other.b) < COLOR_EPSILON;
    }

/**
    * Use if likely to be equal
    * */
    inline public function isNotEqual(other: Color4F): Bool
    {
        return Math.abs(a - other.a) >= COLOR_EPSILON ||
        Math.abs(r - other.r) >= COLOR_EPSILON ||
        Math.abs(g - other.g) >= COLOR_EPSILON ||
        Math.abs (b - other.b) >= COLOR_EPSILON;
    }

    inline public function toString(): String
    {
        return '{$r, $g, $b, $a}';
    }

}
