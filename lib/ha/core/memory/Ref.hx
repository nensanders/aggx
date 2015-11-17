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

package lib.ha.core.memory;
//=======================================================================================================
private class RefBase<T>
{
	public var value:T;
	public function new(?val:T) { value = val; }
	public inline function set(?val:T):RefBase<T> { value = val; return this; }
    public function toString(){return '$value';}
}
//=======================================================================================================
typedef FloatRef = RefBase<Float>;
//=======================================================================================================
typedef IntRef = RefBase<Int>;
//=======================================================================================================
typedef PointerRef = RefBase<Pointer>;
//=======================================================================================================
class Ref
{
    private static var intPool: Array<RefBase<Int>> = new Array();
    private static var floatPool: Array<RefBase<Float>> = new Array();

    public static function getInt(): RefBase<Int>
    {
        var result: RefBase<Int>;
        if (intPool.length > 0)
        {
            result = intPool.pop();
        }
        else
        {
            result = new RefBase<Int>();
        }
        result.value = 0;
        return result;
    }

    public static function putInt(value: RefBase<Int>): RefBase<Int>
    {
        intPool.push(value);
        return value;
    }

    public static function getFloat(): RefBase<Float>
    {
        var result: RefBase<Float>;
        if (floatPool.length > 0)
        {
            result = floatPool.pop();
        }
        else
        {
            result = new RefBase<Float>();
        }
        result.value = 0.0;
        return result;
    }

    public static function putFloat(value: RefBase<Float>): RefBase<Float>
    {
        floatPool.push(value);
        return value;
    }

    public static function getPointer(): RefBase<Pointer>
    {
        return new RefBase<Pointer>();
    }
}