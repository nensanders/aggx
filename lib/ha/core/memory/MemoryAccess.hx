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

import haxe.io.BytesData;
import flash.Memory;
import flash.system.ApplicationDomain;

class MemoryAccess
{
    public static inline function select( b : flash.utils.ByteArray ) : Void {
        ApplicationDomain.currentDomain.domainMemory = b;
    }

    public static inline function resize(newSize: Int): Void {
        ApplicationDomain.currentDomain.domainMemory.length = newSize;
    }

    public static inline function resizeOffset(offset: Int): Void {
        ApplicationDomain.currentDomain.domainMemory.length += offset;
    }

    public static inline function copy(dst:Pointer, src:Pointer, size:UInt):Void {
        var pos = ApplicationDomain.currentDomain.domainMemory.position;
        ApplicationDomain.currentDomain.domainMemory.position = src;
        ApplicationDomain.currentDomain.domainMemory.readBytes(ApplicationDomain.currentDomain.domainMemory, dst, size);
        ApplicationDomain.currentDomain.domainMemory.position = pos;
    }

    public static inline function writeBytes(bytes: BytesData, offset: UInt, size: UInt){
        bytes.readBytes(ApplicationDomain.currentDomain.domainMemory, offset, size);
    }

    public static inline function getUTF8String(addr:Pointer, len:Int):String
    {
        ApplicationDomain.currentDomain.domainMemory.position = addr;
        var s = ApplicationDomain.currentDomain.domainMemory.readUTFBytes(len);
        ApplicationDomain.currentDomain.domainMemory.position = addr;
        return s;
    }

    public static inline function setInt8( addr : Int, v : Int ) : Void {
        Memory.setByte(addr,v);
    }

    public static inline function setInt16( addr : Int, v : Int ) : Void {
        Memory.setI16(addr,v);
    }

    public static inline function setInt32( addr : Int, v : Int ) : Void {
        Memory.setI32(addr,v);
    }

    public static inline function setFloat32( addr : Int, v : Float ) : Void {
        Memory.setFloat(addr,v);
    }

    public static inline function setFloat64( addr : Int, v : Float ) : Void {
        Memory.setDouble(addr,v);
    }

    public static inline function getInt8( addr : Int ) : Int {
        return Memory.getByte(addr);
    }

    public static inline function getUInt16( addr : Int ) : Int {
        return Memory.getUI16(addr);
    }

    public static inline function getInt32( addr : Int ) : Int {
        return Memory.getI32(addr);
    }

    public static inline function getFloat32( addr : Int ) : Float {
        return Memory.getFloat(addr);
    }

    public static inline function getFloat64( addr : Int ) : Float {
        return Memory.getDouble(addr);
    }

    public static inline function signExtend1( v : Int ) : Int {
        return Memory.signExtend1(v);
    }

    public static inline function signExtend8( v : Int ) : Int {
        return Memory.signExtend8(v);
    }

    public static inline function signExtend16( v : Int ) : Int {
        return Memory.signExtend16(v);
    }
}
