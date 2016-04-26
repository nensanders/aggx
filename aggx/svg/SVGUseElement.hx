package aggx.svg;

class SVGUseElement
{
    public var x: String;
    public var y: String;
    public var width: String;
    public var height: String;
    public var transform: String;
    public var link: String;
    public var style: String;

    private function new()
    {

    }

    public function toString(): String
    {
        return 'Use: {x: $x, y: $y, link: $link, style: $style}';
    }

    public static function fromXml(element: Xml): SVGUseElement
    {
        var output: SVGUseElement = new SVGUseElement();

        for (name in element.attributes())
        {
            var value: String = element.get(name);

            switch (name)
            {
                case "x": output.x = value;
                case "y": output.y = value;
                case "width": output.width = value;
                case "height": output.height = value;
                case "transform": output.transform = value;
                case "xlink:href": output.link = value.substr(1, value.length - 1);
                case "style": output.style = value;
                default:
            }
        }

        return output;
    }
}