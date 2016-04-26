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

package aggx.vectorial;
//=======================================================================================================
import haxe.ds.Vector;
import aggx.core.memory.Ref;
//=======================================================================================================
class SimplePolygonVertexSource implements IVertexSource
{
	private var m_polygon:Vector<Float>;
	private var m_num_points:UInt;
	private var m_vertex:UInt;
	private var m_roundoff:Bool;
	private var m_close:Bool;
	//---------------------------------------------------------------------------------------------------
	public function new(polygon:Vector<Float>, numPoints:UInt, roundoff:Bool = false, close:Bool = false)
	{
		m_polygon = polygon;
		m_num_points = numPoints;
		m_roundoff = roundoff;
		m_close = close;
		m_vertex = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void 
	{
		m_vertex = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt 
	{
		if(m_vertex > m_num_points) return PathCommands.STOP;
		if(m_vertex == m_num_points) 
		{
			++m_vertex;
			return PathCommands.END_POLY | (m_close ? PathFlags.CLOSE : 0);
		}
		x.value = m_polygon[m_vertex * 2];
		y.value = m_polygon[m_vertex * 2 + 1];
		if(m_roundoff)
		{
			x.value = x.value + 0.5;
			y.value = y.value + 0.5;
		}
		++m_vertex;
		return (m_vertex == 1) ? PathCommands.MOVE_TO : PathCommands.LINE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_close():Bool { return m_close; }
	private inline function set_close(value:Bool):Bool { return m_close = value; }
	public var close(get, set):Bool;
	//---------------------------------------------------------------------------------------------------
	
}