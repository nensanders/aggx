package aggx.svg;

import aggx.core.memory.Ref.FloatRef;
import aggx.vectorial.IVertexSource;

class ConvCount implements IVertexSource
{
    private var _source:IVertexSource;
    private var _count:UInt;

    public var count(get, set): UInt;

    public function new(source:IVertexSource)
    {
        _source = source;
        _count = 0;
    }

    public function rewind(pathId:UInt):Void
    {
        _source.rewind(pathId);
    }

    public function getVertex(x:FloatRef, y:FloatRef): UInt
    {
        ++_count;
        return _source.getVertex(x,y);
    }

    function get_count():UInt
    {
        return _count;
    }

    function set_count(value:UInt) {
        return _count = value;
    }
}