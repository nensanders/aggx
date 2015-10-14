package lib.ha.svg;
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

private typedef NamedColor =
{
    private var name:String;
    private var color:RgbaColor;
}

class SVGParser
{
    private var _path: SVGPathRenderer;
    private var _tokenizer: SVGPathTokenizer;
    private var currentGradient: SVGGradient;

    private var _buf: String;           // CHAR*
    private var _title: String;         // CHAR*
    private var _title_len: UInt;       // UNSIGNED
    private var _title_flag: Bool;      // BOOL
    private var _path_flag: Bool;       // BOOL
    private var _attr_name: String;     // CHAR*
    private var _attr_value: String;    // CHAR*
    private var _attr_name_len: UInt;   // UNSIGNED
    private var _attr_value_len: UInt;  // UNSIGNED

    private static var colors: Vector<NamedColor> = Vector.fromArrayCopy([
        {name: "aliceblue", color: new RgbaColor(240,248,255)},
        {name: "antiquewhite", color: new RgbaColor(250,235,215)},
        {name: "aqua", color: new RgbaColor(0,255,255)},
        {name: "aquamarine", color: new RgbaColor(127,255,212)},
        {name: "azure", color: new RgbaColor(240,255,255)},
        {name: "beige", color: new RgbaColor(245,245,220)},
        {name: "bisque", color: new RgbaColor(255,228,196)},
        {name: "black", color: new RgbaColor(0,0,0)},
        {name: "blanchedalmond", color: new RgbaColor(255,235,205)},
        {name: "blue", color: new RgbaColor(0,0,255)},
        {name: "blueviolet", color: new RgbaColor(138,43,226)},
        {name: "brown", color: new RgbaColor(165,42,42)},
        {name: "burlywood", color: new RgbaColor(222,184,135)},
        {name: "cadetblue", color: new RgbaColor(95,158,160)},
        {name: "chartreuse", color: new RgbaColor(127,255,0)},
        {name: "chocolate", color: new RgbaColor(210,105,30)},
        {name: "coral", color: new RgbaColor(255,127,80)},
        {name: "cornflowerblue", color: new RgbaColor(100,149,237)},
        {name: "cornsilk", color: new RgbaColor(255,248,220)},
        {name: "crimson", color: new RgbaColor(220,20,60)},
        {name: "cyan", color: new RgbaColor(0,255,255)},
        {name: "darkblue", color: new RgbaColor(0,0,139)},
        {name: "darkcyan", color: new RgbaColor(0,139,139)},
        {name: "darkgoldenrod", color: new RgbaColor(184,134,11)},
        {name: "darkgray", color: new RgbaColor(169,169,169)},
        {name: "darkgreen", color: new RgbaColor(0,100,0)},
        {name: "darkgrey", color: new RgbaColor(169,169,169)},
        {name: "darkkhaki", color: new RgbaColor(189,183,107)},
        {name: "darkmagenta", color: new RgbaColor(139,0,139)},
        {name: "darkolivegreen", color: new RgbaColor(85,107,47)},
        {name: "darkorange", color: new RgbaColor(255,140,0)},
        {name: "darkorchid", color: new RgbaColor(153,50,204)},
        {name: "darkred", color: new RgbaColor(139,0,0)},
        {name: "darksalmon", color: new RgbaColor(233,150,122)},
        {name: "darkseagreen", color: new RgbaColor(143,188,143)},
        {name: "darkslateblue", color: new RgbaColor(72,61,139)},
        {name: "darkslategray", color: new RgbaColor(47,79,79)},
        {name: "darkslategrey", color: new RgbaColor(47,79,79)},
        {name: "darkturquoise", color: new RgbaColor(0,206,209)},
        {name: "darkviolet", color: new RgbaColor(148,0,211)},
        {name: "deeppink", color: new RgbaColor(255,20,147)},
        {name: "deepskyblue", color: new RgbaColor(0,191,255)},
        {name: "dimgray", color: new RgbaColor(105,105,105)},
        {name: "dimgrey", color: new RgbaColor(105,105,105)},
        {name: "dodgerblue", color: new RgbaColor(30,144,255)},
        {name: "firebrick", color: new RgbaColor(178,34,34)},
        {name: "floralwhite", color: new RgbaColor(255,250,240)},
        {name: "forestgreen", color: new RgbaColor(34,139,34)},
        {name: "fuchsia", color: new RgbaColor(255,0,255)},
        {name: "gainsboro", color: new RgbaColor(220,220,220)},
        {name: "ghostwhite", color: new RgbaColor(248,248,255)},
        {name: "gold", color: new RgbaColor(255,215,0)},
        {name: "goldenrod", color: new RgbaColor(218,165,32)},
        {name: "gray", color: new RgbaColor(128,128,128)},
        {name: "green", color: new RgbaColor(0,128,0)},
        {name: "greenyellow", color: new RgbaColor(173,255,47)},
        {name: "grey", color: new RgbaColor(128,128,128)},
        {name: "honeydew", color: new RgbaColor(240,255,240)},
        {name: "hotpink", color: new RgbaColor(255,105,180)},
        {name: "indianred", color: new RgbaColor(205,92,92)},
        {name: "indigo", color: new RgbaColor(75,0,130)},
        {name: "ivory", color: new RgbaColor(255,255,240)},
        {name: "khaki", color: new RgbaColor(240,230,140)},
        {name: "lavender", color: new RgbaColor(230,230,250)},
        {name: "lavenderblush", color: new RgbaColor(255,240,245)},
        {name: "lawngreen", color: new RgbaColor(124,252,0)},
        {name: "lemonchiffon", color: new RgbaColor(255,250,205)},
        {name: "lightblue", color: new RgbaColor(173,216,230)},
        {name: "lightcoral", color: new RgbaColor(240,128,128)},
        {name: "lightcyan", color: new RgbaColor(224,255,255)},
        {name: "lightgoldenrodyellow", color: new RgbaColor(250,250,210)},
        {name: "lightgray", color: new RgbaColor(211,211,211)},
        {name: "lightgreen", color: new RgbaColor(144,238,144)},
        {name: "lightgrey", color: new RgbaColor(211,211,211)},
        {name: "lightpink", color: new RgbaColor(255,182,193)},
        {name: "lightsalmon", color: new RgbaColor(255,160,122)},
        {name: "lightseagreen", color: new RgbaColor(32,178,170)},
        {name: "lightskyblue", color: new RgbaColor(135,206,250)},
        {name: "lightslategray", color: new RgbaColor(119,136,153)},
        {name: "lightslategrey", color: new RgbaColor(119,136,153)},
        {name: "lightsteelblue", color: new RgbaColor(176,196,222)},
        {name: "lightyellow", color: new RgbaColor(255,255,224)},
        {name: "lime", color: new RgbaColor(0,255,0)},
        {name: "limegreen", color: new RgbaColor(50,205,50)},
        {name: "linen", color: new RgbaColor(250,240,230)},
        {name: "magenta", color: new RgbaColor(255,0,255)},
        {name: "maroon", color: new RgbaColor(128,0,0)},
        {name: "mediumaquamarine", color: new RgbaColor(102,205,170)},
        {name: "mediumblue", color: new RgbaColor(0,0,205)},
        {name: "mediumorchid", color: new RgbaColor(186,85,211)},
        {name: "mediumpurple", color: new RgbaColor(147,112,219)},
        {name: "mediumseagreen", color: new RgbaColor(60,179,113)},
        {name: "mediumslateblue", color: new RgbaColor(123,104,238)},
        {name: "mediumspringgreen", color: new RgbaColor(0,250,154)},
        {name: "mediumturquoise", color: new RgbaColor(72,209,204)},
        {name: "mediumvioletred", color: new RgbaColor(199,21,133)},
        {name: "midnightblue", color: new RgbaColor(25,25,112)},
        {name: "mintcream", color: new RgbaColor(245,255,250)},
        {name: "mistyrose", color: new RgbaColor(255,228,225)},
        {name: "moccasin", color: new RgbaColor(255,228,181)},
        {name: "navajowhite", color: new RgbaColor(255,222,173)},
        {name: "navy", color: new RgbaColor(0,0,128)},
        {name: "oldlace", color: new RgbaColor(253,245,230)},
        {name: "olive", color: new RgbaColor(128,128,0)},
        {name: "olivedrab", color: new RgbaColor(107,142,35)},
        {name: "orange", color: new RgbaColor(255,165,0)},
        {name: "orangered", color: new RgbaColor(255,69,0)},
        {name: "orchid", color: new RgbaColor(218,112,214)},
        {name: "palegoldenrod", color: new RgbaColor(238,232,170)},
        {name: "palegreen", color: new RgbaColor(152,251,152)},
        {name: "paleturquoise", color: new RgbaColor(175,238,238)},
        {name: "palevioletred", color: new RgbaColor(219,112,147)},
        {name: "papayawhip", color: new RgbaColor(255,239,213)},
        {name: "peachpuff", color: new RgbaColor(255,218,185)},
        {name: "peru", color: new RgbaColor(205,133,63)},
        {name: "pink", color: new RgbaColor(255,192,203)},
        {name: "plum", color: new RgbaColor(221,160,221)},
        {name: "powderblue", color: new RgbaColor(176,224,230)},
        {name: "purple", color: new RgbaColor(128,0,128)},
        {name: "red", color: new RgbaColor(255,0,0)},
        {name: "rosybrown", color: new RgbaColor(188,143,143)},
        {name: "royalblue", color: new RgbaColor(65,105,225)},
        {name: "saddlebrown", color: new RgbaColor(139,69,19)},
        {name: "salmon", color: new RgbaColor(250,128,114)},
        {name: "sandybrown", color: new RgbaColor(244,164,96)},
        {name: "seagreen", color: new RgbaColor(46,139,87)},
        {name: "seashell", color: new RgbaColor(255,245,238)},
        {name: "sienna", color: new RgbaColor(160,82,45)},
        {name: "silver", color: new RgbaColor(192,192,192)},
        {name: "skyblue", color: new RgbaColor(135,206,235)},
        {name: "slateblue", color: new RgbaColor(106,90,205)},
        {name: "slategray", color: new RgbaColor(112,128,144)},
        {name: "slategrey", color: new RgbaColor(112,128,144)},
        {name: "snow", color: new RgbaColor(255,250,250)},
        {name: "springgreen", color: new RgbaColor(0,255,127)},
        {name: "steelblue", color: new RgbaColor(70,130,180)},
        {name: "tan", color: new RgbaColor(210,180,140)},
        {name: "teal", color: new RgbaColor(0,128,128)},
        {name: "thistle", color: new RgbaColor(216,191,216)},
        {name: "tomato", color: new RgbaColor(255,99,71)},
        {name: "turquoise", color: new RgbaColor(64,224,208)},
        {name: "violet", color: new RgbaColor(238,130,238)},
        {name: "wheat", color: new RgbaColor(245,222,179)},
        {name: "white", color: new RgbaColor(255,255,255)},
        {name: "whitesmoke", color: new RgbaColor(245,245,245)},
        {name: "yellow", color: new RgbaColor(255,255,0)},
        {name: "yellowgreen", color: new RgbaColor(154,205,50)},
        {name: "zzzzzzzzzzz", color: new RgbaColor(0,0,0,0)}
    ]);


    public function new(path: SVGPathRenderer)
    {
        _path = path;
        _tokenizer = new SVGPathTokenizer();
        _buf = "";
        _title = "";
        _title_len = 0;
        _title_flag = false;
        _path_flag = false;
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

    private function processXML(xml: Xml): Void
    {
        for (element in xml.elements())
        {
            var name = element.nodeName;
            startElement(element);

            for (child in element.iterator())
            {
                if (child.nodeType != XmlType.Element && child.nodeType != XmlType.Document)
                {
                    content(child.nodeValue);
                }
            }

            processXML(element);

            endElement(name);
        }
    }

    private function startElement(element: Xml): Void
    {
        var el: String = element.nodeName;
        var attr: Iterator<String> = element.attributes();

        switch (el)
        {
            case "title":
                {
                    _title_flag = true;
                }
            case "g":
                {
                    _path.push_attr();

                    for (name in attr)
                    {
                        parseShapeAtribute(name, element.get(name));
                    }
                }
            case "path":
                {
                    if (_path_flag)
                    {
                        throw "start_element: Nested path";
                    }
                    _path.beginPath();
                    parse_path(attr, element);
                    _path.endPath();
                    _path_flag = true;
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
            case "linearGradient":
                {
                    parseGradient(element);
                }
            default:
        }
    }

    private function endElement(el: String): Void
    {
        switch (el)
        {
            case "title":
                {
                    _title_flag = false;
                }
            case "g":
                {
                    _path.pop_attr();
                }
            case "path":
                {
                    _path_flag = false;
                }
            default:
        }
    }

    private function content(s: String): Void
    {
        if (_title_flag)
        {
            _title = s;
            _title_len = s.length;
        }
    }

    private inline function get_title():String { return _title; }
    public var title(get, null):String;

    private function parse_path(attrNames: Iterator<String>, element: Xml): Void
    {
        for (name in attrNames)
        {
            if (name == "d")
            {
                var value = element.get(name);
                _tokenizer.set_path_str(value);
                _path.parse_path(_tokenizer);
            }
            else
            {
                parseShapeAtribute(name, element.get(name));
            }
        }
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
            return;//TODO add support
        }

        eachAttribute(element,
        function (name: String, value: String)
        {
            switch (name)
            {
                case "id": currentGradient.id = value;
                case "xlink:href": currentGradient.link = value.substr(1, value.length - 1);
                case "x1": currentGradient.gradientVector[0] = parseFloatRef(value);
                case "y1": currentGradient.gradientVector[1] = parseFloatRef(value);
                case "x2": currentGradient.gradientVector[2] = parseFloatRef(value);
                case "y2": currentGradient.gradientVector[3] = parseFloatRef(value);
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
        var x: Float = 0.0;
        var y: Float = 0.0;

        var isFirst: Bool = true;
        var x1: Float = 0.0;
        var y1: Float = 0.0;
        var xm1: Float = 0.0;
        var ym1: Float = 0.0;

        _path.beginPath();

        for (name in attrNames)
        {
            var value = element.get(name);

            if (!parseShapeAtribute(name, value))
            {
                if (name == "points")
                {
                    _tokenizer.set_path_str(value);

                    if (!_tokenizer.hasNext())
                    {
                        throw "parse_poly: Too few coordinates";
                    }

                    x = _tokenizer.last_number();

                    if (!_tokenizer.hasNext())
                    {
                        throw "parse_poly: Too few coordinates";
                    }

                    y = _tokenizer.last_number();

                    _path.move_to(x, y);

                    while (_tokenizer.hasNext())
                    {
                        x = _tokenizer.last_number();

                        if(!_tokenizer.hasNext())
                        {
                            throw "parse_poly: Odd number of coordinates";
                        }
                        y = _tokenizer.last_number();

                        if (isFirst)
                        {
                            isFirst = false;
                            x1 = x;
                            y1 = y;
                        }

                        xm1 = x;
                        ym1 = y;

                        _path.line_to(x, y);
                    }
                }
            }
        }

        if(close_flag && x1 != xm1 && y1 != ym1)
        {
            _path.close_subpath();
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
            _path.move_to(x,     y);
            _path.line_to(x + w, y);
            _path.line_to(x + w, y + h);
            _path.line_to(x,     y + h);
            _path.close_subpath();
        }
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

        _path.move_to(x1, y1);
        _path.line_to(x2, y2);
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
                        parseUrlFill(value);
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

    private function parseUrlFill(value: String)
    {
        var template: String = "url(#";
        var id = value.substring(template.length, value.length - 1);
        _path.fillGradient(id);
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
            for (namedColor in colors)
            {
                if (namedColor.name == str)
                {
                    return RgbaColor.fromRgbaColor(namedColor.color);
                }
            }
            throw 'parse_color: Invalid color name $str';
            return null;
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
