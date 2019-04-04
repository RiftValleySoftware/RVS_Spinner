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

/* ###################################################################################################################################### */
// MARK: - The Main View Controller Class
/* ###################################################################################################################################### */
/**
 This is actually an Abstract Base Class for the tab handlers.
 */
class RVS_Spinner_Tabbed_Test_Harness_Basic_ViewController: RVS_Spinner_Tabbed_Test_Harness_Spinner_ViewController {
    /* ################################################################################################################################## */
    /// This is a segmented switch, displayed along the bottom, that allows the user to choose an image set.
    var _imageSelector: UISegmentedControl!
    /// These are the values that correspond to the selector choices.
    var _imageSelectorChoices: [[RVS_SpinnerDataItem]] = []

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Set up a secmented switch and a switch at the bottom.
     
     The segmented switch selects the dataset to use, and the switch goes between two exclusive modes (.both is not supported by this app).
     */
    func _setUpImageSelectorSwitch() {
        // Yeah, all these functions are clunky, but this is a damn test harness. Not worth tweaking them to be super-optimal. Copy-Pasta FTW.
        /* ################################################################## */
        /**
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
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpImageSelectorSwitch()
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @objc func segmentedImageSelectorHit(_ inSegmentedSwitch: UISegmentedControl) {
        let images = _imageSelectorChoices[inSegmentedSwitch.selectedSegmentIndex]
        spinnerObject?.values = images
        spinnerObject?.selectedIndex = images.count / 2
    }
    
    /* ################################################################## */
    /**
     */
    @objc func modeSwitchHit(_ inSwitch: UISwitch) {
        spinnerObject?.spinnerMode = inSwitch.isOn ? 1 : -1
    }
}
