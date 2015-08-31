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

package lib.ha.rfpx;
//=======================================================================================================
import flash.events.Event;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.Endian;
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