/**
 © Copyright 2019, The Great Rift Valley Software Company
 
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
/// This is a simple tuple that we use to hold an iterated value.
typealias ShapeValueTuple = (name: String, image: UIImage)

/* ###################################################################################################################################### */
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 This is actually an Abstract Base Class for the tab handlers.
 */
class RVS_Spinner_Tabbed_Test_Harness_Spinner_ViewController: UIViewController, RVS_SpinnerDelegate {
    /* ################################################################################################################################## */
    /// This is the actual spinner instance for this tab.
    @IBOutlet weak var spinnerObject: RVS_Spinner!

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
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
     */
    @objc func valueChangedInSpinner(_ inSpinner: RVS_Spinner) {
        #if DEBUG
            print("spinner(:, valueChangedInSpinner:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
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
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, singleValueSelected:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasSelectedTheValue:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasOpenedWithTheValue:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasClosedWithTheValue:) called in default.")
        #endif
    }
}
