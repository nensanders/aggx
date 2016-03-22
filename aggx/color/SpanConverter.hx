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

package aggx.color;
//=======================================================================================================
class SpanConverter implements ISpanGenerator
{
	private var _spanGen:ISpanGenerator;
	private var _spanCnv:ISpanGenerator;
	//---------------------------------------------------------------------------------------------------
	public function new(gen:ISpanGenerator, conv:ISpanGenerator)
	{
		_spanCnv = conv;
		_spanGen = gen;
	}
	//---------------------------------------------------------------------------------------------------
	public function attach_generator(spanGen:ISpanGenerator) { _spanGen = spanGen; }
	//---------------------------------------------------------------------------------------------------
	public function attach_converter(spanCnv:ISpanGenerator) { _spanCnv = spanCnv; }	
	//---------------------------------------------------------------------------------------------------
	public function prepare():Void
	{
		_spanGen.prepare();
		_spanCnv.prepare();
	}
	//---------------------------------------------------------------------------------------------------
	public function generate(span:RgbaColorStorage, x_:Int, y_:Int, len:Int):Void
	{
		_spanGen.generate(span, x_, y_, len);
		_spanCnv.generate(span, x_, y_, len);
	}	
}