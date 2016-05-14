package tests;

import aggx.typography.FontEngine;
import aggx.rfpx.TrueTypeCollection;
import tests.utils.AssetLoader;
import aggx.rfpx.TrueTypeLoader;
import aggx.color.RgbaColor;
import aggx.core.memory.MemoryAccess;
import tests.meshTest.MeshTest;

class SvgTest extends MeshTest
{
    inline private static var VECTOR_PATH_TIGER = "meshTest/vector/tiger.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/tiger.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/car.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/paths.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/rect.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/chars/Bendy2.svg";
    //inline private static var VECTOR_PATH_TIGER = "meshTest/vector/rect_transform.svg";

    public override function testAggx(): Void
    {
        MemoryAccess.select(data);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));
        var t = new tests.aggxtest.SVGTest(renderingBuffer, AssetLoader.getDataFromFile(VECTOR_PATH_TIGER));
        t.run();
    }
}