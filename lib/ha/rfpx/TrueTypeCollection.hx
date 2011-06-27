package lib.ha.rfpx;
//=======================================================================================================
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.Vector;
import haxe.io.BytesData;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.MemoryManager;
import lib.ha.rfpx.data.TTCHeader;
//=======================================================================================================
class TrueTypeCollection extends EventDispatcher
{
	private var _data:MemoryBlock;
	private var _fonts:Vector<TrueTypeFont>;
	//---------------------------------------------------------------------------------------------------
	public function getFont(i:Int):TrueTypeFont
	{
		return _fonts[i];
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_fontCount():UInt { return _fonts.length; }
	public inline var fontCount(get_fontCount, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public static function create(file:URLStream, pathName:String = "" ):TrueTypeCollection
	{
		var fc = new TrueTypeCollection();
		fc.read(file, pathName);
		return fc;
	}
	//---------------------------------------------------------------------------------------------------
	private function read(file:URLStream, pathName:String = ""):Void
	{
		var bytes = new BytesData();
		file.readBytes(bytes, 0, file.bytesAvailable);
		_data = MemoryManager.mallocEx(bytes);
		if(TTCHeader.isTTC(_data))
		{
			//_ttcHeader = new TTCHeader(_data);
			//_fonts = new Vector( _ttcHeader.getDirectoryCount());
			//var i = 0, z = _ttcHeader.getDirectoryCount();
			//while (i < z)
			//{
				//_fonts[i] = new TrueTypeFont(this);
				//_fonts[i].read(_data, _ttcHeader.getTableDirectory(i), 0);
				//++i;
			//}
		} else {
			// This is a standalone font
			_fonts = new Vector(1);
			_fonts[0] = new TrueTypeFont(this);
			_fonts[0].read(_data.ptr);
		}
		file.close();
	}
	//---------------------------------------------------------------------------------------------------
}