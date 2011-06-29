package lib.ha.aggx.vectorial;
//=======================================================================================================
import flash.Vector;
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.MemoryManager;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReader;
using lib.ha.core.memory.MemoryReader;
import lib.ha.core.memory.MemoryWriter;
using lib.ha.core.memory.MemoryWriter;
//=======================================================================================================
class VertexBlockStorage 
{
	private static inline var BLOCK_SIZE = 256;
	//---------------------------------------------------------------------------------------------------
	private var _verticesCount:UInt;
	private var _allocatedCount:UInt;
	private var _coordsX:Vector<Float>;
	private var _coordsY:Vector<Float>;
	private var _commands:Vector<Byte>;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_allocatedCount = BLOCK_SIZE;
		_coordsX = new Vector(BLOCK_SIZE);
		_coordsY = new Vector(BLOCK_SIZE);
		_commands = new Vector(BLOCK_SIZE);
		_verticesCount = 0;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastCommand():Int
	{
		var cmd = PathCommands.STOP;
		if(_verticesCount != 0) cmd = getCommand(_verticesCount - 1);
		return cmd;
	}
	public inline var lastCommand(get_lastCommand, null):Int;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastX():Float
	{
		return _verticesCount != 0 ? _coordsX[_verticesCount - 1] : 0.0;
	}
	public inline var lastX(get_lastX, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastY():Float
	{
<<<<<<< .mine
		return _verticesCount != 0 ? _coordsY[_verticesCount - 1] : 0.0;
=======
		var ret = 0.0;
		if(_verticesCount!=0)
		{
			var idx = (_verticesCount - 1) << 4;
			ret = (_coordsStartPtr + idx + 8).getDouble();
		}
		return ret;
>>>>>>> .r9
	}
	public inline var lastY(get_lastY, null):Float;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_verticesCount():UInt { return _verticesCount; }
	public inline var verticesCount(get_verticesCount, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public inline function removeAll():Void
	{
		_verticesCount = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function freeAll():Void
	{
		_coordsX.length = 0;
		_coordsY.length = 0;
		_commands.length = 0;
		_verticesCount = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function addVertex(x:Float, y:Float, cmd:Byte):Void
	{
		checkAllocation();
		_coordsX[_verticesCount] = x;
		_coordsY[_verticesCount] = y;
		_commands[_verticesCount] = cmd;
		_verticesCount++;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function checkAllocation():Void
	{
		if (_verticesCount > _allocatedCount)
		{
			_allocatedCount += BLOCK_SIZE;
			
			_coordsX.length += BLOCK_SIZE;
			_coordsY.length += BLOCK_SIZE;
			_commands.length += BLOCK_SIZE;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function modifyVertex(idx:Int, x:Float, y:Float, ?cmd:Int)
	{
<<<<<<< .mine
		_coordsX[idx] = x;
		_coordsY[idx] = y;
=======
		(_coordsStartPtr + (idx << 4)).setDouble(x);
		(_coordsStartPtr + (idx << 4) + 8).setDouble(y);
>>>>>>> .r9
		if (cmd != null) 
		{
			_commands[idx] = cmd;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function modifyCommand(idx:Int, cmd:Int):Void
	{
		_commands[idx] = cmd;
	}
	//---------------------------------------------------------------------------------------------------
	public function swapVertices(v1:Int, v2:Int):Void
	{
		var v0 = _coordsX[v1];
		_coordsX[v1] = _coordsX[v2];
		_coordsX[v2] = v0;
		
		v0 = _coordsY[v1];
		_coordsY[v1] = _coordsY[v2];
		_coordsY[v2] = v0;
		
		var c = _commands[v1];
		_commands[v1] = _commands[v2];
		_commands[v2] = c;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getLastVertex(x:FloatRef, y:FloatRef):Int
	{
		return (_verticesCount != 0) ? getVertex(_verticesCount - 1, x, y) : PathCommands.STOP;
	}
	//------------------------------------------------------------------------
	public inline function getPrevVertex(x:FloatRef, y:FloatRef):Int
	{
		return (_verticesCount > 1) ? getVertex(_verticesCount - 2, x, y) : PathCommands.STOP;
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getVertex(idx:Int, x:FloatRef, y:FloatRef):UInt
	{
<<<<<<< .mine
		x.value = _coordsX[idx];
		y.value = _coordsY[idx];
		return _commands[idx];
=======
		x.value = (_coordsStartPtr + (idx << 4)).getDouble();
		y.value = (_coordsStartPtr + (idx << 4) + 8).getDouble();
		return (_commandsStartPtr + idx).getByte();
>>>>>>> .r9
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getCommand(idx:Int):Int
	{
		return _commands[idx];
	}
}