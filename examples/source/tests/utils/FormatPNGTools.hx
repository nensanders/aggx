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

class FormatPNGTools
{
    /**
		Converts from BGRA to RGBA and the other way by reversing bytes.
	**/
    public static function flipRGB(b: haxe.io.Bytes)
    {
        #if flash10
        var bytes = b.getData();
        if( bytes.length < 1024 ) bytes.length = 1024;
        flash.Memory.select(bytes);
        #end
        inline function bget(p)
        {
        #if flash10
            return flash.Memory.getByte(p);
        #else
            return b.get(p);
        #end
        }

        inline function bset(p,v)
        {
        #if flash10
            flash.Memory.setByte(p,v);
        #else
            return b.set(p,v);
        #end
        }

        var p = 0;
        for( i in 0...b.length >> 2 )
        {
            var b = bget(p);
            var r = bget(p + 2);
            bset(p++, r);
            p++;
            bset(p++, b);
            p++;
        }
    }
}
