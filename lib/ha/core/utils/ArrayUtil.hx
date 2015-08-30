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

package lib.ha.core.utils;

class ArrayUtil
{
    /**
	 * Allocates an array with a length of <code>x</code>.
	 * @throws de.polygonal.ds.error.AssertError <code>x</code> &lt; 0 (debug only).
	 */
    inline public static function alloc<T>(x:Int):Array<T>
    {
#if debug
        assert(x >= 0, "x >= 0");
#end

        var a:Array<T>;
#if (flash || js)
        a = untyped __new__(Array, x);
#elseif cpp
        a = new Array<T>();
        a[x - 1] = cast null;
#else
        a = new Array<T>();
        for (i in 0...x) a[i] = null;
#end
        return a;
    }

    /**
	 * Shrinks the array to the size <code>x</code> and returns the modified array.
	 */
    inline public static function shrink<T>(a:Array<T>, x:Int):Array<T>
    {
#if (flash || js)
        if (a.length > x)
            untyped a.length = x;
        return a;
#elseif cpp
        untyped a.length = x;
        return a;
#else
        var b = new Array<T>();
        for (i in 0...x) b[i] = a[i];
        return b;
#end
    }
}
