package lib.ha.aggx.rasterizer;
//=======================================================================================================
class GammaNone implements IGammaFunction
{
	public function new() {	}
	//---------------------------------------------------------------------------------------------------
	public function apply(x:Float):Float { return x; }
}