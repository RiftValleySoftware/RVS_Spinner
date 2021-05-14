/**
 © Copyright 2021, The Great Rift Valley Software Company
 
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

/* ###################################################################################################################################### */
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 Most of the magic here happens in the IB file. We simply set the rotation angles programmatically.
 */
class RVS_Spinner_Tabbed_Test_Harness_FourPart_ViewController: UIViewController, RVS_SpinnerDelegate {
    @IBOutlet var quadrantNWSpinner: RVS_Spinner!
    @IBOutlet var quadrantNESpinner: RVS_Spinner!
    @IBOutlet var quadrantSESpinner: RVS_Spinner!
    @IBOutlet var quadrantSWSpinner: RVS_Spinner!

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabController = tabBarController as? RVS_Spinner_Tabbed_Test_Harness_TabBarController {
            quadrantNWSpinner?.values = tabController.directories[3].items
            quadrantNWSpinner?.selectedIndex = (quadrantNWSpinner?.values.count ?? 0) / 2
            quadrantNWSpinner?.superview?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -4)
            quadrantNESpinner?.values = tabController.directories[2].items
            quadrantNESpinner?.selectedIndex = (quadrantNWSpinner?.values.count ?? 0) / 2
            quadrantNESpinner?.superview?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            quadrantSWSpinner?.values = tabController.directories[4].items
            quadrantSWSpinner?.selectedIndex = (quadrantNWSpinner?.values.count ?? 0) / 2
            quadrantSWSpinner?.superview?.transform = CGAffineTransform(rotationAngle: (3 * CGFloat.pi) / -4)
            quadrantSESpinner?.values = tabController.directories[5].items
            quadrantSESpinner?.selectedIndex = (quadrantNWSpinner?.values.count ?? 0) / 2
            quadrantSESpinner?.superview?.transform = CGAffineTransform(rotationAngle: (3 * CGFloat.pi) / 4)
        }
    }
}
