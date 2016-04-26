package aggx.svg;

import aggx.vectorial.PathFlags;
import haxe.ds.Vector;
import aggx.vectorial.VectorPath;

class SVGPathParser
{
    private var _storage: VectorPath;

    public function new(storage: VectorPath): Void
    {
        _storage = storage;
    }

    public function parsePoly(tok: SVGPathTokenizer, close: Bool): Void
    {
        var x: Float = 0.0;
        var y: Float = 0.0;

        var isFirst: Bool = true;
        var x1: Float = 0.0;
        var y1: Float = 0.0;
        var xm1: Float = 0.0;
        var ym1: Float = 0.0;

        if (!tok.hasNext())
        {
            throw "parse_poly: Too few coordinates";
        }

        x = tok.last_number();

        if (!tok.hasNext())
        {
            throw "parse_poly: Too few coordinates";
        }

        y = tok.last_number();

        move_to(x, y);

        while (tok.hasNext())
        {
            x = tok.last_number();

            if(!tok.hasNext())
            {
                throw "parse_poly: Odd number of coordinates";
            }
            y = tok.last_number();

            if (isFirst)
            {
                isFirst = false;
                x1 = x;
                y1 = y;
            }

            xm1 = x;
            ym1 = y;

            line_to(x, y);
        }

        if(close && x1 != xm1 && y1 != ym1)
        {
            close_subpath();
        }
    }

    public function parsePath(tok: SVGPathTokenizer): Void
    {
        var arg: Vector<Float> = new Vector(7);

        while (tok.hasNext())
        {
            var cmd = tok.last_command();
            switch (cmd)
            {
                case "M", "m":
                    {
                        arg[0] = tok.last_number();
                        arg[1] = tok.next(cmd);
                        move_to(arg[0], arg[1], cmd == "m");
                    }
                case "L", "l":
                    {
                        arg[0] = tok.last_number();
                        arg[1] = tok.next(cmd);
                        line_to(arg[0], arg[1], cmd == "l");
                    }
                case "V", "v":
                    {
                        vline_to(tok.last_number(), cmd == "v");
                    }
                case "H", "h":
                    {
                        hline_to(tok.last_number(), cmd == "h");
                    }
                case "Q", "q":
                    {
                        arg[0] = tok.last_number();
                        for (i in 1...4)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        curve3Q(arg[0], arg[1], arg[2], arg[3], cmd == "q");
                    }
                case "T", "t":
                    {
                        arg[0] = tok.last_number();
                        arg[1] = tok.next(cmd);
                        curve3(arg[0], arg[1], cmd == "t");
                    }
                case "C", "c":
                    {
                        arg[0] = tok.last_number();
                        for (i in 1...6)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        curve4C(arg[0], arg[1], arg[2], arg[3], arg[4], arg[5], cmd == "c");
                    }
                case "S", "s":
                    {
                        arg[0] = tok.last_number();
                        for (i in 1...4)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        curve4(arg[0], arg[1], arg[2], arg[3], cmd == "s");
                    }
                case "A", "a":
                    {
                        arg[0] = tok.last_number();
                        for (i in 1...7)
                        {
                            arg[i] = tok.next(cmd);
                        }
                        arc(arg[0], arg[1], arg[2], arg[3] != 0, arg[4] != 0, arg[5], arg[6], cmd == 'a');
                    }
                case "Z", "z":
                    {
                        if (cmd == "Z") close_subpath();
                    }
                default:
                    {
                        throw 'parse_path: Invalid Command $cmd';
                    }
            }
        }
    }

// M, m
    public function move_to(x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.moveRel(x, y);
        }
        else
        {
            _storage.moveTo(x, y);
        }
    }

// L, l
    public function line_to(x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.lineRel(x, y);
        }
        else
        {
            _storage.lineTo(x, y);
        }
    }

// H, h
    public function hline_to(x: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.hlineRel(x);
        }
        else
        {
            _storage.hlineTo(x);
        }
    }

// V, v
    public function vline_to(y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.vlineRel(y);
        }
        else
        {
            _storage.vlineTo(y);
        }
    }

// Q, q
    public function curve3Q(x1: Float, y1: Float, x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve3Rel(x1, y1, x, y);
        }
        else
        {
            _storage.curve3(x1, y1, x, y);
        }
    }

// T, t
    public function curve3(x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve3RelTo(x,y);
        }
        else
        {
            _storage.curve3To(x,y);
        }
    }

// C, c
    public function curve4C(x1: Float, y1: Float, x2: Float, y2: Float, x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve4Rel(x1,y1,x2,y2,x,y);
        }
        else
        {
            _storage.curve4(x1,y1,x2,y2,x,y);
        }
    }

// S, s
    public function curve4(x2: Float, y2: Float, x: Float, y: Float, rel: Bool = false): Void
    {
        if (rel)
        {
            _storage.curve4RelTo(x2,y2,x,y);
        }
        else
        {
            _storage.curve4To(x2,y2,x,y);
        }
    }

//A, a
    public function arc(rx: Float, ry: Float, angle: Float, isLargeArc: Bool, isSweep: Bool, x: Float, y: Float, rel: Bool = false)
    {
        if (rel)
        {
            _storage.arcRel(rx, ry, angle, isLargeArc, isSweep, x, y);
        }
        else
        {
            _storage.arc(rx, ry, angle, isLargeArc, isSweep, x, y);
        }
    }

// Z, z
    public function close_subpath(): Void
    {
        _storage.endPoly(PathFlags.CLOSE);
    }

}