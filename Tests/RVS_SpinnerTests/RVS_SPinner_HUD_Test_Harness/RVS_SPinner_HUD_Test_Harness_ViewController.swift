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
// MARK: - UIImage Extension -
/* ###################################################################################################################################### */
/**
 This adds some simple image manipulation.
 */
extension UIImage {
    /* ################################################################## */
    /**
     This allows an image to be resized, given both a width and a height, or just one of the dimensions.
     
     - parameters:
         - toNewWidth: The width (in pixels) of the desired image. If not provided, a scale will be determined from the toNewHeight parameter.
         - toNewHeight: The height (in pixels) of the desired image. If not provided, a scale will be determined from the toNewWidth parameter.
     
     - returns: A new image, with the given dimensions. May be nil, if no width or height was supplied, or if there was an error.
     */
    func resized(toNewWidth inNewWidth: CGFloat? = nil, toNewHeight inNewHeight: CGFloat? = nil) -> UIImage? {
        guard nil == inNewWidth,
              nil == inNewHeight else {
            var scaleX: CGFloat = (inNewWidth ?? size.width) / size.width
            var scaleY: CGFloat = (inNewHeight ?? size.height) / size.height

            scaleX = nil == inNewWidth ? scaleY : scaleX
            scaleY = nil == inNewHeight ? scaleX : scaleY

            let destinationSize = CGSize(width: size.width * scaleX, height: size.height * scaleY)
            let destinationRect = CGRect(origin: .zero, size: destinationSize)

            UIGraphicsBeginImageContextWithOptions(destinationSize, false, 0)
            defer { UIGraphicsEndImageContext() }   // This makes sure that we get rid of the offscreen context.
            draw(in: destinationRect, blendMode: .normal, alpha: 1)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Main View Controller Class -
/* ###################################################################################################################################### */
/**
  
 */
class RVS_SPinner_HUD_Test_Harness_ViewController: UIViewController {
    /* ################################################################## */
    /**
     */
    static let imageNames: [String] = ["face.smiling",
                                       "face.smiling.fill",
                                       "face.dashed",
                                       "face.dashed.fill",
                                       "person.circle",
                                       "person.circle.fill",
                                       "person.crop.circle",
                                       "person.crop.circle.fill",
                                       "person",
                                       "person.fill",
                                       "person.2",
                                       "person.2.fill"
                                       
    ]
    
    /* ################################################################## */
    /**
     */
    static let templateImage = UIImage(named: "Globe")
    
    /* ################################################################## */
    /**
     */
    static let normalImage = UIImage(named: "BlueMarble")

    /* ################################################################## */
    /**
     */
    var spinnerItems: [RVS_SpinnerDataItem] = []
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var spinnerControl: RVS_Spinner!
}

/* ###################################################################################################################################### */
// MARK: - Callbacks -
/* ###################################################################################################################################### */
extension RVS_SPinner_HUD_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     */
    @IBAction func segmentedSwitchChanged(_ sender: UISegmentedControl) {
    }

    /* ################################################################## */
    /**
     */
    @IBAction func spinnerControlChangedValue(_ sender: RVS_Spinner) {
    }
}

/* ###################################################################################################################################### */
// MARK: - Base Class Overrides -
/* ###################################################################################################################################### */
extension RVS_SPinner_HUD_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerItems = []
        Self.imageNames.forEach {
            if let icon = UIImage(systemName: $0)?.withRenderingMode(.alwaysTemplate).withTintColor(view?.tintColor ?? .white).resized(toNewWidth: 320) {
                spinnerItems.append(RVS_SpinnerDataItem(title: $0, icon: icon))
            }
        }
        
        spinnerControl?.values = spinnerItems
    }
}
