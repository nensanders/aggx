package lib.ha.aggx.vectorial;
//=======================================================================================================
import flash.Vector;
//=======================================================================================================
class VertexSequence
{
	private var _storage:Vector<IDistanceProvider>;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_storage = new Vector();
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_size():UInt { return _storage.length; }
	public inline var size(get_size, null):UInt;	
	//---------------------------------------------------------------------------------------------------
	public inline function add(vd:IDistanceProvider):Void
	{
		if (_storage.length > 1)
		{
			if (!(_storage[_storage.length - 2].calc(_storage[_storage.length - 1])))
			{
				removeLast();
			}
		}
		_storage[_storage.length] = vd;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function removeAll():Void
	{
		_storage.length = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function removeLast():Void
	{
		_storage.pop();
	}
	//---------------------------------------------------------------------------------------------------
	public inline function modifyLast(v:IDistanceProvider):Void
	{
		removeLast();
		_storage[_storage.length] = v;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function prev(idx:Int):IDistanceProvider
	{
		return _storage[(idx + _storage.length - 1) % _storage.length];
	}
	//---------------------------------------------------------------------------------------------------
	public inline function curr(idx:Int):IDistanceProvider
	{
		return _storage[idx];
	}
	//---------------------------------------------------------------------------------------------------
	public inline function next(idx:Int):IDistanceProvider
	{
		return _storage[(idx + _storage.length + 1) % _storage.length];
	}	
	//---------------------------------------------------------------------------------------------------
	public function close(closed:Bool):Void
	{
		while(_storage.length > 1)
		{
			if ((_storage[_storage.length - 2].calc(_storage[_storage.length - 1]))) break;
			var t = _storage[_storage.length - 1];
			removeLast();
			modifyLast(t);
		}

		if(closed)
		{
			while(_storage.length > 1)
			{
				if ((_storage[_storage.length - 1].calc(_storage[0]))) break;
				removeLast();
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function get(i:Int):IDistanceProvider
	{
		return _storage[i];
	}
	//---------------------------------------------------------------------------------------------------
	public inline function set(i:Int, val:IDistanceProvider):Void
	{
		_storage[i] = val;
	}
}