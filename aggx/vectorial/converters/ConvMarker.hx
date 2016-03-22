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
import aggx.vectorial.generators.IMarkerGenerator;
import aggx.vectorial.IMarkerShape;
import aggx.vectorial.PathCommands;
import aggx.vectorial.PathUtils;
import aggx.core.geometry.AffineTransformer;
import aggx.core.memory.Ref;
//=======================================================================================================
class ConvMarker implements IVertexSource
{
	private static var INITIAL = 0;
	private static var MARKERS = 1;
	private static var POLYGON = 2;
	private static var STOP = 3;
	//---------------------------------------------------------------------------------------------------
	private var _markerLocator:IMarkerGenerator;
	private var _markerShapes:IMarkerShape;
	private var _transform:AffineTransformer;
	private var _matrix:AffineTransformer;
	private var _status:Int;
	private var _marker:Int;
	private var _numMarkers:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(ml:IMarkerGenerator, ms:IMarkerShape) 
	{
		_markerLocator = ml;
		_markerShapes = ms;
		_status = INITIAL;
		_numMarkers = 0;
		_marker = 0;
		_matrix = new TransAffine();
		_transform = new TransAffine();
	}
	//---------------------------------------------------------------------------------------------------
	public function rewind(pathId:UInt):Void
	{
		_status = INITIAL;
		_marker = 0;
		_numMarkers = 1;
	}
	//---------------------------------------------------------------------------------------------------
	public function vertex(x:FloatRef, y:FloatRef):UInt
	{
		var cmd = PathCommands.MOVE_TO;
		var x1 = Ref.float(), y1 = Ref.float(), x2 = Ref.float(), y2 = Ref.float();

		while(!PathUtils.isStop(cmd))
		{
			switch(_status)
			{
			case INITIAL:
				if(_numMarkers == 0)
				{
					cmd = PathCommands.STOP;
				}
				else 
				{
					_markerLocator.rewind(_marker);
					++_marker;
					_numMarkers = 0;
					_status = MARKERS;
				}

			case MARKERS:
				if(PathUtils.isStop(_markerLocator.vertex(x1, y1)))
				{
					_status = INITIAL;
				}
				else if(PathUtils.isStop(_markerLocator.vertex(x2, y2)))
				{
					_status = INITIAL;
				}
				else 
				{
					++_numMarkers;
					_matrix = AffineTransformer.of(_transform);
					_matrix = _matrix.multiply(AffineTransformer.rotator(Math.atan2(y2.value - y1.value, x2.value - x1.value)));
					_matrix = _matrix.multiply(AffineTransformer.translator(x1.value, y1.value));
					_markerShapes.rewind(_marker - 1);
					_status = POLYGON;					
				}

			case POLYGON:
				cmd = _markerShapes.vertex(x, y);
				if(PathUtils.isStop(cmd))
				{
					cmd = PathCommands.MOVE_TO;
					_status = MARKERS;
				}
				else 
				{
					_matrix.transform(x, y);
					return cmd;	
				}

			case STOP:
				cmd = PathCommands.STOP;
			}
		}
		return cmd;
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_transform():AffineTransformer { return _transform; }
	public var transform(get, null):AffineTransformer;
}