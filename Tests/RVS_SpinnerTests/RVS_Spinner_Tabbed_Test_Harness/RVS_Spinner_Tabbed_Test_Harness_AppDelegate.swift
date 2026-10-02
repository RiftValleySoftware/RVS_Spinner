/**
 © Copyright 2021-2026, The Great Rift Valley Software Company

 LICENSE:

 MIT License

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import UIKit

/* ###################################################################################################################################### */
// MARK: - The Main App Delegate Class
/* ###################################################################################################################################### */
/**
 The application entry point for the Tabbed geometry harness.

 UIKit creates the storyboard interface through the window scene configured in the app's Info.plist.
 */
@main
class RVS_Spinner_Tabbed_Test_Harness_AppDelegate: UIResponder, UIApplicationDelegate {

    /* ################################################################################################################################## */
}

/* ###################################################################################################################################### */
/**
 Owns the storyboard window for one harness scene.

 Each harness defines this class in its own module; these are separate app types.
 */
class HarnessSceneDelegate: UIResponder, UIWindowSceneDelegate {

    /* ################################################################## */
    /**
     The window supplied by UIKit when it connects the storyboard scene.
     */
    var window: UIWindow?
}
