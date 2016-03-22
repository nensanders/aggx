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
import types.Data;
import haxe.ds.Vector;
import aggx.core.memory.Pointer;
import aggx.core.memory.MemoryReaderEx;
using aggx.core.memory.MemoryReaderEx;
//=======================================================================================================
class CmapFormat0 
{
	private var _format:UInt;				//USHORT
	private var _length:UInt;				//USHORT
	private var _language:UInt;				//USHORT
	private var _glyphIdArray:Vector<Int>;	//BYTE[256]
	//---------------------------------------------------------------------------------------------------
	public function new(data: Data, encRecord:EncodingRecord)
	{
		_format = 0;
		
		_length = data.dataGetUShort();
		data.offset += 2;
		_language = data.dataGetUShort();
		data.offset += 2;
		
		var s = String.fromCharCode(0x02df);//"\x007e\x0000\x00c4\x00a0\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1";
		var upper = getUpper129(encRecord.platformID, encRecord.encodingID, _language);
		
		_glyphIdArray = new Vector(256);
        for (i in 0...256) _glyphIdArray[i] = 0; // TODO JS
		
		var i:UInt = 0;
		while (i < 126)
		{
			_glyphIdArray[data.readUInt8()] = i;
			data.offset++;
			++i;
		}
		
		while (i < 256)
		{
			_glyphIdArray[data.readUInt8()] = upper.charCodeAt(i - 127);
			data.offset++;
			++i;
		}
		_glyphIdArray[0] = 0;
	}
	//---------------------------------------------------------------------------------------------------
	private function getUpper129(platform:UInt, encoding:UInt, language:UInt):String
	{
		if (platform != 1/*PLATFORM_MACINTOSH*/)
			return null;

		switch (encoding)
		{
		case 0: /* smRoman */
			if (language == /* langIcelandic+1 */ 16) return UPPER_ICELANDIC;
			else if (language == /* langTurkish+1 */ 18) return UPPER_TURKISH;
			else if (language == /* langCroatian+1 */ 19) return UPPER_CROATIAN;
			else if (language == /* langRomanian+1 */ 38) return UPPER_ROMANIAN;
			else if (language == /* language-neutral */ 0) return UPPER_ROMAN;
			else return null;

		case 4: /* smArabic */
			if (language == /* langFarsi+1 */ 32) return UPPER_FARSI;
			else return UPPER_ARABIC;

		case 5: /* smHebrew */
			return UPPER_HEBREW;

		case 6: /* smGreek */
			return UPPER_GREEK;

		case 7: /* smCyrillic */
			return UPPER_CYRILLIC;

		case 29: /* smSlavic == smEastEurRoman */
			return UPPER_EAST_EUROPEAN_ROMAN;
		}

		return null;
	}
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_ARABIC:String 
		= "\x007e\x0000\x00c4\x00a0\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x06ba\x00ab\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x2026\x00ee\x00ef\x00f1\x00f3\x00bb\x00f4\x00f6\x00f7"
		+ "\x00fa\x00f9\x00fb\x00fc\x0020\x0021\"\x0023\x0024\x066a"
		+ "\x0026\x0027\x0028\x0029\x002a\x002b\x060c\x002d\x002e\x002f"
		+ "\x0660\x0661\x0662\x0663\x0664\x0665\x0666\x0667\x0668\x0669"
		+ "\x003a\x061b\x003c\x003d\x003e\x061f\x274a\x0621\x0622\x0623"
		+ "\x0624\x0625\x0626\x0627\x0628\x0629\x062a\x062b\x062c\x062d"
		+ "\x062e\x062f\x0630\x0631\x0632\x0633\x0634\x0635\x0636\x0637"
		+ "\x0638\x0639\x063a\x005b\\\x005d\x005e\x005f\x0640\x0641"
		+ "\x0642\x0643\x0644\x0645\x0646\x0647\x0648\x0649\x064a\x064b"
		+ "\x064c\x064d\x064e\x064f\x0650\x0651\x0652\x067e\x0679\x0686"
		+ "\x06d5\x06a4\x06af\x0688\x0691\x007b\x007c\x007d\x0698\x06d2";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_EAST_EUROPEAN_ROMAN:String
		= "\x007e\x0000\x00c4\x0100\x0101\x00c9\x0104\x00d6\x00dc\x00e1"
		+ "\x0105\x010c\x00e4\x010d\x0106\x0107\x00e9\x0179\x017a\x010e"
		+ "\x00ed\x010f\x0112\x0113\x0116\x00f3\x0117\x00f4\x00f6\x00f5"
		+ "\x00fa\x011a\x011b\x00fc\x2020\x00b0\x0118\x00a3\x00a7\x2022"
		+ "\x00b6\x00df\x00ae\x00a9\x2122\x0119\x00a8\x2260\x0123\x012e"
		+ "\x012f\x012a\x2264\x2265\x012b\x0136\x2202\x2211\x0142\x013b"
		+ "\x013c\x013d\x013e\x0139\x013a\x0145\x0146\x0143\x00ac\x221a"
		+ "\x0144\x0147\x2206\x00ab\x00bb\x2026\x00a0\x0148\x0150\x00d5"
		+ "\x0151\x014c\x2013\x2014\x201c\x201d\x2018\x2019\x00f7\x25ca"
		+ "\x014d\x0154\x0155\x0158\x2039\x203a\x0159\x0156\x0157\x0160"
		+ "\x201a\x201e\x0161\x015a\x015b\x00c1\x0164\x0165\x00cd\x017d"
		+ "\x017e\x016a\x00d3\x00d4\x016b\x016e\x00da\x016f\x0170\x0171"
		+ "\x0172\x0173\x00dd\x00fd\x0137\x017b\x0141\x017c\x0122\x02c7";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_CROATIAN:String
		= "\x007e\x0000\x00c4\x00c5\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x00e3\x00e5\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x00ec\x00ee\x00ef\x00f1\x00f3\x00f2\x00f4\x00f6\x00f5"
		+ "\x00fa\x00f9\x00fb\x00fc\x2020\x00b0\x00a2\x00a3\x00a7\x2022"
		+ "\x00b6\x00df\x00ae\x0160\x2122\x00b4\x00a8\x2260\x017d\x00d8"
		+ "\x221e\x00b1\x2264\x2265\x2206\x00b5\x2202\x2211\x220f\x0161"
		+ "\x222b\x00aa\x00ba\x03a9\x017e\x00f8\x00bf\x00a1\x00ac\x221a"
		+ "\x0192\x2248\x0106\x00ab\x010c\x2026\x00a0\x00c0\x00c3\x00d5"
		+ "\x0152\x0153\x0110\x2014\x201c\x201d\x2018\x2019\x00f7\x25ca"
		+ "\xf8ff\x00a9\x2044\x20ac\x2039\x203a\x00c6\x00bb\x2013\x00b7"
		+ "\x201a\x201e\x2030\x00c2\x0107\x00c1\x010d\x00c8\x00cd\x00ce"
		+ "\x00cf\x00cc\x00d3\x00d4\x0111\x00d2\x00da\x00db\x00d9\x0131"
		+ "\x02c6\x02dc\x00af\x03c0\x00cb\x02da\x00b8\x00ca\x00e6\x02c7";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_CYRILLIC:String
		= "\x007e\x0000\x0410\x0411\x0412\x0413\x0414\x0415\x0416\x0417"
		+ "\x0418\x0419\x041a\x041b\x041c\x041d\x041e\x041f\x0420\x0421"
		+ "\x0422\x0423\x0424\x0425\x0426\x0427\x0428\x0429\x042a\x042b"
		+ "\x042c\x042d\x042e\x042f\x2020\x00b0\x0490\x00a3\x00a7\x2022"
		+ "\x00b6\x0406\x00ae\x00a9\x2122\x0402\x0452\x2260\x0403\x0453"
		+ "\x221e\x00b1\x2264\x2265\x0456\x00b5\x0491\x0408\x0404\x0454"
		+ "\x0407\x0457\x0409\x0459\x040a\x045a\x0458\x0405\x00ac\x221a"
		+ "\x0192\x2248\x2206\x00ab\x00bb\x2026\x00a0\x040b\x045b\x040c"
		+ "\x045c\x0455\x2013\x2014\x201c\x201d\x2018\x2019\x00f7\x201e"
		+ "\x040e\x045e\x040f\x045f\x2116\x0401\x0451\x044f\x0430\x0431"
		+ "\x0432\x0433\x0434\x0435\x0436\x0437\x0438\x0439\x043a\x043b"
		+ "\x043c\x043d\x043e\x043f\x0440\x0441\x0442\x0443\x0444\x0445"
		+ "\x0446\x0447\x0448\x0449\x044a\x044b\x044c\x044d\x044e\x20ac";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_FARSI:String
		= "\x007e\x0000\x00c4\x00a0\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x06ba\x00ab\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x2026\x00ee\x00ef\x00f1\x00f3\x00bb\x00f4\x00f6\x00f7"
		+ "\x00fa\x00f9\x00fb\x00fc\x0020\x0021\"\x0023\x0024\x066a"
		+ "\x0026\x0027\x0028\x0029\x002a\x002b\x060c\x002d\x002e\x002f"
		+ "\x06f0\x06f1\x06f2\x06f3\x06f4\x06f5\x06f6\x06f7\x06f8\x06f9"
		+ "\x003a\x061b\x003c\x003d\x003e\x061f\x274a\x0621\x0622\x0623"
		+ "\x0624\x0625\x0626\x0627\x0628\x0629\x062a\x062b\x062c\x062d"
		+ "\x062e\x062f\x0630\x0631\x0632\x0633\x0634\x0635\x0636\x0637"
		+ "\x0638\x0639\x063a\x005b\\\x005d\x005e\x005f\x0640\x0641"
		+ "\x0642\x0643\x0644\x0645\x0646\x0647\x0648\x0649\x064a\x064b"
		+ "\x064c\x064d\x064e\x064f\x0650\x0651\x0652\x067e\x0679\x0686"
		+ "\x06d5\x06a4\x06af\x0688\x0691\x007b\x007c\x007d\x0698\x06d2";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_GREEK:String
		= "\x007e\x0000\x00c4\x00b9\x00b2\x00c9\x00b3\x00d6\x00dc\x0385"
		+ "\x00e0\x00e2\x00e4\x0384\x00a8\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00a3\x2122\x00ee\x00ef\x2022\x00bd\x2030\x00f4\x00f6\x00a6"
		+ "\x20ac\x00f9\x00fb\x00fc\x2020\x0393\x0394\x0398\x039b\x039e"
		+ "\x03a0\x00df\x00ae\x00a9\x03a3\x03aa\x00a7\x2260\x00b0\x00b7"
		+ "\x0391\x00b1\x2264\x2265\x00a5\x0392\x0395\x0396\x0397\x0399"
		+ "\x039a\x039c\x03a6\x03ab\x03a8\x03a9\x03ac\x039d\x00ac\x039f"
		+ "\x03a1\x2248\x03a4\x00ab\x00bb\x2026\x00a0\x03a5\x03a7\x0386"
		+ "\x0388\x0153\x2013\x2015\x201c\x201d\x2018\x2019\x00f7\x0389"
		+ "\x038a\x038c\x038e\x03ad\x03ae\x03af\x03cc\x038f\x03cd\x03b1"
		+ "\x03b2\x03c8\x03b4\x03b5\x03c6\x03b3\x03b7\x03b9\x03be\x03ba"
		+ "\x03bb\x03bc\x03bd\x03bf\x03c0\x03ce\x03c1\x03c3\x03c4\x03b8"
		+ "\x03c9\x03c2\x03c7\x03c5\x03b6\x03ca\x03cb\x0390\x03b0\x00ad";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_HEBREW:String
		= "\x007e\x0000\x00c4\x0000\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x00e3\x00e5\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x00ec\x00ee\x00ef\x00f1\x00f3\x00f2\x00f4\x00f6\x00f5"
		+ "\x00fa\x00f9\x00fb\x00fc\x0020\x0021\"\x0023\x0024\x0025"
		+ "\x20aa\x0027\x0029\x0028\x002a\x002b\x002c\x002d\x002e\x002f"
		+ "\x0030\x0031\x0032\x0033\x0034\x0035\x0036\x0037\x0038\x0039"
		+ "\x003a\x003b\x003c\x003d\x003e\x003f\x0000\x201e\xf89b\xf89c"
		+ "\xf89d\xf89e\x05bc\xfb4b\xfb35\x2026\x00a0\x05b8\x05b7\x05b5"
		+ "\x05b6\x05b4\x2013\x2014\x201c\x201d\x2018\x2019\xfb2a\xfb2b"
		+ "\x05bf\x05b0\x05b2\x05b1\x05bb\x05b9\x0000\x05b3\x05d0\x05d1"
		+ "\x05d2\x05d3\x05d4\x05d5\x05d6\x05d7\x05d8\x05d9\x05da\x05db"
		+ "\x05dc\x05dd\x05de\x05df\x05e0\x05e1\x05e2\x05e3\x05e4\x05e5"
		+ "\x05e6\x05e7\x05e8\x05e9\x05ea\x007d\x005d\x007b\x005b\x007c";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_ICELANDIC:String
		= "\x007e\x0000\x00c4\x00c5\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x00e3\x00e5\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x00ec\x00ee\x00ef\x00f1\x00f3\x00f2\x00f4\x00f6\x00f5"
		+ "\x00fa\x00f9\x00fb\x00fc\x00dd\x00b0\x00a2\x00a3\x00a7\x2022"
		+ "\x00b6\x00df\x00ae\x00a9\x2122\x00b4\x00a8\x2260\x00c6\x00d8"
		+ "\x221e\x00b1\x2264\x2265\x00a5\x00b5\x2202\x2211\x220f\x03c0"
		+ "\x222b\x00aa\x00ba\x03a9\x00e6\x00f8\x00bf\x00a1\x00ac\x221a"
		+ "\x0192\x2248\x2206\x00ab\x00bb\x2026\x00a0\x00c0\x00c3\x00d5"
		+ "\x0152\x0153\x2013\x2014\x201c\x201d\x2018\x2019\x00f7\x25ca"
		+ "\x00ff\x0178\x2044\x20ac\x00d0\x00f0\x00de\x00fe\x00fd\x00b7"
		+ "\x201a\x201e\x2030\x00c2\x00ca\x00c1\x00cb\x00c8\x00cd\x00ce"
		+ "\x00cf\x00cc\x00d3\x00d4\xf8ff\x00d2\x00da\x00db\x00d9\x0131"
		+ "\x02c6\x02dc\x00af\x02d8\x02d9\x02da\x00b8\x02dd\x02db\x02c7";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_ROMAN:String
		= "\x007e\x0000\x00c4\x00c5\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x00e3\x00e5\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x00ec\x00ee\x00ef\x00f1\x00f3\x00f2\x00f4\x00f6\x00f5"
		+ "\x00fa\x00f9\x00fb\x00fc\x2020\x00b0\x00a2\x00a3\x00a7\x2022"
		+ "\x00b6\x00df\x00ae\x00a9\x2122\x00b4\x00a8\x2260\x00c6\x00d8"
		+ "\x221e\x00b1\x2264\x2265\x00a5\x00b5\x2202\x2211\x220f\x03c0"
		+ "\x222b\x00aa\x00ba\x03a9\x00e6\x00f8\x00bf\x00a1\x00ac\x221a"
		+ "\x0192\x2248\x2206\x00ab\x00bb\x2026\x00a0\x00c0\x00c3\x00d5"
		+ "\x0152\x0153\x2013\x2014\x201c\x201d\x2018\x2019\x00f7\x25ca"
		+ "\x00ff\x0178\x2044\x20ac\x2039\x203a\xfb01\xfb02\x2021\x00b7"
		+ "\x201a\x201e\x2030\x00c2\x00ca\x00c1\x00cb\x00c8\x00cd\x00ce"
		+ "\x00cf\x00cc\x00d3\x00d4\xf8ff\x00d2\x00da\x00db\x00d9\x0131"
		+ "\x02c6\x02dc\x00af\x02d8\x02d9\x02da\x00b8\x02dd\x02db\x02c7";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_ROMANIAN:String
		= "\x007e\x0000\x00c4\x00c5\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x00e3\x00e5\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x00ec\x00ee\x00ef\x00f1\x00f3\x00f2\x00f4\x00f6\x00f5"
		+ "\x00fa\x00f9\x00fb\x00fc\x2020\x00b0\x00a2\x00a3\x00a7\x2022"
		+ "\x00b6\x00df\x00ae\x00a9\x2122\x00b4\x00a8\x2260\x0102\x0218"
		+ "\x221e\x00b1\x2264\x2265\x00a5\x00b5\x2202\x2211\x220f\x03c0"
		+ "\x222b\x00aa\x00ba\x03a9\x0103\x0219\x00bf\x00a1\x00ac\x221a"
		+ "\x0192\x2248\x2206\x00ab\x00bb\x2026\x00a0\x00c0\x00c3\x00d5"
		+ "\x0152\x0153\x2013\x2014\x201c\x201d\x2018\x2019\x00f7\x25ca"
		+ "\x00ff\x0178\x2044\x20ac\x2039\x203a\x021a\x021b\x2021\x00b7"
		+ "\x201a\x201e\x2030\x00c2\x00ca\x00c1\x00cb\x00c8\x00cd\x00ce"
		+ "\x00cf\x00cc\x00d3\x00d4\xf8ff\x00d2\x00da\x00db\x00d9\x0131"
		+ "\x02c6\x02dc\x00af\x02d8\x02d9\x02da\x00b8\x02dd\x02db\x02c7";
	//---------------------------------------------------------------------------------------------------
	private static var UPPER_TURKISH:String
		= "\x007e\x0000\x00c4\x00c5\x00c7\x00c9\x00d1\x00d6\x00dc\x00e1"
		+ "\x00e0\x00e2\x00e4\x00e3\x00e5\x00e7\x00e9\x00e8\x00ea\x00eb"
		+ "\x00ed\x00ec\x00ee\x00ef\x00f1\x00f3\x00f2\x00f4\x00f6\x00f5"
		+ "\x00fa\x00f9\x00fb\x00fc\x2020\x00b0\x00a2\x00a3\x00a7\x2022"
		+ "\x00b6\x00df\x00ae\x00a9\x2122\x00b4\x00a8\x2260\x00c6\x00d8"
		+ "\x221e\x00b1\x2264\x2265\x00a5\x00b5\x2202\x2211\x220f\x03c0"
		+ "\x222b\x00aa\x00ba\x03a9\x00e6\x00f8\x00bf\x00a1\x00ac\x221a"
		+ "\x0192\x2248\x2206\x00ab\x00bb\x2026\x00a0\x00c0\x00c3\x00d5"
		+ "\x0152\x0153\x2013\x2014\x201c\x201d\x2018\x2019\x00f7\x25ca"
		+ "\x00ff\x0178\x011e\x011f\x0130\x0131\x015e\x015f\x2021\x00b7"
		+ "\x201a\x201e\x2030\x00c2\x00ca\x00c1\x00cb\x00c8\x00cd\x00ce"
		+ "\x00cf\x00cc\x00d3\x00d4\xf8ff\x00d2\x00da\x00db\x00d9\xf8a0"
		+ "\x02c6\x02dc\x00af\x02d8\x02d9\x02da\x00b8\x02dd\x02db\x02c7";
}