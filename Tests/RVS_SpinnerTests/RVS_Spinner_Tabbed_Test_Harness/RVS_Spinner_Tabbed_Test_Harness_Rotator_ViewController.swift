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
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 Exercises container rotation and optional center-image counter-rotation.

 The inherited selectors choose an image collection and force ring or picker mode.
 The slider rotates the whole spinner container in one-item angular increments.
 */
class RVS_Spinner_Tabbed_Test_Harness_Rotator_ViewController: RVS_Spinner_Tabbed_Test_Harness_Basic_ViewController {

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Selects an integer rotation step across the current collection's range.
     */
    @IBOutlet weak var rotationSlider: UISlider!

    /* ################################################################## */
    /**
     The immediate container transformed by the rotation slider.
     */
    @IBOutlet weak var spinnerContainer: UIView!

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Loads the selected collection, recalculates slider limits, and resets container rotation to zero.

     - parameter inSegmentedSwitch: The inherited image-collection selector.
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
     Toggles whether the center icon counter-rotates against its container.

     - parameter inSwitch: The rotation-compensation switch.
     */
    @IBAction func compensationSwitchChanged(_ inSwitch: UISwitch) {
        spinnerObject.isCompensatingForContainerRotation = inSwitch.isOn
    }

    /* ################################################################## */
    /**
     Rounds the slider to an integer step and rotates the container by that fraction of a full turn.

     The control is redrawn so its center-image compensation reflects the new transform.

     - parameter inSlider: The rotation slider; its value is snapped to the nearest step.
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
     Sets up the inherited selectors and disables the one-item collection in this rotation exercise.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        _imageSelector.setEnabled(false, forSegmentAt: 0)
    }
}
