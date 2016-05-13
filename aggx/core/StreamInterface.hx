package aggx.core;

interface StreamInterface
{
    public function writeUInt8(value: Int): Void;
    public function readUInt8(): Int;

    public function writeUInt16(value: Int): Void;
    public function readUInt16(): Int;

    public function writeUInt32(value: Int): Void;
    public function readUInt32(): Int;

    public function writeFloat32(value: Float): Void;
    public function readFloat32(): Float;

    public function preallocate(next: Int): Void;
}
