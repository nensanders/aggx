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
	private static inline var BLOCK_SIZE = 128;
	private static inline var COORDS_BLOCK_SIZE = 16 * BLOCK_SIZE;
	private static inline var COMMANDS_BLOCK_SIZE = 1 * BLOCK_SIZE;
	//---------------------------------------------------------------------------------------------------
	private var _verticesCount:UInt;
	private var _coords:MemoryBlock;
	private var _commands:MemoryBlock;
	private var _allocatedCount:UInt;
	private var _coordsStartPtr:Pointer;
	private var _commandsStartPtr:Pointer;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_coords = MemoryManager.malloc(COORDS_BLOCK_SIZE);
		_commands = MemoryManager.malloc(COMMANDS_BLOCK_SIZE);
		_coordsStartPtr = _coords.ptr;
		_commandsStartPtr = _commands.ptr;
		_allocatedCount = BLOCK_SIZE;
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
		var ret = 0.0;
		if(_verticesCount!=0)
		{
			var idx = (_verticesCount - 1) << 4;
			ret = (_coordsStartPtr + idx).getDouble();
		}
		return ret;
	}
	public inline var lastX(get_lastX, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastY():Float
	{
		var ret = 0.0;
		if(_verticesCount!=0)
		{
			var idx = (_verticesCount - 1) << 4;
			ret = (_coordsStartPtr + idx + 8).getDouble();//_coords.ptr.getDouble(_coordsStartPtr + idx + 8);
		}
		return ret;
	}
	public inline var lastY(get_lastY, null):Float;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_verticesCount():UInt { return _verticesCount; }
	public inline var verticesCount(get_verticesCount, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public function removeAll():Void
	{
		_verticesCount = 0;
		_commands.ptr = _commandsStartPtr;
		_coords.ptr = _coordsStartPtr;
	}
	//---------------------------------------------------------------------------------------------------
	public function freeAll():Void
	{
		_coords = null;
		_commands = null;
		_verticesCount = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function addVertex(x:Float, y:Float, cmd:Byte):Void
	{
		_verticesCount++;
		checkAllocation();
		var ptr = _coords.ptr;
		ptr.setDouble(x);
		ptr += 8;
		ptr.setDouble(y);
		ptr += 8;
		_coords.ptr = ptr;
		_commands.ptr.setByte(cmd);
		_commands.ptr++;
	}
	//---------------------------------------------------------------------------------------------------
	private function checkAllocation():Void
	{
		if (_verticesCount > _allocatedCount)
		{
			_allocatedCount += BLOCK_SIZE;
			MemoryManager.expand(_coords, COORDS_BLOCK_SIZE);
			MemoryManager.expand(_commands, COMMANDS_BLOCK_SIZE);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function modifyVertex(idx:Int, x:Float, y:Float, ?cmd:Int)
	{
		var ptr = _coordsStartPtr + (idx << 4);
		ptr.setDouble(x);
		ptr += 8;
		ptr.setDouble(y);
		if (cmd != null) 
		{
			(_commandsStartPtr + idx).setByte(cmd);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function modifyCommand(idx:Int, cmd:Int):Void
	{
		(_commandsStartPtr + idx).setByte(cmd);
	}
	//---------------------------------------------------------------------------------------------------
	public function swapVertices(v1:Int, v2:Int):Void
	{
		var i1 = _coordsStartPtr + (v1 << 4);
		var i2 = _coordsStartPtr + (v2 << 4);
		var tmpCoord = i1.getDouble();
		i1.setDouble(i2.getDouble());
		i2.setDouble(tmpCoord);
		
		i1 += 8;
		i2 += 8;
		tmpCoord = i1.getDouble();
		i1.setDouble(i2.getDouble());
		i2.setDouble(tmpCoord);
		
		var tmpCmd = (_commandsStartPtr + v1).getByte();
		(_commandsStartPtr + v1).setByte((_commandsStartPtr + v2).getByte());
		(_commandsStartPtr + v2).setByte(tmpCmd);
	}
	//---------------------------------------------------------------------------------------------------
	public function getLastVertex(x:FloatRef, y:FloatRef):Int
	{
		if(_verticesCount != 0) return getVertex(_verticesCount - 1, x, y);
		return PathCommands.STOP;
	}
	//------------------------------------------------------------------------
	public function getPrevVertex(x:FloatRef, y:FloatRef):Int
	{
		if(_verticesCount > 1) return getVertex(_verticesCount - 2, x, y);
		return PathCommands.STOP;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(idx:Int, x:FloatRef, y:FloatRef):UInt
	{
		//if (idx == 34) 
		//{
			//var stop = 1;
		//}
		var ptr = _coordsStartPtr + (idx << 4);
		x.value = ptr.getDouble();
		ptr += 8;
		y.value = ptr.getDouble();
		return (_commandsStartPtr + idx).getByte();
	}
	//---------------------------------------------------------------------------------------------------
	public function getCommand(idx:Int):Int
	{
		return (_commandsStartPtr + idx).getByte();
	}
	//---------------------------------------------------------------------------------------------------
}