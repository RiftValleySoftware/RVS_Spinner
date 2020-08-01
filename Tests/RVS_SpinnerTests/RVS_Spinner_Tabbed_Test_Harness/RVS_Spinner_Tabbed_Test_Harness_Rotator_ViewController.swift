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

/* ###################################################################################################################################### */
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 This class presents a simple controller in the middle of an otherwise empty tab. However, this can be rotated, by using a slider.
 */
class RVS_Spinner_Tabbed_Test_Harness_Rotator_ViewController: RVS_Spinner_Tabbed_Test_Harness_Basic_ViewController {
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var rotationSlider: UISlider!
    @IBOutlet weak var spinnerContainer: UIView!

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
      When we change our image set, we reset the rotation.
     */
    @objc override func segmentedImageSelectorHit(_ inSegmentedSwitch: UISegmentedControl) {
        super.segmentedImageSelectorHit(inSegmentedSwitch)
        let valueRange = spinnerObject.count - 1
        let min = Float(-(valueRange / 2))
        let max = Float(valueRange) + min
        let median = Float(valueRange / 2) + min
        
        rotationSlider.minimumValue = min
        rotationSlider.maximumValue = max
        rotationSlider.value = median
        spinnerContainer?.transform = CGAffineTransform(rotationAngle: 0)   // Snap to attention.
    }
    
    /* ################################################################## */
    /**
     */
    @IBAction func compensationSwitchChanged(_ inSwitch: UISwitch) {
        spinnerObject.isCompensatingForContainerRotation = inSwitch.isOn
    }
    
    /* ################################################################## */
    /**
     We rotate the enclosing UIView; not just the control.
     */
    @IBAction func sliderChanged(_ inSlider: UISlider) {
        let nearestStep = round(inSlider.value)
        inSlider.value = nearestStep
        
        let radiansPerValue = (2 * Float.pi) / Float(spinnerObject.count)
        let rotationAngle = CGFloat(radiansPerValue * nearestStep)
        
        let transfrom = CGAffineTransform(rotationAngle: rotationAngle)
        spinnerContainer?.transform = transfrom
        spinnerObject.setNeedsDisplay()
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Can't have just one.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        _imageSelector.setEnabled(false, forSegmentAt: 0)
    }
}
