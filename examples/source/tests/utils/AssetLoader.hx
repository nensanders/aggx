/*
 * Copyright (c) 2011-2015, 2time.net | Sven Otto
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package tests.utils;

import filesystem.FileSystem;
import types.Data;

using types.DataStringTools;

class AssetLoader
{
    static public function getStringFromFile(filename: String): String
    {
        var data: Data = getDataFromFile(filename);
        return data.readString();
    }

    static public function getDataFromFile(filename: String): Data
    {
        var fileUrl = FileSystem.instance().getUrlToStaticData() + "/" + filename;
        return getDataFromFileUrl(fileUrl);
    }

    static public function getDataFromFileUrl(fileUrl: String): Data
    {
        var reader: filesystem.FileReader = FileSystem.instance().getFileReader(fileUrl);

        if (reader == null)
        {
            trace("Couldnt find file for fileUrl: " + fileUrl);
            return null;
        }

        var fileSize = FileSystem.instance().getFileSize(fileUrl);

        var data = new Data(fileSize);
        reader.readIntoData(data);

        return data;
    }
}
