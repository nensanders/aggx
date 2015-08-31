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

package lib.ha.aggx.vectorial;
//=======================================================================================================
import lib.ha.core.utils.ArrayUtil;
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.MemoryBlock;
import lib.ha.core.memory.MemoryManager;
import lib.ha.core.memory.Pointer;
import lib.ha.core.memory.Ref;
import lib.ha.core.memory.MemoryReader;
using lib.ha.core.memory.MemoryReader;
import lib.ha.core.memory.MemoryWriter;
using lib.ha.core.memory.MemoryWriter;
using lib.ha.core.utils.ArrayUtil;
//=======================================================================================================
class VertexBlockStorage 
{
	private static inline var BLOCK_SIZE = 256;
	//---------------------------------------------------------------------------------------------------
	private var _verticesCount:UInt;
	private var _allocatedCount:UInt;
	private var _coordsX:Array<Float>;
	private var _coordsY:Array<Float>;
	private var _commands:Array<Byte>;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_allocatedCount = BLOCK_SIZE;
		_coordsX = ArrayUtil.alloc(BLOCK_SIZE);
		_coordsY = ArrayUtil.alloc(BLOCK_SIZE);
		_commands = ArrayUtil.alloc(BLOCK_SIZE);
		_verticesCount = 0;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastCommand():Int
	{
		var cmd = PathCommands.STOP;
		if(_verticesCount != 0) cmd = getCommand(_verticesCount - 1);
		return cmd;
	}
	public var lastCommand(get, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastX():Float
	{
		return _verticesCount != 0 ? _coordsX[_verticesCount - 1] : 0.0;
	}
	public var lastX(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastY():Float
	{
		return _verticesCount != 0 ? _coordsY[_verticesCount - 1] : 0.0;
	}
	public var lastY(get, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_verticesCount():UInt { return _verticesCount; }
	public var verticesCount(get, null):UInt;
	//---------------------------------------------------------------------------------------------------
	public inline function removeAll():Void
	{
		_verticesCount = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function freeAll():Void
	{
        _coordsX.shrink(0);
		_coordsY.shrink(0);
		_commands.shrink(0);

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

            _coordsX[_coordsX.length - 1 + BLOCK_SIZE] = 0.0;
			_coordsY[_coordsY.length - 1 + BLOCK_SIZE] = 0.0;
			_commands[_commands.length - 1 + BLOCK_SIZE] = 0;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function modifyVertex(idx:Int, x:Float, y:Float, ?cmd:Int)
	{
		_coordsX[idx] = x;
		_coordsY[idx] = y;

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
		x.value = _coordsX[idx];
		y.value = _coordsY[idx];
		return _commands[idx];
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getCommand(idx:Int):Int
	{
		return _commands[idx];
	}
}