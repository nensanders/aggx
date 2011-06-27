package lib.ha.aggx.rasterizer;
//=======================================================================================================
class PolySubpixelScale 
{
	public static inline var POLY_SUBPIXEL_SHIFT = 8;
	public static inline var POLY_SUBPIXEL_SCALE = 1 << POLY_SUBPIXEL_SHIFT;
	public static inline var POLY_SUBPIXEL_MASK = POLY_SUBPIXEL_SCALE-1;
}