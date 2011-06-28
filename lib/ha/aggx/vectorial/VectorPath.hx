package lib.ha.aggx.vectorial;
//=======================================================================================================
import lib.ha.core.geometry.AffineTransformer;
import lib.ha.core.memory.Ref;
import lib.ha.core.math.Calc;
//=======================================================================================================
class VectorPath implements IVertexSource
{
	private var _vertices:VertexBlockStorage;
	private var _vertextIterator:UInt;
	//---------------------------------------------------------------------------------------------------
	public function new() 
	{
		_vertices = new VertexBlockStorage();
	}
	public function removeAll():Void { _vertices.removeAll(); _vertextIterator = 0; }
	//---------------------------------------------------------------------------------------------------
	public function freeAll():Void { _vertices.freeAll(); _vertextIterator = 0; }
	//---------------------------------------------------------------------------------------------------
	public function startNewPath():Int
	{
		if(!PathUtils.isStop(_vertices.lastCommand))
		{
			_vertices.addVertex(0.0, 0.0, PathCommands.STOP);
		}
		return _vertices.verticesCount;
	}
	//---------------------------------------------------------------------------------------------------
	public function relToAbs(x:FloatRef, y:FloatRef):Void
	{
		if(_vertices.verticesCount!=0)
		{
			var x2 = Ref.float1;
			var y2 = Ref.float2;
			if(PathUtils.isVertex(_vertices.getLastVertex(x2, y2)))
			{
				x.value += x2.value;
				y.value += y2.value;
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function moveTo(x:Float, y:Float):Void
	{
		_vertices.addVertex(x, y, PathCommands.MOVE_TO);
	}
	//---------------------------------------------------------------------------------------------------
	public function moveRel(dx:Float, dy:Float):Void
	{
		var rdx = Ref.float1;
		var rdy = Ref.float2;
		
		relToAbs(rdx.set(dx), rdy.set(dy));
		_vertices.addVertex(rdx.value, rdy.value, PathCommands.MOVE_TO);	
	}
	//---------------------------------------------------------------------------------------------------
	public function lineTo(x:Float, y:Float):Void
	{
		_vertices.addVertex(x, y, PathCommands.LINE_TO);
	}
	//---------------------------------------------------------------------------------------------------
	public function lineRel(dx:Float, dy:Float):Void
	{
		var rdx = Ref.float1.set(dx);
		var rdy = Ref.float2.set(dy);
		relToAbs(rdx, rdy);
		_vertices.addVertex(rdx.value, rdy.value, PathCommands.LINE_TO);
	}
	//---------------------------------------------------------------------------------------------------
	public function hlineTo(x:Float):Void
	{
		_vertices.addVertex(x, lastY, PathCommands.LINE_TO);
	}
	//---------------------------------------------------------------------------------------------------
	public function hlineRel(dx:Float)
	{
		var rdx = Ref.float1.set(dx);
		var rdy = Ref.float2;
		relToAbs(rdx, rdy);
		_vertices.addVertex(rdx.value, rdy.value, PathCommands.LINE_TO);
	}
	//---------------------------------------------------------------------------------------------------
	public function vlineTo(y:Float):Void
	{
		_vertices.addVertex(lastX, y, PathCommands.LINE_TO);
	}
	//---------------------------------------------------------------------------------------------------
	public function vlineRel(dy:Float):Void
	{
		var rdx = Ref.float1;
		var rdy = Ref.float2.set(dy);
		relToAbs(rdx, rdy);
		_vertices.addVertex(rdx.value, rdy.value, PathCommands.LINE_TO);
	}
	//---------------------------------------------------------------------------------------------------
	public function curve3(x_ctrl:Float, y_ctrl:Float, x_to:Float, y_to:Float):Void
	{
		_vertices.addVertex(x_ctrl, y_ctrl, PathCommands.CURVE3);
		_vertices.addVertex(x_to, y_to, PathCommands.CURVE3);
	}
	//---------------------------------------------------------------------------------------------------
	public function curve3Rel(dx_ctrl:Float, dy_ctrl:Float, dx_to:Float, dy_to:Float):Void
	{
		var rdx_ctrl = Ref.float1.set(dx_ctrl);
		var rdy_ctrl = Ref.float2.set(dy_ctrl);
		var rdx_to = Ref.float3.set(dx_to);
		var rdy_to = Ref.float4.set(dy_to);
		relToAbs(rdx_ctrl, rdy_ctrl);
		relToAbs(rdx_to, rdy_to);
		_vertices.addVertex(rdx_ctrl.value, rdy_ctrl.value, PathCommands.CURVE3);
		_vertices.addVertex(rdx_to.value, rdy_to.value, PathCommands.CURVE3);
	}
	//---------------------------------------------------------------------------------------------------
	public function curve3To(x_to:Float, y_to:Float):Void
	{
		var x0 = Ref.float1;
		var y0 = Ref.float2;
		if(PathUtils.isVertex(_vertices.getLastVertex(x0, y0)))
		{
			var x_ctrl = Ref.float3;
			var y_ctrl = Ref.float4;
			var cmd = _vertices.getPrevVertex(x_ctrl, y_ctrl);
			if(PathUtils.isCurve(cmd))
			{
				x_ctrl.value = x0.value + x0.value - x_ctrl.value;
				y_ctrl.value = y0.value + y0.value - y_ctrl.value;
			}
			else
			{
				x_ctrl.value = x0.value;
				y_ctrl.value = y0.value;
			}
			curve3(x_ctrl.value, y_ctrl.value, x_to, y_to);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function curve3RelTo(dx_to:Float, dy_to:Float):Void
	{
		var rdx_to = Ref.float1.set(dx_to);
		var rdy_to = Ref.float2.set(dy_to);
		relToAbs(rdx_to, rdy_to);
		curve3To(rdx_to.value, rdy_to.value);
	}
	//---------------------------------------------------------------------------------------------------
	public function curve4(x_ctrl1:Float, y_ctrl1:Float, x_ctrl2:Float, y_ctrl2:Float, x_to:Float, y_to:Float):Void
	{
		_vertices.addVertex(x_ctrl1, y_ctrl1, PathCommands.CURVE4);
		_vertices.addVertex(x_ctrl2, y_ctrl2, PathCommands.CURVE4);
		_vertices.addVertex(x_to, y_to, PathCommands.CURVE4);
	}
	//---------------------------------------------------------------------------------------------------
	public function curve4Rel(dx_ctrl1:Float, dy_ctrl1:Float, dx_ctrl2:Float, dy_ctrl2:Float, dx_to:Float, dy_to:Float):Void
	{
		var rdx_ctrl1 = Ref.float1.set(dx_ctrl1);
		var rdy_ctrl1 = Ref.float2.set(dy_ctrl1);
		var rdx_ctrl2 = Ref.float3.set(dx_ctrl2);
		var rdy_ctrl2 = Ref.float4.set(dy_ctrl2);	
		var rdx_to = Ref.float5.set(dx_to);
		var rdy_to = Ref.float6.set(dy_to);
		
		relToAbs(rdx_ctrl1, rdy_ctrl1);
		relToAbs(rdx_ctrl2, rdy_ctrl2);
		relToAbs(rdx_to, rdy_to);
		_vertices.addVertex(rdx_ctrl1.value, rdy_ctrl1.value, PathCommands.CURVE4);
		_vertices.addVertex(rdx_ctrl2.value, rdy_ctrl2.value, PathCommands.CURVE4);
		_vertices.addVertex(rdx_to.value, rdy_to.value, PathCommands.CURVE4);
	}
	//---------------------------------------------------------------------------------------------------
	public function curve4To(x_ctrl2:Float, y_ctrl2:Float, x_to:Float, y_to:Float):Void
	{
		var x0 = Ref.float1;
		var y0 = Ref.float2;
		if(PathUtils.isVertex(getLastVertex(x0, y0)))
		{
			var x_ctrl1 = Ref.float3;
			var y_ctrl1 = Ref.float4;
			var cmd = getPrevVertex(x_ctrl1, y_ctrl1);
			if(PathUtils.isCurve(cmd))
			{
				x_ctrl1.value = x0.value + x0.value - x_ctrl1.value;
				y_ctrl1.value = y0.value + y0.value - y_ctrl1.value;
			}
			else
			{
				x_ctrl1.value = x0.value;
				y_ctrl1.value = y0.value;
			}
			curve4(x_ctrl1.value, y_ctrl1.value, x_ctrl2, y_ctrl2, x_to, y_to);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function curve4RelTo(dx_ctrl2:Float, dy_ctrl2:Float, dx_to:Float, dy_to:Float):Void
	{
		var rdx_ctrl2 = Ref.float1.set(dx_ctrl2);
		var rdy_ctrl2 = Ref.float2.set(dy_ctrl2);
		var rdx_to = Ref.float3.set(dx_to);
		var rdy_to = Ref.float4.set(dy_to);
		
		relToAbs(rdx_ctrl2, rdy_ctrl2);
		relToAbs(rdx_to, rdy_to);
		curve4To(rdx_ctrl2.value, rdy_ctrl2.value, rdx_to.value, rdy_to.value);
	}	
	//---------------------------------------------------------------------------------------------------
	public inline function endPoly(flags:Int):Void
	{
		if(PathUtils.isVertex(_vertices.lastCommand))
		{
			_vertices.addVertex(0.0, 0.0, PathCommands.END_POLY | flags);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function closePolygon(flags:Int = 0):Void
	{
		endPoly(PathFlags.CLOSE | flags);
	}	
	//---------------------------------------------------------------------------------------------------
	public function concatPath(vs:IVertexSource, pathId:Int = 0)
	{
		var x = Ref.float1;
		var y = Ref.float2;
		var cmd:Int;
		vs.rewind(pathId);
		while(!PathUtils.isStop(cmd = vs.getVertex(x, y)))
		{
			_vertices.addVertex(x.value, y.value, cmd);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function joinPath(vs:IVertexSource, pathId:Int = 0)
	{
		var x = Ref.float1;
		var y = Ref.float2;
		
		var cmd:Int;
		vs.rewind(pathId);
		cmd = vs.getVertex(x, y);
		if(!PathUtils.isStop(cmd))
		{
			if(PathUtils.isVertex(cmd))
			{
				var x0 = Ref.float3;
				var y0 = Ref.float4;
				var cmd0 = getLastVertex(x0, y0);
				if(PathUtils.isVertex(cmd0))
				{
					if(Calc.distance(x.value, y.value, x0.value, y0.value) > Calc.VERTEX_DIST_EPSILON)
					{
						if(PathUtils.isMoveTo(cmd)) cmd = PathCommands.LINE_TO;
						_vertices.addVertex(x.value, y.value, cmd);
					}
				}
				else
				{
					if(PathUtils.isStop(cmd0))
					{
						cmd = PathCommands.MOVE_TO;
					}
					else
					{
						if(PathUtils.isMoveTo(cmd)) cmd = PathCommands.LINE_TO;
					}
					_vertices.addVertex(x.value, y.value, cmd);
				}
			}
			while(!PathUtils.isStop(cmd = vs.getVertex(x, y)))
			{
				_vertices.addVertex(x.value, y.value, PathUtils.isMoveTo(cmd) ? PathCommands.LINE_TO : cmd);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getLastVertex(x:FloatRef, y:FloatRef):Int
	{
		return _vertices.getLastVertex(x, y);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getPrevVertex(x:FloatRef, y:FloatRef):Int
	{
		return _vertices.getPrevVertex(x, y);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		//if (_vertextIterator >= _vertices.verticesCount) return PathCommands.STOP;			
		return (_vertextIterator >= _vertices.verticesCount) ? PathCommands.STOP : _vertices.getVertex(_vertextIterator++, x, y);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getVertexByIndex(idx:Int, x:FloatRef, y:FloatRef):Int
	{
		return _vertices.getVertex(idx, x, y);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function getCommand(idx:Int):Int
	{
		return _vertices.getCommand(idx);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function modifyVertex(idx:Int, x:Float, y:Float, ?cmd:Int):Void
	{
		_vertices.modifyVertex(idx, x, y, cmd);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function modifyCommand(idx:Int, cmd:Int):Void
	{
		_vertices.modifyCommand(idx, cmd);
	}
	//---------------------------------------------------------------------------------------------------
	public inline function rewind(pathId:UInt):Void
	{
		_vertextIterator = pathId;
	}
	//---------------------------------------------------------------------------------------------------
	//public function concatPoly(data:PtrFloat, num_points:Int, closed:Bool):Void
	//{
		//var poly = new PolyPlainAdaptor(data, num_points, closed);
		//concat_path(poly);
	//}
	//---------------------------------------------------------------------------------------------------
	//public function joinPoly(data:PtrFloat, num_points:Int, closed:Bool):Void
	//{
		//var poly = new PolyPlainAdaptor(data, num_points, closed);
		//join_path(poly);
	//}
	//---------------------------------------------------------------------------------------------------
	public function transform(trans:AffineTransformer, pathId:Int=0)
	{
		var numVer = _vertices.verticesCount;
		var i:UInt = pathId;
		while(i < numVer)
		{
			var x = Ref.float1;
			var y = Ref.float2;
			var cmd = _vertices.getVertex(pathId, x, y);
			if(PathUtils.isStop(cmd)) break;
			if(PathUtils.isVertex(cmd))
			{
				trans.transform(x, y);
				_vertices.modifyVertex(pathId, x.value, y.value);
			}
			i++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function transformAllPaths(trans:AffineTransformer):Void
	{
		var idx:UInt = 0;
		var numVer = _vertices.verticesCount;
		while (idx < numVer)		
		{
			var x = Ref.float1;
			var y = Ref.float2;
			if(PathUtils.isVertex(_vertices.getVertex(idx, x, y)))
			{
				trans.transform(x, y);
				_vertices.modifyVertex(idx, x.value, y.value);
			}
			idx++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	private function perceivePolygonOrientation(start:Int, end:Int):Int
	{
		var np = end - start;
		var area = 0.0;
		var i = 0;
		while(i < np)
		{
			var x1 = Ref.float1;
			var y1 = Ref.float2;
			var x2 = Ref.float3;
			var y2 = Ref.float4;
			_vertices.getVertex(start + i, x1, y1);
			_vertices.getVertex(start + (i + 1) % np, x2, y2);
			area += x1.value * y2.value - y1.value * x2.value;
			i++;
		}
		return (area < 0.0) ? PathFlags.CW : PathFlags.CCW;
	}
	//---------------------------------------------------------------------------------------------------
	public function invertPolygon(start:UInt, ?end:UInt):Void
	{
		if (end == null)		
		{
			while (start < _vertices.verticesCount &&
				!PathUtils.isVertex(_vertices.getCommand(start))) {++start; }			

			while (cast(start + 1) < _vertices.verticesCount &&
				PathUtils.isMoveTo(_vertices.getCommand(start)) &&
				PathUtils.isMoveTo(_vertices.getCommand(start + 1))) {++start; }

			end = start + 1;
			while(end < _vertices.verticesCount &&
				!PathUtils.isNextPoly(_vertices.getCommand(end))) {++end; }				
		}
		
		var tmp_cmd = _vertices.getCommand(start);

		--end;

		var i = start;
		while(i < end)
		{
			_vertices.modifyCommand(i, _vertices.getCommand(i + 1));
			i++;
		}

		_vertices.modifyCommand(end, tmp_cmd);

		while(end > start)
		{
			_vertices.swapVertices(start++, end--);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function arrangePolygonOrientation(start:UInt, orientation:Int):Int
	{
		if(orientation == PathFlags.NONE) return start;

		while (start < _vertices.verticesCount && !PathUtils.isVertex(_vertices.getCommand(start))) {++start; }

		while (cast (start + 1) < _vertices.verticesCount &&	
			PathUtils.isMoveTo(_vertices.getCommand(start)) &&			
			PathUtils.isMoveTo(_vertices.getCommand(start + 1))) {++start; }			

		var end:UInt = start + 1;
		while (end < _vertices.verticesCount &&	!PathUtils.isNextPoly(_vertices.getCommand(end))) {++end; }

		if(end - start > 2)
		{
			if(perceivePolygonOrientation(start, end) != orientation)
			{
				invertPolygon(start, end);
				var cmd;
				while(end < _vertices.verticesCount && PathUtils.isEndPoly(cmd = _vertices.getCommand(end)))
				{
					_vertices.modifyCommand(end++, PathUtils.setOrientation(cmd, orientation));
				}
			}
		}
		return end;
	}
	//---------------------------------------------------------------------------------------------------
	public function arrangeOrientations(start:UInt, orientation:Int):Int
	{
		if(orientation != PathFlags.NONE)
		{
			while(start < _vertices.verticesCount)
			{
				start = arrangePolygonOrientation(start, orientation);
				if(PathUtils.isStop(_vertices.getCommand(start)))
				{
					++start;
					break;
				}
			}
		}
		return start;
	}
	//---------------------------------------------------------------------------------------------------
	public function arrangeOrientationsAllPaths(orientation:Int):Void
	{
		if(orientation != PathFlags.NONE)
		{
			var start:UInt = 0;
			while(start < _vertices.verticesCount)
			{
				start = arrangeOrientations(start, orientation);
			}
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function flipX(x1:Float, x2:Float):Void
	{
		var i:UInt = 0;
		var x = Ref.float1;
		var y = Ref.float2;
		var z = _vertices.verticesCount;
		while (i < z)		
		{
			var cmd = _vertices.getVertex(i, x, y);
			if(PathUtils.isVertex(cmd))
			{
				_vertices.modifyVertex(i, x2 - x.value + x1, y.value);
			}
			i++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function flipY(y1:Float, y2:Float):Void
	{
		var i:UInt = 0;
		var x = Ref.float1;
		var y = Ref.float2;
		var z = _vertices.verticesCount;
		while (i < z)		
		{
			var cmd = _vertices.getVertex(i, x, y);
			if(PathUtils.isVertex(cmd))
			{
				_vertices.modifyVertex(i, x.value, y2 - y.value + y1);
			}
			i++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function translate(dx:Float, dy:Float, pathId:Int):Void
	{
		var num_ver = _vertices.verticesCount;
		var i:UInt = pathId;
		while(i < num_ver)
		{
			var x = Ref.float1;
			var y = Ref.float2;
			var cmd = _vertices.getVertex(pathId, x, y);
			if(PathUtils.isStop(cmd)) break;
			if(PathUtils.isVertex(cmd))
			{
				x.value += dx;
				y.value += dy;
				_vertices.modifyVertex(pathId, x.value, y.value);
			}
			i++;
		}
	}

	//------------------------------------------------------------------------
	public function translateAllPaths(dx:Float, dy:Float):Void
	{
		var idx:UInt = 0;
		var num_ver = _vertices.verticesCount;
		while(idx < num_ver)
		{
			var x = Ref.float1;
			var y = Ref.float2;
			if(PathUtils.isVertex(_vertices.getVertex(idx, x, y)))
			{
				x.value += dx;
				y.value += dy;
				_vertices.modifyVertex(idx, x.value, y.value);
			}
			idx++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastX():Float { return _vertices.lastX; }
	public inline var lastX(get_lastX, null):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_lastY():Float { return _vertices.lastY; }
	public inline var lastY(get_lastY, null):Float;	
	//---------------------------------------------------------------------------------------------------
	private inline function get_verticesCount():Int { return _vertices.verticesCount; }
	public inline var verticesCount(get_verticesCount, null):Int;
}