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

package aggx.core.memory;

import types.DataStringTools;
import types.Data;
import haxe.io.BytesData;

using types.DataStringTools;

class MemoryAccess
{
    static public var domainMemory: Data;

    public static inline function select( b : Data ) : Void
    {
        domainMemory = b;
    }

    public static inline function writeBytes(bytes: Data, offset: UInt, size: UInt)
    {
        domainMemory.offset = offset;
        bytes.offsetLength = size;
        domainMemory.writeData(bytes);
    }

    public static inline function getUTF8String(addr:Pointer, len:Int):String
    {
        domainMemory.offset = addr;
        domainMemory.offsetLength = len;
        return domainMemory.readString();
    }

    public static inline function setUInt8( addr : Int, v : Int ) : Void
    {
        domainMemory.offset = addr; // TODO maybe cache this
        domainMemory.writeUInt8(v);
    }

    public static inline function setInt16( addr : Int, v : Int ) : Void
    {
        domainMemory.offset = addr;
        domainMemory.writeInt16(v);
    }

    public static inline function setInt32( addr : Int, v : Int ) : Void
    {
        domainMemory.offset = addr;
        domainMemory.writeInt32(v);
    }

    public static inline function setFloat32( addr : Int, v : Float ) : Void
    {
        domainMemory.offset = addr;
        domainMemory.writeFloat32(v);
    }

    public static inline function setFloat64( addr : Int, v : Float ) : Void
    {
        domainMemory.offset = addr;
        domainMemory.writeFloat64(v);
    }

    public static inline function getUInt8( addr : Int ) : Int
    {
        domainMemory.offset = addr;
        return domainMemory.readUInt8();
    }

    public static inline function getUInt16( addr : Int ) : Int
    {
        domainMemory.offset = addr;
        return domainMemory.readUInt16();
    }

    public static inline function getInt32( addr : Int ) : Int
    {
        domainMemory.offset = addr;
        return domainMemory.readInt32();
    }

    public static inline function getFloat32( addr : Int ) : Float
    {
        domainMemory.offset = addr;
        return domainMemory.readFloat32();
    }

    public static inline function getFloat64( addr : Int ) : Float
    {
        domainMemory.offset = addr;
        return domainMemory.readFloat64();
    }

    public static inline function signExtend1( v : Int ) : Int
    {
        return v;
    }

    public static inline function signExtend8( v : Int ) : Int
    {
        return v;
    }

    public static inline function signExtend16( v : Int ) : Int
    {
        return v;
    }
}
