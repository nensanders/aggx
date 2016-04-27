package aggx.svg;
import haxe.ds.GenericStack;
import haxe.ds.StringMap;
import aggx.color.SpanGradient.SpreadMethod;
import aggx.core.memory.Ref.FloatRef;
import aggx.core.memory.Ref;
import aggx.svg.gradients.SVGGradient.GradientType;
import aggx.svg.gradients.SVGGradient.SVGStop;
import aggx.svg.gradients.SVGGradient;
import Array;
import aggx.core.geometry.AffineTransformer;
import aggx.vectorial.LineJoin;
import aggx.vectorial.LineCap;
import Xml;
import aggx.color.RgbaColor;
import haxe.ds.Vector;
import types.Data;
import types.DataStringTools;
import StringTools;

using types.DataStringTools;
using StringTools;
using aggx.svg.XmlExtender;
using aggx.svg.SVGStringParsers;

class SVGParser
{
    private var _path: SVGDataBuilder;
    private var _tokenizer: SVGPathTokenizer;
    private var currentGradient: SVGGradient;
    private var _useStack: GenericStack<SVGUseElement> = new GenericStack<SVGUseElement>();

    private var _defMap: StringMap<Xml> = new StringMap<Xml>();

    private var _buf: String;           // CHAR*
    private var _title: String;         // CHAR*
    private var _title_len: UInt;       // UNSIGNED
    private var _title_flag: Bool;      // BOOL
    private var _attr_name: String;     // CHAR*
    private var _attr_value: String;    // CHAR*
    private var _attr_name_len: UInt;   // UNSIGNED
    private var _attr_value_len: UInt;  // UNSIGNED

    public function new(path: SVGDataBuilder)
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
                case "pattern": throw "<pattern> is not supported";
                case "image": throw "<image> is not supported";
                default: parseDef(element);
            }
        });
    }

    private function parseRootElement(element: Xml): Void
    {
        eachAttribute(element, function (name: String, value: String)
        {
            switch (name)
            {
                case "viewBox": parseViewBox(value);
                case "width": _path.data.width = Std.parseFloat(value);
                case "height": _path.data.height = Std.parseFloat(value);
            }
        });
    }

    private function parseViewBox(value: String): Void
    {
        var viewBoxStringArray = value.split(" ");
        viewBoxStringArray = viewBoxStringArray.filter(function(s) return s != "");
        if (viewBoxStringArray.length == 4)
        {
            _path.data.viewBox.x = Std.parseFloat(viewBoxStringArray[0]);
            _path.data.viewBox.y = Std.parseFloat(viewBoxStringArray[1]);
            _path.data.viewBox.width = Std.parseFloat(viewBoxStringArray[2]);
            _path.data.viewBox.height = Std.parseFloat(viewBoxStringArray[3]);
        }
    }

    public function processXML(xml: Xml): Void
    {
        //begin with parsing all defs elements witch may scattered across all the document
        var defsCbk = function(element: Xml): Bool
        {
            if (element.nodeName == "defs")
            {
                parseDefs(element);
            }

            return true;
        }

        xml.eachXmlElement(defsCbk);

        processXmlRecursive(xml);
    }

    private function processXmlRecursive(xml: Xml)
    {
        var onBeginCbk = function(element: Xml): Bool
        {
            if (element.nodeName == 'defs')
            {
                return false;
            }

            if (element.nodeName == 'use')
            {
                processUseElement(element);
                //no children in use element
                return false;
            }

            beginElement(element);
            return true;
        }

        xml.eachXmlElement(onBeginCbk, endElement);
    }

    private function processUseElement(element: Xml)
    {
        _useStack.add(SVGUseElement.fromXml(element));
        var linked = _defMap.get(_useStack.first().link);
        if (linked == null)
        {
            throw '<use>: linked element ${_useStack.first().link} not found in document}';
        }
        var transform: String = _useStack.first().transform;
        if (transform != null)
        {
            _path.pushElement();
            transform.parseTransform(_path.curElement().transform);
        }

        if (beginElement(linked))
        {
            processXmlRecursive(linked);
        }
        endElement(linked);

        if (transform != null)
        {
            _path.popElement();
        }

        _useStack.pop();
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
            case "svg": parseRootElement(element);
            case "g":
                {
                    _path.pushElement();

                    eachAttribute(element,
                    function (name: String, value: String)
                    {
                        parseShapeAtribute(name, value);
                    });

                }
            case "path": parse_path(attr, element);
            case "rect": parse_rect(attr, element);
            case "line": parse_line(attr, element);
            case "polyline": parse_poly(attr, element, false);
            case "polygon": parse_poly(attr, element, true);
            case "image": throw "<image> is not supported";
            case "pattern": throw "<pattern> is not supported";
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

    private function parse_path(attrNames: Iterator<String>, element: Xml): Void
    {
        _path.beginPath();

        eachAttribute(element,
        function (name: String, value: String)
        {
            switch (name)
            {
                case "d":
                    {
                        var value = element.get(name);
                        _tokenizer.set_path_str(value);
                        _path.path(_tokenizer);
                    }
                default:
                    parseShapeAtribute(name, value);
            }
        });

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

                case "x1": currentGradient.gradientVector[0] = value.parseFloatRefPercent();
                case "y1": currentGradient.gradientVector[1] = value.parseFloatRefPercent();
                case "x2": currentGradient.gradientVector[2] = value.parseFloatRefPercent();
                case "y2": currentGradient.gradientVector[3] = value.parseFloatRefPercent();

                case "cx": currentGradient.focalGradientParameters[0] = value.parseFloatRefPercent();
                case "cy": currentGradient.focalGradientParameters[1] = value.parseFloatRefPercent();
                case "r": currentGradient.focalGradientParameters[2] = value.parseFloatRefPercent();
                case "fx": currentGradient.focalGradientParameters[3] = value.parseFloatRefPercent();
                case "fy": currentGradient.focalGradientParameters[4] = value.parseFloatRefPercent();

                case "gradientUnits": currentGradient.userSpace = value == "userSpaceOnUse";
                case "spreadMethod": currentGradient.spreadMethod = value.parseSpreadMethond();
                case "gradientTransform":
                    {
                        currentGradient.transform = new AffineTransformer();
                        value.parseTransform(currentGradient.transform);
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
        _path.data.addGradient(currentGradient);
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
                    case "stop-color": stop.color = value.parseColor();
                    case "offset": stop.offset = value.parsePercent();
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
        var seenX: Bool = false;
        var seenY: Bool = false;

        for (attr in element.attributes())
        {
            switch(attr)
            {
                case "style":
                    {
                        var style: String = element.get("style");
                        if (_useStack.first() != null && _useStack.first().style != null)
                        {
                            style = '$style:${_useStack.first().style}';
                        }

                        for (nameValue in style.split(";"))
                        {
                            if (nameValue == "")
                            {
                                continue;
                            }

                            var arguments: Array<String> = nameValue.split(":");
                            var name: String = arguments[0].trim();
                            var value: String = arguments[1].trim();
                            callback(name, value);
                        }


                        continue;
                    }

                case "x":
                    {
                        if (_useStack.first() != null && _useStack.first().x != null)
                        {
                            callback("x", _useStack.first().x);
                            seenX = true;
                            continue;
                        }
                    }

                case "y":
                    {
                        if (_useStack.first() != null && _useStack.first().y != null)
                        {
                            callback("y", _useStack.first().x);
                            seenY = true;
                            continue;
                        }
                    }
            }

            callback(attr, element.get(attr));
        }

        if (_useStack.first() != null)
        {
            if (!seenX && _useStack.first().x != null)
            {
                callback("x", _useStack.first().x);
            }

            if (!seenY && _useStack.first().y != null)
            {
                callback("y", _useStack.first().y);
            }
        }
    }

    private function parse_poly(attrNames: Iterator<String>, element: Xml, close_flag: Bool): Void
    {
        _path.beginPath();

        eachAttribute(element,
        function (name: String, value: String)
        {
            switch (name)
            {
                case "points":
                    {
                        _tokenizer.set_path_str(value);
                        _path.poly(_tokenizer, close_flag);
                    }
                default:
                    parseShapeAtribute(name, value);
            }
        });

        _path.endPath();
    }

    private function parse_rect(attrNames: Iterator<String>, element: Xml): Void
    {
        var x: Float = 0.0;
        var y: Float = 0.0;
        var w: Float = 0.0;
        var h: Float = 0.0;

        _path.beginPath();

        eachAttribute(element,
        function (name: String, value: String)
        {
            switch (name)
            {
                case "x": x = Std.parseFloat(value);
                case "y": y = Std.parseFloat(value);
                case "width": w = Std.parseFloat(value);
                case "height": h = Std.parseFloat(value);
                default:
                    parseShapeAtribute(name, value);
            }
        });

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

        eachAttribute(element,
        function (name: String, value: String)
        {
            switch (name)
            {
                case "x1": x1 = Std.parseFloat(value);
                case "y1": y1 = Std.parseFloat(value);
                case "x2": x2 = Std.parseFloat(value);
                case "y2": y2 = Std.parseFloat(value);
                default:
                    parseShapeAtribute(name, value);
            }
        });

        _path.line(x1, y1, x2, y2);
        _path.endPath();
    }

    private function parseShapeAtribute(name: String, value: String): Bool
    {
        var element = _path.curElement();
        switch (name)
        {
            case "fill":
                {
                    if (value == "none")
                    {
                        element.fill_none();
                    }
                    else if(value.indexOf("url(") == 0)
                    {
                        element.fillGradient(value.parseFillUrl());
                    }
                    else
                    {
                        element.fill(value.parseColor());
                    }
                }
            case "fill-opacity":
                {
                    element.fill_opacity = Std.parseFloat(value);
                }
            case "stroke":
                {
                    if (value == "none")
                    {
                        element.stroke_none();
                    }
                    else
                    {
                        element.stroke(value.parseColor());
                    }
                }
            case "stroke-width":
                {
                    element.stroke_width = Std.parseFloat(value);
                }
            case "stroke-linecap":
                {
                    if (value == "butt")
                    {
                        element.line_cap = LineCap.BUTT;
                    }
                    else if (value == "round")
                    {
                        element.line_cap = LineCap.ROUND;
                    }
                    else if (value == "square")
                    {
                        element.line_cap = LineCap.SQUARE;
                    }
                }
            case "stroke-linejoin":
                {
                    if (value == "miter")
                    {
                        element.line_join = LineJoin.MITER;
                    }
                    else if (value == "round")
                    {
                        element.line_join = LineJoin.ROUND;
                    }
                    else if (value == "bevel")
                    {
                        element.line_join =LineJoin.BEVEL;
                    }
                }
            case "stroke-miterlimit":
                {
                    element.miter_limit = Std.parseFloat(value);
                }
            case "stroke-opacity":
                {
                    element.stroke_opacity(Std.parseFloat(value));
                }
            case "transform":
                {
                    value.parseTransform(element.transform);
                }
            case "id":
                {
                    element.id = value;
                }

            default: return false;
        }
        return true;
    }
}
