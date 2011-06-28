package lib.ha.aggx.rasterizer;
//=======================================================================================================
import flash.Vector;
import lib.ha.aggx.vectorial.IVertexSource;
import lib.ha.aggx.vectorial.PathUtils;
import lib.ha.core.memory.Byte;
import lib.ha.core.memory.Ref;
//=======================================================================================================
class ScanlineRasterizer implements IRasterizer
{	
	private static inline var AA_SHIFT = 8;
	private static inline var AA_SCALE = 1 << AA_SHIFT;
	private static inline var AA_MASK = AA_SCALE-1;
	private static inline var AA_SCALE2 = AA_SCALE * 2;
	private static inline var AA_MASK2 = AA_SCALE2 - 1;
	//---------------------------------------------------------------------------------------------------
	private static inline var STATUS_INITIAL = 0;
	private static inline var STATUS_MOVE_TO = 1;
	private static inline var STATUS_LINE_TO = 2;
	private static inline var STATUS_CLOSED = 3;
	//---------------------------------------------------------------------------------------------------
	private var _outline:PixelCellRasterizer;
	private var _clipper:ClippingScanlineRasterizer;
	private var _gamma:Vector<Byte>;
	private var _fillingRule:Int;
	private var _isAutoClose:Bool;
	private var _startX:Float;
	private var _startY:Float;
	private var _status:Int;
	private var _scanY:Int;
	//---------------------------------------------------------------------------------------------------
	public function new(?gammaFunction:IGammaFunction)
	{
		_outline = new PixelCellRasterizer();
		_clipper = new ClippingScanlineRasterizer();
		_isAutoClose = true;
		_startX = 0;
		_startY = 0;
		_status = STATUS_INITIAL;
		_fillingRule = FillingRule.FILL_NON_ZERO;
		_gamma = new Vector(AA_SCALE);
		if (gammaFunction == null) 
		{
			var i = 0;
			while (i < AA_SCALE)
			{
				_gamma[i] = i;
				i++;
			}
		}
		else 
		{
			gamma(gammaFunction);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function gamma(gammaFunction:IGammaFunction):Void
	{
		var i = 0;
		while (i < AA_SCALE)
		{
			_gamma[i] = Std.int(gammaFunction.apply((i / AA_MASK)) * AA_MASK);
			i++;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function applyGamma(cover:Byte):Int
	{
		return _gamma[cover];
	}
	//---------------------------------------------------------------------------------------------------
	private inline function get_fillingRule():Int { return _fillingRule; }
	private inline function set_fillingRule(value:Int):Int { return _fillingRule = value; }
	public inline var fillingRule(get_fillingRule, set_fillingRule):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_minX():Int { return _outline.minX; }
	public inline var minX(get_minX, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_minY():Int { return _outline.minY; }
	public inline var minY(get_minY, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxX():Int { return _outline.maxX; }
	public inline var maxX(get_maxX, null):Int;
	//---------------------------------------------------------------------------------------------------
	private inline function get_maxY():Int { return _outline.maxY; }
	public inline var maxY(get_maxY, null):Int;
	//---------------------------------------------------------------------------------------------------
	public function addPath(vs:IVertexSource, pathId:Int = 0)
	{
		var x = Ref.float1;
		var y = Ref.float2;
		
		var cmd:Int;
		vs.rewind(pathId);
		if(_outline.isSorted) reset();
		while(!PathUtils.isStop(cmd = vs.getVertex(x, y)))
		{
			addVertex(x.value, y.value, cmd);
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function calculateAlpha(area:Int):Int
	{
		var cover = area >> (PolySubpixelScale.POLY_SUBPIXEL_SHIFT * 2 + 1 - AA_SHIFT);

		if(cover < 0) cover = -cover;
		if(_fillingRule == FillingRule.FILL_EVEN_ODD)
		{
			cover &= AA_MASK2;
			if(cover > AA_SCALE)
			{
				cover = AA_SCALE2 - cover;
			}
		}
		if(cover > AA_MASK) cover = AA_MASK;
		return _gamma[cover];
	}
	//---------------------------------------------------------------------------------------------------
	public function sweepScanline(sl:IScanline):Bool
	{
		while(true)
		{
			if(_scanY > _outline.maxY) return false;
			sl.resetSpans();
			var numCells = _outline.getScanlineCellsCount(_scanY);
			var cells = _outline.getScanlineCells(_scanY);
			var cover = 0;

			while(numCells != 0)
			{
				var currentCell = cells.data[cells.offset];
				var x = currentCell.x;
				var area = currentCell.area;
				var alpha:Int;

				cover += currentCell.cover;

				while(--numCells != 0)
				{
					currentCell = cells.data[++cells.offset];
					if(currentCell.x != x) break;
					area += currentCell.area;
					cover += currentCell.cover;
				}

				if(area != 0)
				{
					alpha = calculateAlpha((cover << (PolySubpixelScale.POLY_SUBPIXEL_SHIFT + 1)) - area);
					if(alpha != 0)
					{
						sl.addCell(x, alpha);
					}
					x++;
				}

				if (numCells != 0 && currentCell.x > x)
				{
					alpha = calculateAlpha(cover << (PolySubpixelScale.POLY_SUBPIXEL_SHIFT + 1));
					if(alpha != 0)
					{
						sl.addSpan(x, currentCell.x - x, alpha);
					}
				}
			}

			if(sl.spanCount != 0) break;
			++_scanY;
		}

		sl.finalize(_scanY);
		++_scanY;
		return true;
	}
	//---------------------------------------------------------------------------------------------------
	public function reset():Void
	{
		_outline.reset();
		_status = STATUS_INITIAL;
	}
	//---------------------------------------------------------------------------------------------------
	public function setClippingBounds(x1:Float, y1:Float, x2:Float, y2:Float):Void
	{
		reset();
		_clipper.setClippingBounds(ClippingScanlineRasterizer.upscale(x1), ClippingScanlineRasterizer.upscale(y1), ClippingScanlineRasterizer.upscale(x2), ClippingScanlineRasterizer.upscale(y2));
	}
	//---------------------------------------------------------------------------------------------------
	public function resetClipping():Void
	{
		reset();
		_clipper.resetClipping();
	}
	//---------------------------------------------------------------------------------------------------
	public function closePolygon():Void
	{
		if(_status == STATUS_LINE_TO)
		{
			_clipper.lineTo(_outline, _startX, _startY);
			_status = STATUS_CLOSED;
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function moveTo(x:Int, y:Int):Void
	{
		if(_outline.isSorted) reset();
		if(_isAutoClose) closePolygon();
		_clipper.moveTo(_startX = ClippingScanlineRasterizer.downscale(x), _startY = ClippingScanlineRasterizer.downscale(y));
		_status = STATUS_MOVE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public function lineTo(x:Int, y:Int):Void
	{
		_clipper.lineTo(_outline, ClippingScanlineRasterizer.downscale(x), ClippingScanlineRasterizer.downscale(y));
		_status = STATUS_LINE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public function moveToD(x:Float, y:Float):Void
	{
		if(_outline.isSorted) reset();
		if(_isAutoClose) closePolygon();
		_clipper.moveTo(_startX = ClippingScanlineRasterizer.upscale(x), _startY = ClippingScanlineRasterizer.upscale(y));
		_status = STATUS_MOVE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public function lineToD(x:Float, y:Float):Void
	{
		_clipper.lineTo(_outline, ClippingScanlineRasterizer.upscale(x), ClippingScanlineRasterizer.upscale(y));
		_status = STATUS_LINE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public function addVertex(x:Float, y:Float, cmd:Int):Void
	{
		if(PathUtils.isMoveTo(cmd))
		{
			moveToD(x, y);
		}
		else
		if(PathUtils.isVertex(cmd))
		{
			lineToD(x, y);
		}
		else
		if(PathUtils.isClose(cmd))
		{
			closePolygon();
		}
	}
	//---------------------------------------------------------------------------------------------------
	public function edge(x1:Int, y1:Int, x2:Int, y2:Int):Void
	{
		if(_outline.isSorted) reset();
		_clipper.moveTo(ClippingScanlineRasterizer.downscale(x1), ClippingScanlineRasterizer.downscale(y1));
		_clipper.lineTo(_outline, ClippingScanlineRasterizer.downscale(x2), ClippingScanlineRasterizer.downscale(y2));
		_status = STATUS_MOVE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public function edgeD(x1:Float, y1:Float, x2:Float, y2:Float):Void
	{
		if(_outline.isSorted) reset();
		_clipper.moveTo(ClippingScanlineRasterizer.upscale(x1), ClippingScanlineRasterizer.upscale(y1));
		_clipper.lineTo(_outline, ClippingScanlineRasterizer.upscale(x2), ClippingScanlineRasterizer.upscale(y2));		
		_status = STATUS_MOVE_TO;
	}
	//---------------------------------------------------------------------------------------------------
	public function sort():Void
	{
		if(_isAutoClose) closePolygon();
		_outline.sortCells();
	}
	//---------------------------------------------------------------------------------------------------
	public function rewindScanlines():Bool
	{
		var ret = false;
		if(_isAutoClose) closePolygon();
		_outline.sortCells();
		//if(_outline.cellsCount == 0)
		//{
			//return false;
		//}
		//_scanY = _outline.minY;
		//return true;
		if (ret = (_outline.cellsCount != 0)) 
		{
			_scanY = _outline.minY;
		}
		return ret;
	}
	//---------------------------------------------------------------------------------------------------
	public function navigateScanline(y:Int):Bool
	{
		if(_isAutoClose) closePolygon();
		_outline.sortCells();
		if(_outline.cellsCount == 0 ||
		y < _outline.minY || y > _outline.maxY)
		{
			return false;
		}
		_scanY = y;
		return true;
	}
	//---------------------------------------------------------------------------------------------------
	public function hitTest(tx:Int, ty:Int):Bool
	{
		if(!navigateScanline(ty)) return false;
		var sl:ScanlineHitTest = new ScanlineHitTest(tx);
		sweepScanline(sl);
		return sl.isHit;
	}
}