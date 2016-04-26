package aggx.svg;

import aggx.color.RgbaColor;
import aggx.vectorial.PathUtils;
import aggx.vectorial.PathCommands;
import aggx.core.memory.Ref;
import aggx.core.memory.Ref.FloatRef;
import aggx.core.geometry.AffineTransformer;

class SVGDataBuilder
{
    public var data(default, null): SVGData;
    private var _elementStack: Array<SVGElement>;
    private var _transform: AffineTransformer;
    private var _pathParser: SVGPathParser;

    public function new()
    {
        data = new SVGData();
        _elementStack = new Array();
        _transform = new AffineTransformer();
        _pathParser = new SVGPathParser(data.storage);
    }

    public function curElement(): SVGElement
    {
        if (_elementStack.length == 0)
        {
            throw "curElement : elementibute stack is empty";
        }

        return _elementStack[_elementStack.length - 1];
    }

    public function pushElement(): Void
    {
        if (_elementStack.length == 0)
        {
            _elementStack.push(SVGElement.create());
        }
        else
        {
            var lastElement = _elementStack[_elementStack.length - 1];
            _elementStack.push(SVGElement.copy(lastElement));
        }
    }

    public function popElement(): Void
    {
        if (_elementStack.length == 0)
        {
            throw "pop_element : elementibute stack is empty";
        }
        _elementStack.pop();
    }

    public function beginPath(): Void
    {
        pushElement();
        var idx: Int = data.storage.startNewPath();
        data.elementStorage.push(SVGElement.copy(curElement(), idx));
    }

    public function endPath(): Void
    {
        if (data.elementStorage.length == 0)
        {
            throw "end_path : The path was not begun";
        }

        var element: SVGElement = curElement();
        var idx: UInt = data.elementStorage[data.elementStorage.length - 1].index;
        element.index = idx;
        data.elementStorage[data.elementStorage.length - 1] = element;

        element.calculateBoundingBox(data.storage);

        popElement();
    }

    public function debugBox(bounds: SVGPathBounds)
    {
        pushElement();
        var idx: Int = data.storage.startNewPath();
        data.elementStorage.push(SVGElement.copy(curElement(), idx));
        curElement().fill_none();
        curElement().stroke(new RgbaColor(255, 0, 0));
        _pathParser.move_to(bounds.minX, bounds.minY);
        _pathParser.line_to(bounds.maxX, bounds.minY);
        _pathParser.line_to(bounds.maxX, bounds.maxY);
        _pathParser.line_to(bounds.minX, bounds.maxY);
        _pathParser.close_subpath();

        var element: SVGElement = curElement();
        var idx: UInt = data.elementStorage[data.elementStorage.length - 1].index;
        element.index = idx;
        data.elementStorage[data.elementStorage.length - 1] = element;

        popElement();
    }

    public function path(tok: SVGPathTokenizer): Void
    {
        _pathParser.parsePath(tok);
    }

    public function rect(x: Float, y: Float, width: Float, height: Float)
    {
        _pathParser.move_to(x,y);
        _pathParser.line_to(x + width, y);
        _pathParser.line_to(x + width, y + height);
        _pathParser.line_to(x,y + height);
        _pathParser.close_subpath();
    }

    public function line(x1: Float, y1: Float, x2: Float, y2: Float)
    {
        _pathParser.move_to(x1, y1);
        _pathParser.line_to(x2, y2);
    }

    public function poly(tok: SVGPathTokenizer, close: Bool)
    {
        _pathParser.parsePoly(tok, close);
    }
}
