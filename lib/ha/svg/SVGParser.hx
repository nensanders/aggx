package lib.ha.svg;
import haxe.ds.StringMap;
import lib.ha.aggx.color.SpanGradient.SpreadMethod;
import lib.ha.core.memory.Ref.FloatRef;
import lib.ha.core.memory.Ref;
import lib.ha.svg.gradients.SVGGradient.GradientType;
import lib.ha.svg.gradients.SVGGradient.SVGStop;
import lib.ha.svg.gradients.SVGGradient;
import Array;
import types.AffineTransform;
import lib.ha.core.math.Calc;
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.aggx.vectorial.LineJoin;
import lib.ha.aggx.vectorial.LineCap;
import Xml;
import haxe.xml.Fast;
import lib.ha.aggx.color.RgbaColor;
import haxe.ds.Vector;
import types.Data;
import types.DataStringTools;
import StringTools;

using types.DataStringTools;
using StringTools;
using lib.ha.svg.XmlExtender;

class SVGParser
{
    private var _path: SVGPathRenderer;
    private var _tokenizer: SVGPathTokenizer;
    private var currentGradient: SVGGradient;
    private var _defMap: StringMap<Xml> = new StringMap<Xml>();

    private var _buf: String;           // CHAR*
    private var _title: String;         // CHAR*
    private var _title_len: UInt;       // UNSIGNED
    private var _title_flag: Bool;      // BOOL
    private var _attr_name: String;     // CHAR*
    private var _attr_value: String;    // CHAR*
    private var _attr_name_len: UInt;   // UNSIGNED
    private var _attr_value_len: UInt;  // UNSIGNED
    
    public function new(path: SVGPathRenderer)
    {
        _path = path;
        _tokenizer = new SVGPathTokenizer();
        _buf = "";
        _title = "";
        _title_len = 0;
        _title_flag = false;
        _attr_name = "";
        _attr_value = "";
        _attr_name_len = 127;
        _attr_value_len = 1023;
    }

    public function parse(svgData: Data): Void
    {
        var svg: Xml = Xml.parse(svgData.readString());

        if (svg == null)
        {
            throw "Coulnt create xml from file ...";
        }

        processXML(svg);
    }

    private function parseDef(element: Xml)
    {
        var id: String = element.get("id");
        if (id == null || id.length == 0)
        {
            return;
        }

        _defMap.set(id, element);
    }

    private function parseDefs(element: Xml)
    {
        element.eachChildElement(function (element: Xml, name: String)
        {
            switch (name)
            {
                case "linearGradient" | "radialGradient" : parseGradient(element);
                default: parseDef(element);
            }
        });
    }

    private function processXML(xml: Xml): Void
    {
        //begin with parsing all defs elements witch may scattered across all the document
        var defsCbk = function(element: Xml): Bool
        {
            if (element.nodeName != "defs")
            {
                return true;
            }

            parseDefs(element);
            return true;
        }
        xml.eachXmlElement(defsCbk);

        xml.eachXmlElement(beginElement, endElement);
    }

    private function beginElement(element: Xml): Bool
    {
        var el: String = element.nodeName;
        if (el == "defs")
        {
            return false;
        }

        var attr: Iterator<String> = element.attributes();

        switch (el)
        {
            case "g":
                {
                    _path.pushElement();

                    for (name in attr)
                    {
                        parseShapeAtribute(name, element.get(name));
                    }
                }
            case "path":
                {
                    parse_path(attr, element);
                }
            case "rect":
                {
                    parse_rect(attr, element);
                }
            case "line":
                {
                    parse_line(attr, element);
                }
            case "polyline":
                {
                    parse_poly(attr, element, false);
                }
            case "polygon":
                {
                    parse_poly(attr, element, true);
                }
            default:
        }

        return true;
    }

    private function endElement(element: Xml): Void
    {
        switch (element.nodeName)
        {
            case "g":
                {
                    _path.popElement();
                }
            case "path":
                {

                }
            default:
        }
    }

    private function content(s: String): Void
    {

    }

    private inline function get_title():String { return _title; }
    public var title(get, null):String;

    private function parse_path(attrNames: Iterator<String>, element: Xml): Void
    {
        _path.beginPath();
        for (name in attrNames)
        {
            if (name == "d")
            {
                var value = element.get(name);
                _tokenizer.set_path_str(value);
                _path.path(_tokenizer);
            }
            else
            {
                parseShapeAtribute(name, element.get(name));
            }
        }
        _path.endPath();
    }

    private function parseGradient(element: Xml)
    {
        currentGradient = new SVGGradient();

        if (element.nodeName == "linearGradient")
        {
            currentGradient.type = GradientType.Linear;
        }
        else if (element.nodeName == "radialGradient")
        {
            currentGradient.type = GradientType.Radial;
        }

        eachAttribute(element,
        function (name: String, value: String)
        {
            switch (name)
            {
                case "id": currentGradient.id = value;
                case "xlink:href": currentGradient.link = value.substr(1, value.length - 1);

                case "x1": currentGradient.gradientVector[0] = parseFloatRefPercent(value);
                case "y1": currentGradient.gradientVector[1] = parseFloatRefPercent(value);
                case "x2": currentGradient.gradientVector[2] = parseFloatRefPercent(value);
                case "y2": currentGradient.gradientVector[3] = parseFloatRefPercent(value);

                case "cx": currentGradient.focalGradientParameters[0] = parseFloatRefPercent(value);
                case "cy": currentGradient.focalGradientParameters[1] = parseFloatRefPercent(value);
                case "r": currentGradient.focalGradientParameters[2] = parseFloatRefPercent(value);
                case "fx": currentGradient.focalGradientParameters[3] = parseFloatRefPercent(value);
                case "fy": currentGradient.focalGradientParameters[4] = parseFloatRefPercent(value);

                case "gradientUnits": currentGradient.userSpace = value == "userSpaceOnUse";
                case "spreadMethod": currentGradient.spreadMethod = parseSpreadMethond(value);
                case "gradientTransform":
                    {
                        currentGradient.transform = new AffineTransformer();
                        parseTransform(value, currentGradient.transform);
                    }
                default:
            }
        }
        );

        var stops: Array<SVGStop> = [];
        for (child in element.iterator())
        {
            if (child.nodeType != Xml.Element)
            {
                continue;
            }

            if (child.nodeName != "stop")
            {
                continue;
            }

            stops.push(parseGradientStop(child));
        }

        //trace('${currentGradient.id} -> ${currentGradient.type}');
        currentGradient.calculateColorArray(stops);
        _path.addGradient(currentGradient);
    }

    private function parseGradientStop(element: Xml): SVGStop
    {
        var stop: SVGStop = new SVGStop();
        var opacity: Float = 1;

        eachAttribute(element,
            function (name: String, value: String)
            {
                switch (name)
                {
                    case "stop-color": stop.color = parse_color(value);
                    case "offset": stop.offset = parsePercent(value);
                    case "stop-opacity": opacity = Std.parseFloat(value);
                    default:
                }
            }
        );

        stop.color.a = Math.round(opacity * 255);
        return stop;
    }


    private function eachAttribute(element: Xml, callback: String -> String -> Void)
    {
        for (attr in element.attributes())
        {
            if (attr == "style")
            {
                var style: String = element.get("style");
                for (nameValue in style.split(";"))
                {
                    if (nameValue == "")
                    {
                        continue;
                    }

                    var arguments: Array<String> = nameValue.split(":");
                    var name: String = arguments[0].rtrim();
                    var value: String = arguments[1].ltrim();
                    callback(name, value);
                }

                continue;
            }

            callback(attr, element.get(attr));
        }
    }
    private function parse_poly(attrNames: Iterator<String>, element: Xml, close_flag: Bool): Void
    {
        _path.beginPath();

        for (name in attrNames)
        {
            var value = element.get(name);

            if (!parseShapeAtribute(name, value))
            {
                if (name == "points")
                {
                    _tokenizer.set_path_str(value);
                    _path.poly(_tokenizer, close_flag);
                }
            }
        }

        _path.endPath();
    }

    private function parse_rect(attrNames: Iterator<String>, element: Xml): Void
    {
        var x: Float = 0.0;
        var y: Float = 0.0;
        var w: Float = 0.0;
        var h: Float = 0.0;

        _path.beginPath();

        for (name in attrNames)
        {
            var value = element.get(name);

            if (!parseShapeAtribute(name, value))
            {
                if (name == "x") x = Std.parseFloat(value);
                if (name == "y") y = Std.parseFloat(value);
                if (name == "width") w = Std.parseFloat(value);
                if (name == "height") h = Std.parseFloat(value);
                // rx - TODO to be implemented
                // ry - TODO to be implemented
            }
        }

        if(w != 0.0 && h != 0.0)
        {
            if(w < 0.0) throw 'parse_rect: Invalid width: $w';
            if(h < 0.0) throw 'parse_rect: Invalid height: $h';

        }

        _path.rect(x, y, w, h);
        _path.endPath();
    }

    private function parse_line(attrNames: Iterator<String>, element: Xml): Void
    {
        var x1: Float = 0.0;
        var y1: Float = 0.0;
        var x2: Float = 0.0;
        var y2: Float = 0.0;

        _path.beginPath();
        for (name in attrNames)
        {
            var value = element.get(name);

            if (!parseShapeAtribute(name, value))
            {
                if (name == "x1") x1 = Std.parseFloat(value);
                if (name == "y1") y1 = Std.parseFloat(value);
                if (name == "x2") x2 = Std.parseFloat(value);
                if (name == "x2") y2 = Std.parseFloat(value);
            }
        }

        _path.line(x1, y1, x2, y2);
        _path.endPath();
    }

    private function parse_name_value(nameValue: String): Bool
    {
        var arguments: Array<String> = nameValue.split(":");
        var name: String = arguments[0].rtrim();
        var value: String = arguments[1].ltrim();
        return parseShapeAtribute(name, value);
    }

    private function parse_style(str: String): Void
    {
        for (nameValue in str.split(";"))
        {
            if (nameValue == "") continue;
            parse_name_value(nameValue.trim());
        }
    }

    private function parseTransform(str: String, transform: AffineTransformer): Void
    {
        for (elem in str.split(")"))
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

    private function parse_matrix(str: String): AffineTransformer
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

    private function parse_translate(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(2);
        var na = parse_transform_args(str, 2, args);
        if (na == 1) args[1] = 0.0;

        return AffineTransformer.translator(args[0], args[1]);
    }

    private function parse_rotate(str: String): AffineTransformer
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

    private function parse_scale(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(2);
        var na = parse_transform_args(str, 2, args);
        if (na == 1) args[1] = args[0];
        return AffineTransformer.scaler(args[0], args[1]);
    }

    private function parse_skew_x(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(1);
        var na = parse_transform_args(str, 1, args);
        return AffineTransformer.skewer(Calc.deg2rad(args[0]), 0.0);
    }

    private function parse_skew_y(str: String): AffineTransformer
    {
        var args: Vector<Float> = new Vector(1);
        var na = parse_transform_args(str, 1, args);
        return AffineTransformer.skewer(0.0, Calc.deg2rad(args[0]));
    }

    // Returns actual number of arguments
    private function parse_transform_args(str: String, maxArgs: UInt, argsOut:Vector<Float>): UInt
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

    private function parseShapeAtribute(name: String, value: String): Bool
    {
        switch (name)
        {
            case "style":
                {
                    parse_style(value);
                }
            case "fill":
                {
                    if (value == "none")
                    {
                        _path.fill_none();
                    }
                    else if(value.indexOf("url(") == 0)
                    {
                        _path.fillGradient(parseUrlFill(value));
                    }
                    else
                    {
                        _path.fill(parse_color(value));
                    }
                }
            case "fill-opacity":
                {
                    _path.fill_opacity(Std.parseFloat(value));
                }
            case "stroke":
                {
                    if (value == "none")
                    {
                        _path.stroke_none();
                    }
                    else
                    {
                        _path.stroke(parse_color(value));
                    }
                }
            case "stroke-width":
                {
                    _path.stroke_width(Std.parseFloat(value));
                }
            case "stroke-linecap":
                {
                    if (value == "butt")
                    {
                        _path.line_cap(LineCap.BUTT);
                    }
                    else if (value == "round")
                    {
                        _path.line_cap(LineCap.ROUND);
                    }
                    else if (value == "square")
                    {
                        _path.line_cap(LineCap.SQUARE);
                    }
                }
            case "stroke-linejoin":
                {
                    if (value == "miter")
                    {
                        _path.line_join(LineJoin.MITER);
                    }
                    else if (value == "round")
                    {
                        _path.line_join(LineJoin.ROUND);
                    }
                    else if (value == "bevel")
                    {
                        _path.line_join(LineJoin.BEVEL);
                    }
                }
            case "stroke-miterlimit":
                {
                    _path.miter_limit(Std.parseFloat(value));
                }
            case "stroke-opacity":
                {
                    _path.stroke_opacity(Std.parseFloat(value));
                }
            case "transform":
                {
                    parseTransform(value, _path.transform());
                }
            case "id":
                {
                    _path.id(value);
                }
            //else
            //if(strcmp(el, "<OTHER_ATTRIBUTES>") == 0)
            //{
            //}
            // . . .
            default: return false;
        }
        return true;
    }

    private function parseUrlFill(value: String): String
    {
        var template: String = "url(#";
        var id = value.substring(template.length, value.length - 1);
        return id;
    }

    private function parse_color(str: String): RgbaColor
    {
        if (str.indexOf("#") != -1)
        {
            var comp: Array<String> = str.split("#");
            var hexStr = comp[comp.length - 1];
            var isShortHex: Bool = hexStr.length == 3;

            var r: String = "0x";
            var g: String = "0x";
            var b: String = "0x";

            if (isShortHex)
            {
                var rs = hexStr.substr(0,1);
                var gs = hexStr.substr(1,1);
                var bs = hexStr.substr(2,1);
                r = r + rs + rs;
                g = g + gs + gs;
                b = b + bs + bs;
            }
            else
            {
                r += hexStr.substr(0,2);
                g += hexStr.substr(2,2);
                b += hexStr.substr(4,2);
            }
            return new RgbaColor(Std.parseInt(r), Std.parseInt(g), Std.parseInt(b));
        }
        else if (str.indexOf("rgb") != -1)
        {
            var right: Array<String> = str.split("(");
            var left: String = right[right.length - 1].split(")")[0];
            var values = left.split(","); // TODO Maybe check if there is no comma as separator
            trace(values);
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

    private function parsePercent(value: String): Float
    {
        if (value.lastIndexOf("%") != -1)
        {
            return Std.parseFloat(value.substr(0, value.length - 1)) / 100;
        }

        return Std.parseFloat(value);
    }

    private function parseFloatRef(value: String): FloatRef
    {
        var ref: FloatRef = Ref.getFloat();
        ref.value = Std.parseFloat(value);
        return ref;
    }

    private function parseFloatRefPercent(value: String): FloatRef
    {
        var ref: FloatRef = Ref.getFloat();
        ref.value = parsePercent(value);
        return ref;
    }

    private function parseSpreadMethond(value: String): SpreadMethod
    {
        return switch (value)
        {
            case "pad": SpreadMethod.Pad;
            case "reflect": SpreadMethod.Reflect;
            case "repeat": SpreadMethod.Repeat;
            default: throw "invalid spread method";
        }
    }

}
