package tests;

import aggx.color.RgbaColor;
import tests.utils.AssetLoader;
import aggx.core.memory.MemoryAccess;
import tests.meshTest.MeshTest;

class AATest extends MeshTest
{
    public override function testAggx(): Void
    {
        MemoryAccess.select(data);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));
        var t = new aggxtest.AATest(renderingBuffer);
        t.run();
    }
}