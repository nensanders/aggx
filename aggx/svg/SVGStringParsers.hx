package aggx.svg;

import aggx.core.math.Calc;
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Ref.FloatRef;
import aggx.core.memory.Ref;
import aggx.color.SpanGradient.SpreadMethod;
import aggx.color.RgbaColor;
import haxe.ds.Vector;
import StringTools;

using StringTools;

class SVGStringParsers
{
    public static function parseFillUrl(value: String): String
    {
        var template: String = "url(#";
        var id = value.substring(template.length, value.length - 1);
        return id;
    }

    public static function parseColor(str: String): RgbaColor
    {
        if (str.indexOf("#") != -1)
        {
            var comp: Array<String> = str.split("#");
            var hexStr = comp[comp.length - 1];
            var isShortHex: Bool = hexStr.length == 3;

            var r: String = "0x";
            var g: String = "0x";
            var b: String = "0x";
            var a: String = "0x";

            if (isShortHex)
            {
                var rs = hexStr.substr(0,1);
                var gs = hexStr.substr(1,1);
                var bs = hexStr.substr(2,1);

                r = r + rs + rs;
                g = g + gs + gs;
                b = b + bs + bs;

                return new RgbaColor(Std.parseInt(r), Std.parseInt(g), Std.parseInt(b));
            }
            else
            {
                r += hexStr.substr(0,2);
                g += hexStr.substr(2,2);
                b += hexStr.substr(4,2);

                if (hexStr.length >= 8)
                {
                    a += hexStr.substr(6,2);
                }
                else
                {
                    a += "FF";
                }

                return new RgbaColor(Std.parseInt(r), Std.parseInt(g), Std.parseInt(b), Std.parseInt(a));
            }
        }
        else if (str.indexOf("rgb") != -1)
        {
            var right: Array<String> = str.split("(");
            var left: String = right[right.length - 1].split(")")[0];
            var values = left.split(","); // TODO Maybe check if there is no comma as separator
            return new RgbaColor(Std.parseInt(values[0]), Std.parseInt(values[1]), Std.parseInt(values[2]));
        }
        else
        {
            var color = SVGColors.get(str);

            if (color != null)
            {
                return RgbaColor.fromRgbaColor(color);
            }
            else
            {
                throw 'parse_color: Invalid color name $str';
            }
        }
    }

    public static function parsePercent(value: String): Float
    {
        if (value.lastIndexOf("%") != -1)
        {
            return Std.parseFloat(value.substr(0, value.length - 1)) / 100;
        }

        return Std.parseFloat(value);
    }

    public static function parseFloatRef(value: String): FloatRef
    {
        var ref: FloatRef = Ref.getFloat();
        ref.value = Std.parseFloat(value);
        return ref;
    }

    public static function parseFloatRefPercent(value: String): FloatRef
    {
        var ref: FloatRef = Ref.getFloat();
        ref.value = parsePercent(value);
        return ref;
    }

    public static function parseSpreadMethond(value: String): SpreadMethod
    {
        return switch (value)
        {
            case "pad": SpreadMethod.Pad;
            case "reflect": SpreadMethod.Reflect;
            case "repeat": SpreadMethod.Repeat;
            default: throw "invalid spread method";
        }
    }

    public static function parseTransform(str: String, transform: AffineTransformer): Void
    {
        for (elem in str.trim().split(")"))
        {
            if (elem == "")
            {
                continue;
            }

            var nameValue:Array<String> = elem.split("(");
            var name: String = nameValue[0].trim();
            var value: String = nameValue[1];
            var currentTransform: AffineTransformer;

            switch(name)
            {
                case "matrix":  currentTransform = parse_matrix(value);
                case "translate": currentTransform = parse_translate(value);
                case "rotate": currentTransform = parse_rotate(value);
                case "scale": currentTransform = parse_scale(value);
                case "skewX": currentTransform = parse_skew_x(value);
                case "skewY": currentTransform = parse_skew_y(value);
                default: throw 'unsupported transform type\'$name\'';
            }

            transform.premultiply(currentTransform);
        }
    }

    public static function parse_matrix(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(6);
        var na = parse_transform_args(str, 6, args);
        if (na != 6)
        {
            throw "parse_matrix: Invalid number of arguments";
        }
//_path.transform().premultiply(new AffineTransformer(args[0], args[1], args[2], args[3], args[4], args[5]));
        return new AffineTransformer(args[0], args[1], args[2], args[3], args[4], args[5]);
    }

    public static function parse_translate(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(2);
        var na = parse_transform_args(str, 2, args);
        if (na == 1) args[1] = 0.0;

        return AffineTransformer.translator(args[0], args[1]);
    }

    public static function parse_rotate(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(3);
        var na = parse_transform_args(str, 3, args);
        if (na == 1)
        {
            return AffineTransformer.rotator(Calc.deg2rad(args[0]));
        }
        else if (na == 3)
        {
            var t: AffineTransformer = AffineTransformer.translator(-args[1], -args[2]);
            t.multiply(AffineTransformer.rotator(Calc.deg2rad(args[0])));
            t.multiply(AffineTransformer.translator(args[1], args[2]));
            return t;
        }
        else
        {
            throw "parse_rotate: Invalid number of arguments";
        }
    }

    public static function parse_scale(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(2);
        var na = parse_transform_args(str, 2, args);
        if (na == 1) args[1] = args[0];
        return AffineTransformer.scaler(args[0], args[1]);
    }

    public static function parse_skew_x(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(1);
        var na = parse_transform_args(str, 1, args);
        return AffineTransformer.skewer(Calc.deg2rad(args[0]), 0.0);
    }

    public static function parse_skew_y(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(1);
        var na = parse_transform_args(str, 1, args);
        return AffineTransformer.skewer(0.0, Calc.deg2rad(args[0]));
    }

// Returns actual number of arguments
    public static function parse_transform_args(str: String, maxArgs: UInt, argsOut:Vector<Float>): UInt
    {
//  -10 -20
//   5,10
        str = str.split(",").join(" "); // Sanitize space and comma

        var count: UInt = 0;

        for (arg in str.split(" "))
        {
            if (arg == "") continue;
            if (count >= maxArgs) throw "parse_transform_args: Too many arguments";

            argsOut[count] = Std.parseFloat(arg);
            ++count;
        }
        return count;
    }
}