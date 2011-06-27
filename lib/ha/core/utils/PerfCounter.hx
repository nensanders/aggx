package lib.ha.core.utils;
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