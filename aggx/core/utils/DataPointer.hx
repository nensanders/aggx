package aggx.core.utils;

import types.Data;

class DataPointer
{
    public var data: Data;
    public var offset: Int = 0;

    public function new(data: Data)
    {
        this.data = data;
    }

    public inline function get(add: Int = 0): Data
    {
        data.offset = offset + add;
        return data;
    }

    public function setInt32(v: Int)
    {
        data.offset = offset;
        data.writeInt32(v);
    }

    public function getInt32(): Int
    {
        data.offset = offset;
        return data.readInt32();
    }
}
