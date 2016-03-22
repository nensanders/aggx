package aggx.svg;
import haxe.ds.Vector;
import StringTools;

using StringTools;

class SVGPathTokenizer
{
    static private var _commands = "+-MmZzLlHhVvCcSsQqTtAaFfPp";
    static private var _numeric = ".Ee0123456789";
    static private var _separators = " ,\t\n\r";

    private var _separators_mask: Vector<UInt>;
    private var _commands_mask: Vector<UInt>;
    private var _numeric_mask: Vector<UInt>;

    private var _path: String;
    private var _last_command: String;
    private var _last_number: Float;

    public function new()
    {
        _path = "";
        _last_command = "";
        _last_number = 0.0;

        _separators_mask = new Vector(32); // 256/8
        _commands_mask = new Vector(32);
        _numeric_mask = new Vector(32);

        init_char_mask(_commands_mask, _commands);
        init_char_mask(_numeric_mask, _numeric);
        init_char_mask(_separators_mask, _separators);
    }

    private function init_char_mask(mask: Vector<UInt>, charSet: String): Void
    {
        for (i in 0...mask.length) mask[i] = 0; // Memset 0

        for (i in 0...charSet.length)
        {
            var c: UInt = charSet.charCodeAt(i) & 0xFF;
            mask[c >> 3] |= 1 << (c & 7);
        }
    }

    private function contains(mask: Vector<UInt>, c: UInt): Bool
    {
        return (mask[(c >> 3) & (31)] & (1 << (c & 7))) != 0;
    }

    private function is_command(c: UInt): Bool
    {
        return contains(_commands_mask, c);
    }

    private function is_numeric(c: UInt): Bool
    {
        return contains(_numeric_mask, c);
    }

    private function is_separator(c: UInt): Bool
    {
        return contains(_separators_mask, c);
    }

    public function set_path_str(str: String): Void
    {
        _path = str;
        _last_command = "";
        _last_number = 0.0;
    }

    public function hasNext(): Bool
    {
        if (_path.length == 0) return false;

        // Skip all white spaces and other garbage
        _path = _path.ltrim();
        var c = _path.charCodeAt(0);
        while (c != null && !is_command(c) && !is_numeric(c))
        {
            if (!is_separator(c))
            {
                throw 'path_tokenizer::next : Invalid Character $c';
            }

            _path = _path.substr(1);
            _path = _path.ltrim();
            c = _path.charCodeAt(0);
        }

        if (c == null) return false; // End of string

        if(is_command(c))
        {
            if (c == "-".charCodeAt(0) || c == "+".charCodeAt(0))
            {
                return parse_number(); // Returns true
            }
            _last_command = _path.charAt(0);
            _path = _path.substr(1);
            _path = _path.ltrim();

            while(c != null && is_separator(c))
            {
                _path = _path.substr(1);
                _path = _path.ltrim();
                c = _path.charCodeAt(0);
            }
            if (c == null) return true;
        }
        return parse_number(); // Returns true
    }

    public function last_command(): String
    {
        return _last_command;
    }

    public function last_number(): Float
    {
        return _last_number;
    }

    public function next(cmd: String): Float
    {
        if (!hasNext()) throw "parse_path: Unexpected end of path";
        if (last_command() != cmd)
        {
            throw 'parse_path: Command $cmd: bad or missing parameters';
        }
        return last_number();
    }

    private function parse_number(): Bool
    {
        var number: String = "";

        while (_path.length > 0)
        {
            var char = _path.charCodeAt(0);
            if (char == "-".charCodeAt(0) || char == "+".charCodeAt(0))
            {
                number += _path.charAt(0);
                _path = _path.substr(1);
            }
            else
            {
                break;
            }
        }

        while (_path.length > 0)
        {
            if (is_numeric(_path.charCodeAt(0)))
            {
                number += _path.charAt(0);
                _path = _path.substr(1);
            }
            else
            {
                break;
            }
        }

        if (number.length == 0)
        {
            _last_number = 0;
            return true;
        }

        _last_number = Std.parseFloat(number);
        return true;
    }
}
