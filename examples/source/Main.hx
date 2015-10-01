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

import duellkit.DuellKit;

import input.Touch;
import input.MouseButtonState;
import input.MouseButton;
import input.MouseButtonEventData;

import tests.OpenGLTest;

class Main
{
    inline static private var borderInputCoverage: Float = 1.0/3.0;

    static public var _main: Main;

    static private var currentTest: OpenGLTest;

    static private var testArray: Array<Dynamic>;
    static private var currentTestNumber: Int = 0;

    static function main() : Void
    {
        _main = new Main();
    }

    public function new()
    {
        DuellKit.initialize(startAfterDuellIsInitialized);
    }

    public function startAfterDuellIsInitialized() : Void
    {
        DuellKit.instance().clearAndPresentDefaultBuffer = false;

        configureInput();

        testArray = [tests.meshTest.MeshTest];

        currentTestNumber = testArray.length - 1;
        switchToTest(currentTestNumber);
    }

    private function configureInput(): Void
    {
        DuellKit.instance().onMouseButtonEvent.add(function (eventData: MouseButtonEventData)
        {
            if (eventData.button == MouseButton.MouseButtonLeft && eventData.newState == MouseButtonState.MouseButtonStateUp)
            {
                processInput(DuellKit.instance().mousePosition.x, DuellKit.instance().mousePosition.y);
            }
        });

        DuellKit.instance().onTouches.add(function (touches: Array<Touch>)
        {
            var firstTouch: Touch = touches[0];

            if (firstTouch.state == TouchState.TouchStateEnded)
            {
                processInput(firstTouch.x, firstTouch.y);
            }
        });
    }

    private function processInput(screenX: Float, screenY: Float): Void
    {
        var screenWidth: Float = DuellKit.instance().screenWidth;
        var inputRangeWidth: Float = screenWidth * borderInputCoverage;

        var rightLimit: Float = screenWidth - inputRangeWidth;
        var leftLimit: Float = inputRangeWidth;

        if (screenX > rightLimit)
        {
            nextTest();
        }
        else if (screenX < leftLimit)
        {
            previousTest();
        }
    }

    private function nextTest(): Void
    {
        currentTestNumber++;
        currentTestNumber = currentTestNumber % testArray.length;
        switchToTest(currentTestNumber);
    }

    private function previousTest(): Void
    {
        currentTestNumber--;
        if (currentTestNumber < 0) currentTestNumber = testArray.length - 1;
        switchToTest(currentTestNumber);
    }

    private function switchToTest(testNumber: Int): Void
    {
        if (currentTest != null)
        {
            currentTest.onDestroy();
        }

        var testClass = testArray[testNumber];
        currentTest = Type.createInstance(testClass, []);
        trace(Type.getClassName(Type.getClass(currentTest)));
    }
}