package tests;

import aggx.typography.FontEngine;
import aggx.rfpx.TrueTypeCollection;
import tests.utils.AssetLoader;
import aggx.rfpx.TrueTypeLoader;
import aggx.color.RgbaColor;
import aggx.core.memory.MemoryAccess;
import tests.meshTest.MeshTest;

class FontTest extends MeshTest
{
    inline private static var FONT_PATH_JAPAN = "meshTest/fonts/font_1_ant-kaku.ttf";
    inline private static var FONT_PATH_ARIAL = "meshTest/fonts/arial.ttf";
    inline private static var FONT_PATH_COMIC = "meshTest/fonts/Pacifico.ttf";

    public override function testAggx(): Void
    {
        MemoryAccess.select(data);
        clippingRenderer.clear(new RgbaColor(255, Std.int(255.0 * 1.0), Std.int(255.0 * 1.0), 255));
        var loader = new TrueTypeLoader(AssetLoader.getDataFromFile(FONT_PATH_JAPAN));
        loader.load(fontLoaded);
    }

    private function fontLoaded(ttc:TrueTypeCollection): Void
    {
        var string1 = "ABCDEFGHJIKLMNOPQRSTUVWXYZ";
        var string2 = "abcdefghjiklmnopqrstuvwxyz";
        var string3 = "1234567890";
        var string4 = "!@#$%^&*()_+|{}:?><~`';/.,";
        var string5 = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦШЩЭЮЯ";
        var string6 = "абвгдеёжзийклмнопрстуфхцшщэюя";
        var japanString1 = '「ほのかアンティーク角」フォントは角ゴシックの漢字に合わせたウロコの付きの文字を組み合わせたアンチック体（アンティーク体）の日本語フォントです。';
        var japanString2 = '漢字等についてはオープンソースフォント「源柔ゴシック」を使用させて頂いております（詳細は後述）。';
        var japanString3 = '個人での利用のほか、商用利用においてデザイナーやクリエイターの方もご活用いただけます。';

        var fontEngine = new FontEngine(ttc);
        var fontSize = 80;

        scanlineRenderer.color = new RgbaColor(255, 0, 0);

        var x = 10;
        var y = 0 * fontSize / 20;

        fontEngine.renderString(string1, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(27, 106, 240);

        var x = 10;
        var y = 20 * fontSize / 20;

        fontEngine.renderString(string2, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(227, 200, 26);

        var x = 10;
        var y = 40 * fontSize / 20;

        fontEngine.renderString(string3, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(106, 27, 240);

        var x = 10;
        var y = 60 * fontSize / 20;

        fontEngine.renderString(string4, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(136, 207, 100);

        var x = 10;
        var y = 80 * fontSize / 20;

        fontEngine.renderString(string5, fontSize, x, y, scanlineRenderer);

        scanlineRenderer.color = new RgbaColor(136, 20, 50);

        var x = 10;
        var y = 100 * fontSize / 20;

        fontEngine.renderString(string6, fontSize, x, y, scanlineRenderer);

        var x = 10;
        var y = 120 * fontSize / 20;

        fontEngine.renderString(japanString1, fontSize, x, y, scanlineRenderer);

        var x = 10;
        var y = 140 * fontSize / 20;

        fontEngine.renderString(japanString2, fontSize, x, y, scanlineRenderer);

        var x = 10;
        var y = 160 * fontSize / 20;

        fontEngine.renderString(japanString3, fontSize, x, y, scanlineRenderer);
    }
}