package aggx.core.utils;

import haxe.CallStack;
class Debug
{
    public static function brk()
    {
        try
        {
            throw "__dummy__";
        }
        catch(ex: String)
        {

        }
    }

    public inline static function calledFrom(): String
    {
        var stack = CallStack.callStack();
        if (stack.length < 3)
        {
            return "";
        }

        return '${stack[2]}';
    }

    public static function assert(condition: Bool, message: String): Bool
    {
        if (!condition)
        {
            trace('Failed assert: $message caller: ${calledFrom()}');
            Debug.brk();
        }

        return condition;
    }
}
