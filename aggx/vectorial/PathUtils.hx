//----------------------------------------------------------------------------
// Anti-Grain Geometry - Version 2.4
// Copyright (C) 2002-2005 Maxim Shemanarev (http://www.antigrain.com)
//
// Permission to copy, use, modify, sell and distribute this software 
// is granted provided this copyright notice appears in all copies. 
// This software is provided "as is" without express or implied
// warranty, and with no claim as to its suitability for any purpose.
//
// Haxe port by: Hypeartist hypeartist@gmail.com
// Copyright (C) 2011 https://code.google.com/p/aggx
//
//----------------------------------------------------------------------------
// Contact: mcseem@antigrain.com
//          mcseemagg@yahoo.com
//          http://www.antigrain.com
//----------------------------------------------------------------------------

package aggx.vectorial;
//=======================================================================================================
class PathUtils 
{
	public inline static function isVertex(c:Int):Bool
	{
		return c >= PathCommands.MOVE_TO && c < PathCommands.END_POLY;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isDrawing(c:Int):Bool
	{
		return c >= PathCommands.LINE_TO && c < PathCommands.END_POLY;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isStop(c:Int):Bool
	{
		return c == PathCommands.STOP;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isMoveTo(c:Int):Bool
	{
		return c == PathCommands.MOVE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isLineTo(c:Int):Bool
	{
		return c == PathCommands.LINE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isCurve(c:Int):Bool
	{
		return c == PathCommands.CURVE3 || c == PathCommands.CURVE4;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isCurve3(c:Int):Bool
	{
		return c == PathCommands.CURVE3;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isCurve4(c:Int):Bool
	{
		return c == PathCommands.CURVE4;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isEndPoly(c:Int):Bool
	{
		return (c & PathCommands.MASK) == PathCommands.END_POLY;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isClose(c:Int):Bool
	{
		return (c & ~(PathFlags.CW | PathFlags.CCW)) == (PathCommands.END_POLY | PathFlags.CLOSE);
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isNextPoly(c:Int):Bool
	{
		return isStop(c) || isMoveTo(c) || isEndPoly(c);
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isCW(c:Int):Bool
	{
		return (c & PathFlags.CW) != 0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isCCW(c:Int):Bool
	{
		return (c & PathFlags.CCW) != 0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isOriented(c:Int):Bool
	{
		return (c & (PathFlags.CW | PathFlags.CCW)) != 0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function isClosed(c:Int):Bool
	{
		return (c & PathFlags.CLOSE) != 0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function getCloseFlag(c:Int):Int
	{
		return c & PathFlags.CLOSE;
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function clearOrientation(c:Int):Int
	{
		return c & ~(PathFlags.CW | PathFlags.CCW);
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function getOrientation(c:Int):Int
	{
		return c & (PathFlags.CW | PathFlags.CCW);
	}
	//---------------------------------------------------------------------------------------------------
	public inline static function setOrientation(c:Int, o:Int):Int
	{
		return clearOrientation(c) | o;
	}
	//---------------------------------------------------------------------------------------------------
	public static function shortenPath(vs:VertexSequence, s:Float, closed:Int = 0):Void
	{
		var vsSize = vs.size;
        if(s > 0.0 && vsSize > 1)
        {
            var d:Float;
            var n:UInt = vsSize - 2;
            while(n != 0)
            {
                d = vs.get(n).dist;
                if(d > s) break;
                vs.removeLast();
                s -= d;
                --n;
            }
            if(vsSize < 2)
            {
                vs.removeAll();
            }
            else
            {
                n = vsSize - 1;
                var prev = vs.get(n - 1);
                var last = vs.get(n);
                d = (prev.dist - s) / prev.dist;
                var x = prev.x + (last.x - prev.x) * d;
                var y = prev.y + (last.y - prev.y) * d;
                last.x = x;
                last.y = y;
                if(!prev.calc((last))) vs.removeLast();
                vs.close(closed != 0);
            }
        }
	}
}