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

package aggx.vectorial.converters;
//=======================================================================================================
import aggx.vectorial.QuadCurve;
import aggx.vectorial.CubicCurve;
import aggx.vectorial.IVertexSource;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathUtils;
import aggx.core.memory.Ref;
//=======================================================================================================
class ConvCurve implements IVertexSource
{
	private var _source:IVertexSource;
	private var _lastX:Float;
	private var _lastY:Float;
	private var _curve3:QuadCurve;
	private var _curve4:CubicCurve;
	//---------------------------------------------------------------------------------------------------
	public function new(?source:IVertexSource) 
	{
		_source = source;
		_curve3 = new QuadCurve();
		_curve4 = new CubicCurve();
		_lastX = 0;
		_lastY = 0;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach(source:IVertexSource):Void
	{
		_source = source;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationScale():Float { return _curve4.approximationScale; }
	private inline function set_approximationScale(value:Float):Float
	{
		_curve3.approximationScale = value;
		_curve4.approximationScale = value;
		return value;
	}
	public var approximationScale(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_approximationMethod():Int { return _curve4.approximationMethod; }
	private inline function set_approximationMethod(value:Int):Int
	{
		_curve3.approximationMethod = value;
		_curve4.approximationMethod = value;
		return value;
	}
	public var approximationMethod(get, set):Int;
	//---------------------------------------------------------------------------------------------------	
	private inline function get_angleTolerance():Float { return _curve4.angleTolerance; }
	private inline function set_angleTolerance(value:Float):Float
	{
		_curve3.angleTolerance = value;
		_curve4.angleTolerance = value;
		return value;
	}
	public var angleTolerance(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	private inline function get_cuspLimit():Float { return _curve4.cuspLimit; }
	private inline function set_cuspLimit(value:Float):Float
	{
		_curve3.cuspLimit = value;
		_curve4.cuspLimit = value;
		return value;
	}
	public var cuspLimit(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt)
	{
		_source.rewind(pathId);
		_lastX = 0.0;
		_lastY = 0.0;
		_curve3.reset();
		_curve4.reset();
	}
	//---------------------------------------------------------------------------------------------------
	public function getVertex(x:FloatRef, y:FloatRef):UInt
	{
		if(!PathUtils.isStop(_curve3.getVertex(x, y)))
		{
			_lastX = x.value;
			_lastY = y.value;
			return PathCommands.LINE_TO;
		}

		if(!PathUtils.isStop(_curve4.getVertex(x, y)))
		{
			_lastX = x.value;
			_lastY = y.value;
			return PathCommands.LINE_TO;
		}

		var ct2_x = Ref.getFloat();
		var ct2_y = Ref.getFloat();
		var end_x = Ref.getFloat();
		var end_y = Ref.getFloat();

		var cmd = _source.getVertex(x, y);
		switch(cmd)
		{
		case PathCommands.CURVE3:
			_source.getVertex(end_x, end_y);

			_curve3.init(_lastX, _lastY, x.value, y.value, end_x.value, end_y.value);

            Ref.putFloat(ct2_x); // Wasn't used in this case;
            Ref.putFloat(ct2_y); // Wasn't used in this case;
            Ref.putFloat(end_x);
            Ref.putFloat(end_y);

			_curve3.getVertex(x, y);
			_curve3.getVertex(x, y);
			cmd = PathCommands.LINE_TO;

		case PathCommands.CURVE4:
            _source.getVertex(ct2_x, ct2_y);
            _source.getVertex(end_x, end_y);

			_curve4.init(_lastX, _lastY, x.value, y.value, ct2_x.value, ct2_y.value, end_x.value, end_y.value);

            Ref.putFloat(ct2_x);
            Ref.putFloat(ct2_y);
            Ref.putFloat(end_x);
            Ref.putFloat(end_y);

			_curve4.getVertex(x, y);
			_curve4.getVertex(x, y);
			cmd = PathCommands.LINE_TO;
		}
		_lastX = x.value;
		_lastY = y.value;
		return cmd;
	}	
}