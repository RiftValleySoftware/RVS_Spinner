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

/* ###################################################################################################################################### */
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 Shares image-collection and presentation-mode selectors among the single-spinner tabs.

 Storyboard subclasses supply the control and container geometry. This is a reusable
 base controller by convention; Swift does not enforce it as abstract.
 */
class RVS_Spinner_Tabbed_Test_Harness_Basic_ViewController: RVS_Spinner_Tabbed_Test_Harness_Spinner_ViewController {

    /* ################################################################################################################################## */
    /**
     The programmatically created image-collection selector along the safe-area bottom edge.
     */
    var _imageSelector: UISegmentedControl!

    /* ################################################################## */
    /**
     Image collections in the same order as the selector segments.
     */
    var _imageSelectorChoices: [[RVS_SpinnerDataItem]] = []

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Creates the image selector, mode switch, and labels using safe-area constraints.

     Segments include each collection's item count. The middle collection is selected
     initially. The switch forces ring or picker mode; automatic mode is not offered.
     */
    func _setUpImageSelectorSwitch() {
        // Yeah, all these functions are clunky, but this is a damn test harness. Not worth tweaking them to be super-optimal. Copy-Pasta FTW.

        /* ################################################################## */
        /**
         Adds the collection selector across the bottom of the controller's safe area.

         - parameter inSubView: The selector to position.
         - parameter inToView: Its containing view.
         */
        func addSegmentedView(_ inSubView: UIView, to inToView: UIView) {
            inToView.addSubview(inSubView)

            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            inSubView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -8).isActive = true
            inSubView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8).isActive = true
            inSubView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -4).isActive = true
        }

        /* ################################################################## */
        /**
         Centers the mode switch immediately above the collection selector.

         - parameter inSubView: The switch to position.
         - parameter inToView: Its containing view.
         - parameter inPrevious: The collection selector below it.
         */
        func addSwitch(_ inSubView: UIView, to inToView: UIView, previous inPrevious: UIView) {
            inToView.addSubview(inSubView)

            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            inSubView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
            inSubView.bottomAnchor.constraint(equalTo: inPrevious.topAnchor, constant: -4).isActive = true
        }

        /* ################################################################## */
        /**
         Places the ring-mode label to the left of the mode switch.

         - parameter inSubView: The label to position.
         - parameter inToView: Its containing view.
         - parameter inPrevious: The mode switch beside it.
         */
        func addSpinnerLabel(_ inSubView: UIView, to inToView: UIView, previous inPrevious: UIView) {
            inToView.addSubview(inSubView)

            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalTo: inPrevious.heightAnchor).isActive = true
            inSubView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8).isActive = true
            inSubView.trailingAnchor.constraint(equalTo: inPrevious.leadingAnchor, constant: -2).isActive = true
            inSubView.centerYAnchor.constraint(equalTo: inPrevious.centerYAnchor).isActive = true
        }

        /* ################################################################## */
        /**
         Places the picker-mode label to the right of the mode switch.

         - parameter inSubView: The label to position.
         - parameter inToView: Its containing view.
         - parameter inPrevious: The mode switch beside it.
         */
        func addPickerLabel(_ inSubView: UIView, to inToView: UIView, previous inPrevious: UIView) {
            inToView.addSubview(inSubView)

            let guide = self.view.safeAreaLayoutGuide
            inSubView.translatesAutoresizingMaskIntoConstraints = false
            inSubView.heightAnchor.constraint(equalTo: inPrevious.heightAnchor).isActive = true
            inSubView.leadingAnchor.constraint(equalTo: inPrevious.trailingAnchor, constant: 4).isActive = true
            inSubView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            inSubView.centerYAnchor.constraint(equalTo: inPrevious.centerYAnchor).isActive = true
        }

        // We create the controls programmatically, and use AutoLayout for their positioning.
        if let tabController = tabBarController as? RVS_Spinner_Tabbed_Test_Harness_TabBarController {
            tabController.directories.forEach {
                _imageSelectorChoices.append($0.items)
            }

            let segmentNames = tabController.directories.compactMap { $0.name + " (" + String($0.items.count) + ")" }

            _imageSelector = UISegmentedControl(items: segmentNames)
            _imageSelector.tintColor = UIColor.white
            _imageSelector.backgroundColor = UIColor.clear
            _imageSelector.selectedSegmentIndex = segmentNames.count / 2
            _imageSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)], for: .normal)
            segmentedImageSelectorHit(_imageSelector)
            _imageSelector.addTarget(self, action: #selector(segmentedImageSelectorHit), for: .valueChanged)
            addSegmentedView(_imageSelector, to: self.view)

            let modeSwitch = UISwitch()
            modeSwitch.isOn = false
            modeSwitch.tintColor = UIColor.white
            modeSwitchHit(modeSwitch)
            modeSwitch.addTarget(self, action: #selector(modeSwitchHit), for: .touchUpInside)
            addSwitch(modeSwitch, to: self.view, previous: _imageSelector)

            let spinnerLabel = UILabel()
            spinnerLabel.text = "Spinner"
            spinnerLabel.textColor = UIColor.white
            spinnerLabel.textAlignment = .right
            addSpinnerLabel(spinnerLabel, to: self.view, previous: modeSwitch)

            let pickerLabel = UILabel()
            pickerLabel.text = "Picker"
            pickerLabel.textColor = UIColor.white
            pickerLabel.textAlignment = .left
            addPickerLabel(pickerLabel, to: self.view, previous: modeSwitch)
        }
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Installs the inherited spinner callbacks, then creates the collection and mode selectors.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpImageSelectorSwitch()
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Replaces the spinner's items with the selected collection and selects its middle index.

     - parameter inSegmentedSwitch: A valid segment in the image-collection selector.
     */
    @objc func segmentedImageSelectorHit(_ inSegmentedSwitch: UISegmentedControl) {
        let images = _imageSelectorChoices[inSegmentedSwitch.selectedSegmentIndex]
        spinnerObject?.values = images
        spinnerObject?.selectedIndex = images.count / 2
    }

    /* ################################################################## */
    /**
     Forces picker mode when the switch is on and ring mode when it is off.

     - parameter inSwitch: The presentation-mode switch.
     */
    @objc func modeSwitchHit(_ inSwitch: UISwitch) {
        spinnerObject?.spinnerMode = inSwitch.isOn ? 1 : -1
    }
}
