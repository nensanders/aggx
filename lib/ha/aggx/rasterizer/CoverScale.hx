package lib.ha.aggx.rasterizer;
//=======================================================================================================
class CoverScale 
{
	public static inline var COVER_SHIFT:UInt = 8;
	public static inline var COVER_SIZE:UInt = 1 << COVER_SHIFT;
	public static inline var COVER_MASK:UInt = COVER_SIZE-1;
	public static inline var COVER_NONE:UInt = 0;
	public static inline var COVER_FULL:UInt = COVER_MASK;
}