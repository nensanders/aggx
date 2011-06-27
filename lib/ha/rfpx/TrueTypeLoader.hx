package lib.ha.rfpx;
//=======================================================================================================
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.Endian;
import flash.Vector;
import haxe.io.BytesData;
import lib.ha.core.utils.PerfCounter;
//=======================================================================================================
class TrueTypeLoader 
{
	private var _stream:URLStream;
	private var _path:String;
	//---------------------------------------------------------------------------------------------------
	public function new(VectorPath:String)
	{
		if (VectorPath != "")
		{
			_path = VectorPath;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function load(onLoadComplete:TrueTypeCollection->Void):Void	
	{
		_stream = new URLStream();
		var self = this;
		_stream.addEventListener( Event.COMPLETE, function(e:Event)
		{
			var size = self._stream.bytesAvailable;
			var fc = TrueTypeCollection.create(self._stream);
			onLoadComplete(fc);
		});
		
		var fontReq:URLRequest = new URLRequest(_path);
		try
		{
			_stream.load( fontReq );
			throw "FontLoader failed to load the file";
		}
		catch ( error:String )
		{
		}
	}
}