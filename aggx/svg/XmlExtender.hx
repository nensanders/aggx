package aggx.svg;

class XmlExtender
{
    public static function eachChildElement(xml: Xml, callback: Xml -> String -> Void)
    {
        for (element in xml.elements())
        {
            if (element.nodeType != Xml.Element)
            {
                continue;
            }

            var name = element.nodeName;
            callback(element, name);
        }
    }

    public static function findFirstElement(xml: Xml, name: String): Xml
    {
        var it = xml.elementsNamed(name);
        if (!it.hasNext())
        {
            return null;
        }

        return it.next();
    }

    public static function eachXmlElement(xml: Xml, begin: Xml -> Bool, ?end: Xml -> Void)
    {
        eachChildElement(xml, function(element: Xml, name: String)
        {
            if (begin(element))
            {
                eachXmlElement(element, begin, end);
            }

            if (end != null)
            {
                end(element);
            }
        });
    }
}