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
 All the action happens here.
 */
class RVS_Spinner_Basic_Test_Harness_ViewController: UIViewController, RVS_SpinnerDelegate {
    /* ################################################################################################################################## */
    /// This is a simple tuple that we use to hold an iterated value.
    typealias ShapeValueTuple = (name: String, image: UIImage, index: Int)
    
    /* ################################################################################################################################## */
    /**
     This is a set of washed-out colors (for the most part), that are applied as backgrounds.
     */
    private let _colorList: [UIColor] = [
        UIColor.clear,
        UIColor.white,
        UIColor.black,
        UIColor.lightGray,
        UIColor(red: 1, green: 1, blue: 0.75, alpha: 1),
        UIColor(red: 1, green: 0.75, blue: 1, alpha: 1),
        UIColor(red: 0.75, green: 1, blue: 1, alpha: 1)
    ]
    
    /**
     This is a set of more saturated colors that are used for borders and text.
     */
    private let _darkColorList: [UIColor] = [
        UIColor.clear,
        UIColor.white,
        UIColor.black,
        UIColor.darkGray,
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),
        UIColor(red: 1, green: 0, blue: 1, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1)
    ]
    
    /**
     These are associated with data items as the "value" property.
     */
    private let _associatedText: [String] = [
        "Associated Text #01",
        "Associated Text #02",
        "Associated Text #03",
        "Associated Text #04",
        "Associated Text #05",
        "Associated Text #06",
        "Associated Text #07",
        "Associated Text #08",
        "Associated Text #09",
        "Associated Text #10",
        "Associated Text #11",
        "Associated Text #12",
        "Associated Text #13",
        "Associated Text #14",
        "Associated Text #15",
        "Associated Text #16",
        "Associated Text #17",
        "Associated Text #18",
        "Associated Text #19",
        "Associated Text #20"
    ]
    
    /* ################################################################################################################################## */
    /// This will contain all of the shapes that we will use to populate our data items array. It contains the full list, and is populated by reading in a bunch of images in the bundle.
    private var _shapes = [ShapeValueTuple]()
    /// This is aour actual data items array. This changes to reflect the number of items selected by the "Number of Values" switch.
    private var _dataItems = [RVS_SpinnerDataItem]()

    /* ################################################################################################################################## */
    /// These are hooks to our IB items. This is the RVS_Spinner instance.
    @IBOutlet weak var spinnerView: RVS_Spinner!
    /// This is the "Number of Values" switch at the bottom.
    @IBOutlet weak var numberOfItemsSegmentedControl: UISegmentedControl!
    /// This is the "Center Background Color" switch.
    @IBOutlet weak var innerColorSegmentedControl: UISegmentedControl!
    /// This is the "Open Control Background Color" switch.
    @IBOutlet weak var radialColorSegmentedControl: UISegmentedControl!
    /// This is the "Border and Text Color" switch
    @IBOutlet weak var borderColorSegmentedControl: UISegmentedControl!
    /// This is the Spinner Mode switch
    @IBOutlet weak var spinnerModeSegmentedControl: UISegmentedControl!
    /// This is the "Spinner/Picker Threshold" switch, at the top.
    @IBOutlet weak var thresholdSegmentedControl: UISegmentedControl!
    /// This is the "Rotation" slider
    @IBOutlet weak var rotationSlider: UISlider!
    /// This is the "Haptics" switch
    @IBOutlet weak var hapticsSwitch: UISwitch!
    /// This is the "Sounds" switch
    @IBOutlet weak var soundsSwitch: UISwitch!
    /// This is the label under the spinner that displays the associated strings (in red text).
    @IBOutlet weak var associatedTextLabel: UILabel!

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This returns every shape in the list (all 20).
     */
    var everyShape: [ShapeValueTuple] {
        return _shapes
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is called when the "Sounds" switch changes.
     */
    @IBAction func soundsSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView.isSoundOn = inSwitch.isOn
    }
    
    /* ################################################################## */
    /**
     This is called when the "Haptics" switch changes.
     */
    @IBAction func hapticsSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView.isHapticsOn = inSwitch.isOn
    }
    
    /* ################################################################## */
    /**
     This is called when the "Rotation" slider changes.
     */
    @IBAction func rotationSliderChanged(_ inSlider: UISlider) {
        var offset = Float.pi * inSlider.value
        
        if 0.05 > abs(offset) { // Give a teeny little detent at 0.
            offset = 0
            inSlider.value = offset
        }
        
        spinnerView.rotationInRadians = offset
    }
    
    /* ################################################################## */
    /**
     This is called when the "Spinner/Picker Threshold" segmented switch changes.
     */
    @IBAction func thresholdSegmentedControlHit(_ inSegmentedSwitch: UISegmentedControl) {
        if let value = Int(inSegmentedSwitch.titleForSegment(at: inSegmentedSwitch.selectedSegmentIndex) ?? "") {
            spinnerView?.spinnerThreshold = value
        }
    }

    /* ################################################################## */
    /**
     This is called when the Spinner Mode segmented switch changes.
     */
    @IBAction func spinnerModeSegSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        spinnerView.spinnerMode = inSegmentedSwitch.selectedSegmentIndex - 1
        thresholdSegmentedControl.isEnabled = 0 == spinnerView.spinnerMode
    }

    /* ################################################################## */
    /**
     This is called when the "Number of Values" segmented switch changes.
     */
    @IBAction func numberSegSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        if let numberOfItems = Int(inSegmentedSwitch.titleForSegment(at: inSegmentedSwitch.selectedSegmentIndex) ?? "") {
            setUpDataItemsArray(numberOfItems)
        }
        updateAssociatedText()
    }

    /* ################################################################## */
    /**
     This is called when the any of the color segmented switches change.
     */
    @IBAction func colorSegSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        if inSegmentedSwitch == innerColorSegmentedControl {
            spinnerView.backgroundColor = _colorList[inSegmentedSwitch.selectedSegmentIndex]
        } else if inSegmentedSwitch == radialColorSegmentedControl {
            spinnerView.openBackgroundColor = _colorList[inSegmentedSwitch.selectedSegmentIndex]
        } else {
            spinnerView.tintColor = _darkColorList[inSegmentedSwitch.selectedSegmentIndex]
        }
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This filters the main list, and returns a subset of the images. This is used by the "Number of Values" handler.
     */
    func subsetOfShapes(_ inNumberOfShapes: Int) -> [ShapeValueTuple] {
        let shapes = everyShape
        let stepSize = Double(shapes.count) / Double(inNumberOfShapes)
        var ret: [ShapeValueTuple] = []
        let stepper = stride(from: 0.0, to: Double(shapes.count), by: stepSize)
        
        for step in stepper {
            ret.append(shapes[Int(step)])
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     This just makes sure that the associated text label shows the associated value for the current selected item.
     
     The ignored parameter is so this can be used as a timer callback.
     */
    @objc func updateAssociatedText(_ : Any! = nil) {
        DispatchQueue.main.async {  // Since this could be called from a timer completion, we need to make sure that UI changes are done in the main thread.
            self.associatedTextLabel?.textColor = UIColor.red
            self.associatedTextLabel?.text = self.spinnerView?.value?.value as? String
        }
    }

    /* ################################################################## */
    /**
     This runs through the images we have stored in the app bundle, and produces our list.
     
     It uses the file name as the text for each image.
     */
    func extractValueList() {
        _shapes = []
        
        if let resourcePath = Bundle.main.resourcePath {
            let imagePath = resourcePath + "/SpinnerIcons"
            let fileManager = FileManager.default
            var index = 0
            
            do {
                let imagePaths = try fileManager.contentsOfDirectory(atPath: imagePath).sorted()
                imagePaths.forEach {
                    if let imageFile = fileManager.contents(atPath: imagePath + "/" + $0) {
                        if let image = UIImage(data: imageFile) {
                            var name = $0
                            name.removeLast(4)
                            _shapes.append((name: name, image: image, index: index))
                            index += 1
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    /* ################################################################## */
    /**
     This sets up the spinner view to reflect the condition of the controls.
     */
    func setUpControls() {
        spinnerView.values = _dataItems
        spinnerView.selectedIndex = _dataItems.count / 2
        spinnerView.backgroundColor = _colorList[innerColorSegmentedControl.selectedSegmentIndex]
        spinnerView.tintColor = _darkColorList[borderColorSegmentedControl.selectedSegmentIndex]
        spinnerView.openBackgroundColor = _colorList[radialColorSegmentedControl.selectedSegmentIndex]
        spinnerView.delegate = self
    }
    
    /* ################################################################## */
    /**
     This sets up the "Number of Values" switch, selecting the center one.
     */
    func setUpCountSwitch() {
        let step = Double(everyShape.count) / Double(numberOfItemsSegmentedControl.numberOfSegments)
        numberOfItemsSegmentedControl.setTitle(String("1"), forSegmentAt: 0)
        for index in 1..<numberOfItemsSegmentedControl.numberOfSegments {
            let count = Int(Swift.max(2.0, Swift.min(Double(everyShape.count), ceil(Double(index + 1) * step))))
            numberOfItemsSegmentedControl.setTitle(String(count), forSegmentAt: index)
        }
        
        numberOfItemsSegmentedControl.selectedSegmentIndex = numberOfItemsSegmentedControl.numberOfSegments / 2
    }
    
    /* ################################################################## */
    /**
     This sets up the data items array to reflect the number of values selected by the "Number of Values" switch.
     */
    func setUpDataItemsArray(_ inNumberOfItems: Int) {
        _dataItems = []
        let items = subsetOfShapes(inNumberOfItems)
        items.forEach {
            _dataItems.append(RVS_SpinnerDataItem(title: $0.name, icon: $0.image, value: _associatedText[$0.index]))
        }
        setUpControls()
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Do our initialization here.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        extractValueList()
        setUpCountSwitch()
        numberSegSwitchHit(numberOfItemsSegmentedControl)
        spinnerModeSegSwitchHit(spinnerModeSegmentedControl)
        rotationSliderChanged(rotationSlider)
        thresholdSegmentedControlHit(thresholdSegmentedControl)
        updateAssociatedText()
        setUpControls()
    }
    
    /* ################################################################################################################################## */
    /**
     These are the various delegate callbacks.
     
     They are all made in the main thread.
     
     For some of them, the text will briefly flash a message in green text, indicating the callback was made.
     */
    /* ################################################################## */
    /**
     This is called when the user taps a control with only one value.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
        associatedTextLabel?.text = "The user tapped the Button."
        associatedTextLabel?.textColor = UIColor.green
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }
    
    /* ################################################################## */
    /**
     This is called when a selection is made from a multiple selection list.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        updateAssociatedText()
    }
    
    /* ################################################################## */
    /**
     This is called when the popup opens.
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        let spinnerPicker = (0 == inSpinnerObject.spinnerMode && inSpinnerObject.count < inSpinnerObject.spinnerThreshold) || -1 == inSpinnerObject.spinnerMode ? "spinner" : "picker"
        associatedTextLabel?.text = "The user opened the \(spinnerPicker)."
        associatedTextLabel?.textColor = UIColor.green
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }
    
    /* ################################################################## */
    /**
     This is called when the popup closes.
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        let spinnerPicker = (0 == inSpinnerObject.spinnerMode && inSpinnerObject.count < inSpinnerObject.spinnerThreshold) || -1 == inSpinnerObject.spinnerMode ? "spinner" : "picker"
        associatedTextLabel?.text = "The user closed the \(spinnerPicker)."
        associatedTextLabel?.textColor = UIColor.green
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }
}
