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

package aggx.vectorial.generators;
//=======================================================================================================
import aggx.core.memory.Ref;
//=======================================================================================================
interface IPolygonGenerator 
{
	public var autoClose(get, null):Bool;
	public var autoUnclose(get, null):Bool;
	public var approximationScale(get, set):Float;
	//---------------------------------------------------------------------------------------------------
	public function reset():Void;
	public function getVertex(x:FloatRef, y:FloatRef):UInt;	
	public function moveTo(x:Float, y:Float):Void;
	public function lineTo(x:Float, y:Float):Void;
}