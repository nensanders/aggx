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

package aggx.rfpx.data;
//=======================================================================================================
class TableTags 
{
	public static inline var BASE = 0x42415345; // Baseline data [OpenType]
	public static inline var CFF  = 0x43464620; // PostScript font program (compact font format) [PostScript]
	public static inline var DSIG = 0x44534947; // Digital signature
	public static inline var EBDT = 0x45424454; // Embedded bitmap data
	public static inline var EBLC = 0x45424c43; // Embedded bitmap location data
	public static inline var EBSC = 0x45425343; // Embedded bitmap scaling data
	public static inline var GDEF = 0x47444546; // Glyph definition data [OpenType]
	public static inline var GPOS = 0x47504f53; // Glyph positioning data [OpenType]
	public static inline var GSUB = 0x47535542; // Glyph substitution data [OpenType]
	public static inline var JSTF = 0x4a535446; // Justification data [OpenType]
	public static inline var LTSH = 0x4c545348; // Linear threshold table
	public static inline var MMFX = 0x4d4d4658; // Multiple master font metrics [PostScript]
	public static inline var MMSD = 0x4d4d5344; // Multiple master supplementary data [PostScript]
	public static inline var OS_2 = 0x4f532f32; // OS/2 and Windows specific metrics [r]
	public static inline var PCLT = 0x50434c54; // PCL5
	public static inline var VDMX = 0x56444d58; // Vertical Device Metrics table
	public static inline var cmap = 0x636d6170; // character to glyph mapping [r]
	public static inline var cvt  = 0x63767420; // Control Value Table
	public static inline var fpgm = 0x6670676d; // font program
	public static inline var fvar = 0x66766172; // Apple's font variations table [PostScript]
	public static inline var gasp = 0x67617370; // grid-fitting and scan conversion procedure (grayscale)
	public static inline var glyf = 0x676c7966; // glyph data [r]
	public static inline var hdmx = 0x68646d78; // horizontal device metrics
	public static inline var head = 0x68656164; // font header [r]
	public static inline var hhea = 0x68686561; // horizontal header [r]
	public static inline var hmtx = 0x686d7478; // horizontal metrics [r]
	public static inline var kern = 0x6b65726e; // kerning
	public static inline var loca = 0x6c6f6361; // index to location [r]
	public static inline var maxp = 0x6d617870; // maximum profile [r]
	public static inline var name = 0x6e616d65; // naming table [r]
	public static inline var prep = 0x70726570; // CVT Program
	public static inline var post = 0x706f7374; // PostScript information [r]
	public static inline var vhea = 0x76686561; // Vertical Metrics header
	public static inline var vmtx = 0x766d7478; // Vertical Metrics

	private static var tableNames: Map<Int, String> = null;

	public static function getName(tag: Int): String
	{
		if (tableNames == null)
		{
			tableNames =
			[
				BASE => "BASE",
				CFF => "CFF",
				DSIG => "DSIG",
				EBDT => "EBDT",
				EBLC => "EBLC",
				EBSC => "EBSC",
				GDEF => "GDEF",
				GPOS => "GPOS",
				GSUB => "GSUB",
				JSTF => "JSTF",
				LTSH => "LTSH",
				MMFX => "MMFX",
				MMSD => "MMSD",
				PCLT => "PCLT",
				VDMX => "VDMX",
				cmap => "cmap",
				cvt => "cvt",
				fpgm => "fpgm",
				gasp => "gasp",
				glyf => "glyf",
				hdmx => "hdmx",
				head => "head",
				hhea => "hhea",
				hmtx => "hmtx",
				kern => "kern",
				loca => "loca",
				maxp => "maxp",
				name => "name",
				prep => "prep",
				post => "post",
				vhea => "vhea",
				vmtx => "vmtx"
			];
		}

		return tableNames.get(tag);
	}
}