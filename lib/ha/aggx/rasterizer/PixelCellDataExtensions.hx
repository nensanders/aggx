package lib.ha.aggx.rasterizer;

import types.Data;
import lib.ha.core.utils.DataPointer;
class PixelCellDataExtensions
{
    public static inline function dataGetX(data: Data, pointer: Int):Int
    {
        data.offset = pointer + PixelCell.PIXEL_CELL_X;
        return data.readInt32();
    }

    public static inline function getY(pointer: DataPointer):Int
    {
        return pointer.get(PixelCell.PIXEL_CELL_Y).readInt32();
    }

    public static inline function getCover(pointer: DataPointer):Int
    {
        return pointer.get(PixelCell.PIXEL_CELL_COVER).readInt32();
    }

    public static inline function getArea(pointer: DataPointer):Int
    {
        return pointer.get(PixelCell.PIXEL_CELL_AREA).readInt32();
    }

    public static inline function getAll(pointer: DataPointer, cell:PixelCell):Void
    {
        cell.define(
            pointer.get(PixelCell.PIXEL_CELL_X).readInt32(),
            pointer.get(PixelCell.PIXEL_CELL_Y).readInt32(),
            pointer.get(PixelCell.PIXEL_CELL_COVER).readInt32(),
            pointer.get(PixelCell.PIXEL_CELL_AREA).readInt32());
    }

    public static inline function setX(pointer: DataPointer, v:Int):Void
    {
        pointer.get(PixelCell.PIXEL_CELL_X).writeInt32(v);
    }

    public static inline function dataSetX(data: Data, pointer: Int, v:Int):Void
    {
        data.offset = pointer + PixelCell.PIXEL_CELL_X;
        data.writeInt32(v);
    }

    public static inline function setY(pointer: DataPointer, v:Int):Void
    {
        pointer.get(PixelCell.PIXEL_CELL_Y).writeInt32(v);
    }

    public static inline function setCover(pointer: DataPointer, v:Int):Void
    {
        pointer.get(PixelCell.PIXEL_CELL_COVER).writeInt32(v);
    }

    public static inline function setArea(pointer: DataPointer, v:Int):Void
    {
        pointer.get(PixelCell.PIXEL_CELL_AREA).writeInt32(v);
    }

    public static inline function readInt32Offset(data: Data, p: Int): Int
    {
        data.offset = p;
        return data.readInt32();
    }

    public static inline function writeInt32Offset(data: Data, p: Int, v: Int): Void
    {
        data.offset = p;
        data.writeInt32(v);
    }

    public static inline function dataSwapPixel(data: Data, a: Int, b: Int): Void
    {
        var x: Int = readInt32Offset(data, a + PixelCell.PIXEL_CELL_X);
        var y: Int = readInt32Offset(data, a + PixelCell.PIXEL_CELL_Y);
        var cover: Int = readInt32Offset(data, a + PixelCell.PIXEL_CELL_COVER);
        var area: Int = readInt32Offset(data, a + PixelCell.PIXEL_CELL_AREA);

        var indices = [PixelCell.PIXEL_CELL_X, PixelCell.PIXEL_CELL_Y, PixelCell.PIXEL_CELL_COVER, PixelCell.PIXEL_CELL_AREA];
        for (i in indices)
        {
            writeInt32Offset(data, a + i, readInt32Offset(data, b + i));
        }

        writeInt32Offset(data, b + PixelCell.PIXEL_CELL_X, x);
        writeInt32Offset(data, b + PixelCell.PIXEL_CELL_Y, y);
        writeInt32Offset(data, b + PixelCell.PIXEL_CELL_AREA, area);
        writeInt32Offset(data, b + PixelCell.PIXEL_CELL_COVER, cover);
    }

    public static inline function setAll(pointer: DataPointer, cell:PixelCell):Void
    {
        pointer.get(PixelCell.PIXEL_CELL_X).writeInt32(cell.x);
        pointer.get(PixelCell.PIXEL_CELL_Y).writeInt32(cell.y);
        pointer.get(PixelCell.PIXEL_CELL_COVER).writeInt32(cell.cover);
        pointer.get(PixelCell.PIXEL_CELL_AREA).writeInt32(cell.area);
    }

    public static inline function setAllEx(to: DataPointer, from: DataPointer):Void
    {
        var indices = [PixelCell.PIXEL_CELL_X, PixelCell.PIXEL_CELL_Y, PixelCell.PIXEL_CELL_COVER, PixelCell.PIXEL_CELL_AREA];
        for (i in indices)
        {
            to.get(i).writeInt32(from.get(i).readInt32());
        }
    }
}