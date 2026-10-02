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
import RVS_Spinner

/* ################################################################################################################################## */
/**
 A name and image pair available to the tabbed harness. The current collection loader uses data items directly.
 */
typealias ShapeValueTuple = (name: String, image: UIImage)

/* ###################################################################################################################################### */
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 Shares spinner delegation and target/action logging among the single-spinner tabs.

 Subclasses may override the hooks. Debug builds print callback names; Release builds
 leave these hooks silent. The library's default close decision allows closing.
 */
class RVS_Spinner_Tabbed_Test_Harness_Spinner_ViewController: UIViewController, RVS_SpinnerDelegate {

    /* ################################################################################################################################## */
    /**
     The spinner supplied by the subclass's storyboard scene.
     */
    @IBOutlet weak var spinnerObject: RVS_Spinner!

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Installs this controller as delegate and observes value-changed and center touch-up events.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up our delegate and observer calls.
        spinnerObject?.delegate = self
        spinnerObject?.addTarget(self, action: #selector(touchUpInSpinner), for: .touchUpInside)
        spinnerObject?.addTarget(self, action: #selector(valueChangedInSpinner), for: .valueChanged)
    }

    /* ################################################################################################################################## */
    /**
     These methods can be overridden to do your own thing.

     These are the standard observer calls from the control.
     */

    /* ################################################################## */
    /**
     Logs a value-changed target/action event in Debug builds. Subclasses may override it.

     - parameter inSpinner: The control whose selection or values changed.
     */
    @objc func valueChangedInSpinner(_ inSpinner: RVS_Spinner) {
        #if DEBUG
            print("spinner(:, valueChangedInSpinner:) called in default.")
        #endif
    }

    /* ################################################################## */
    /**
     Logs a center touch-up event in Debug builds. Subclasses may override it.

     - parameter inSpinner: The activated control; this event can accompany opening, closing, or button behavior.
     */
    @objc func touchUpInSpinner(_ inSpinner: RVS_Spinner) {
        #if DEBUG
            print("spinner(:, touchUpInSpinner:) called in default.")
        #endif
    }

    /* ################################################################################################################################## */
    /**
     These methods can be overridden to do your own thing.

     These are the RVS_SpinnerDelegate methods.
     */

    /* ################################################################## */
    /**
     Logs one-item center activation in Debug builds. A dimmed sole item can still activate.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, singleValueSelected:) called in default.")
        #endif
    }

    /* ################################################################## */
    /**
     Logs a synchronous selection-delegate notification in Debug builds.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasSelectedTheValue:) called in default.")
        #endif
    }

    /* ################################################################## */
    /**
     Logs an opening callback in Debug builds, after logical opening and before animation completes.
     */
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasOpenedWithTheValue:) called in default.")
        #endif
    }

    /* ################################################################## */
    /**
     Logs a closing callback in Debug builds, including forced cleanup and configuration changes.
     */
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasClosedWithTheValue:) called in default.")
        #endif
    }
}
