package tests;

import tests.aggxtest.Circles;
import aggx.color.RgbaColor;
import aggx.core.memory.MemoryAccess;
import tests.meshTest.MeshTest;

class CirclesTest extends MeshTest
{
    public override function testAggx(): Void
    {
        MemoryAccess.select(data);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));

        var t = new Circles(renderingBuffer);
        t.run();
        enterFrame = function()
        {
            t.animate();
            reuploadTexture();
        };
    }
}