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

package aggx.core.utils;
//=======================================================================================================
class PerfCounter 
{
	public static function measure(func:Void->Void, ?times:Int = 1):Float	
	{
		var timestart:Float = Date.now().getTime();
		while (times > 0)		
		{
			func();
			times--;
		}
		var timeend:Float = Date.now().getTime();
		return timeend - timestart;
	}
}