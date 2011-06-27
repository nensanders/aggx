package lib.ha.aggx.renderer;
//=======================================================================================================
import lib.ha.aggx.rasterizer.IScanline;
//=======================================================================================================
interface IRenderer 
{
	public function prepare():Void;
	public function render(sl:IScanline):Void;
}