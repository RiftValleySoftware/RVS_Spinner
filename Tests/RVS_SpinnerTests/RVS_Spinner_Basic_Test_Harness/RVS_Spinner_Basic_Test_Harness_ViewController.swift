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
    
    /* ################################################################################################################################## */
    /// This will contain all of the shapes that we will use to establish our data items array. It contains the full list, and is populated by reading in a bunch of images in the bundle.
    private var _shapes = [ShapeValueTuple]()
    /// This is our actual data items array. This changes to reflect the number of items selected by the "Number of Values" switch.
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
    /// This is the "Haptics" switch
    @IBOutlet weak var hapticsSwitch: UISwitch!
    /// This is the "Sounds" switch
    @IBOutlet weak var soundsSwitch: UISwitch!
    /// This is the label under the spinner that displays the associated strings (in red text).
    @IBOutlet weak var associatedTextLabel: UILabel!
    /// This segmented control determines whether or not items are disabled.
    @IBOutlet weak var disabledItemsSegmentedControl: UISegmentedControl!
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is called when the disabled segmented control changes.
     */
   @IBAction func disabledSegmentedControlChanged(_ inSegmentedControl: UISegmentedControl) {
        setUpDataItemsArray()
        setUpSpinnerControl()
    }
    
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
        setUpDisabledSegmentedControl()
        disabledItemsSegmentedControl.selectedSegmentIndex = 0
        setUpDataItemsArray()
        updateAssociatedText()
    }

    /* ################################################################## */
    /**
     This is called when any of the color segmented switches change.
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

    /* ################################################################## */
    /**
     This is redundant, but it shows how we can listen for spinner control events.
     
     It is called when the spinner selects a new value.
     
     In the case of the spinner variant, this is called repeatedly while the spinner is spinning.
     
     In the case of the picker variant, it is called once, after the picker has settled.
     */
    @IBAction func valueChanged(_ inSpinnerObject: RVS_Spinner) {
        updateAssociatedText()
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This just makes sure that the associated text label shows the associated value for the current selected item.
     
     The ignored parameter is so this can be used as a timer callback.
     */
    @objc func updateAssociatedText(_: Any! = nil) {
        DispatchQueue.main.async {  // Since this could be called from a timer completion, we need to make sure that UI changes are done in the main thread.
            self.associatedTextLabel?.textColor = UIColor.white
            self.associatedTextLabel?.text = self.spinnerView?.value?.value as? String
        }
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This filters the main list, and returns a subset of the images. This is used by the "Number of Values" handler.
     */
    func subsetOfShapes(_ inNumberOfShapes: Int) -> [ShapeValueTuple] {
        let stepSize = Double(_shapes.count) / Double(inNumberOfShapes)
        var ret: [ShapeValueTuple] = []
        let stepper = stride(from: 0.0, to: Double(_shapes.count), by: stepSize)
        
        for step in stepper {
            ret.append(_shapes[Int(step)])
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     This runs through the images we have stored in the app bundle, and produces our list.
     
     It uses the file name as the text for each image.
     */
    func extractValueList() {
        _shapes = []
        
        if let resourcePath = Bundle.main.resourcePath {
            let imagePath =  "\(resourcePath)/SpinnerIcons"
            do {
                let imagePaths = try FileManager.default.contentsOfDirectory(atPath: imagePath).sorted()
                imagePaths.forEach { fileName in
                    if let imageData = FileManager.default.contents(atPath: "\(imagePath)/\(fileName)"), let image = UIImage(data: imageData) {
                    // The name is the filename, minus the file extension.
                        _shapes.append((name: String(fileName.prefix(fileName.count - 4)), image: image, index: _shapes.count))
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    /* ################################################################## */
    /**
     This sets up the segmented switch for disabling.
     */
    func setUpDisabledSegmentedControl() {
        // The two endpoints are always enabled.
        disabledItemsSegmentedControl.setEnabled(true, forSegmentAt: 0)
        disabledItemsSegmentedControl.setEnabled(true, forSegmentAt: 3)
        disabledItemsSegmentedControl.setEnabled(_dataItems.count > 6, forSegmentAt: 1)
        disabledItemsSegmentedControl.setEnabled(_dataItems.count > 3, forSegmentAt: 2)
    }
    
    /* ################################################################## */
    /**
     This sets up the spinner view to reflect the condition of the controls.
     */
    func setUpSpinnerControl() {
        spinnerView.values = _dataItems
        spinnerView.selectedIndex = _dataItems.count / 2
        spinnerView.backgroundColor = _colorList[innerColorSegmentedControl.selectedSegmentIndex]
        spinnerView.tintColor = _darkColorList[borderColorSegmentedControl.selectedSegmentIndex]
        spinnerView.openBackgroundColor = _colorList[radialColorSegmentedControl.selectedSegmentIndex]
        spinnerView.delegate = self
        setUpDisabledSegmentedControl()
    }

    /* ################################################################## */
    /**
     This sets up the "Number of Values" switch, selecting the center one.
     */
    func setUpCountSwitch() {
        let step = Double(_shapes.count) / Double(numberOfItemsSegmentedControl.numberOfSegments)
        numberOfItemsSegmentedControl.setTitle(String("1"), forSegmentAt: 0)
        for index in 1..<numberOfItemsSegmentedControl.numberOfSegments {
            let count = Int(Swift.max(2.0, Swift.min(Double(_shapes.count), ceil(Double(index + 1) * step))))
            numberOfItemsSegmentedControl.setTitle(String(count), forSegmentAt: index)
        }
        
        numberOfItemsSegmentedControl.selectedSegmentIndex = numberOfItemsSegmentedControl.numberOfSegments / 2
    }
    
    /* ################################################################## */
    /**
     This sets up the data items array to reflect the number of values selected by the "Number of Values" switch.
     */
    func setUpDataItemsArray(_ inNumberOfItems: Int = 0) {
        let numberOfItems = 0 == inNumberOfItems ? _dataItems.count : inNumberOfItems
        _dataItems = []
        for shape in subsetOfShapes(numberOfItems).enumerated() {
            var isEnabled = true
            switch disabledItemsSegmentedControl.selectedSegmentIndex {
                case 1:
                    isEnabled = !(0 == shape.offset % 3)
                    
                case 2:
                    isEnabled = !(0 == shape.offset % 2 || 0 == shape.offset % 3)

                case 3:
                    isEnabled = false

                default:
                    isEnabled = true
            }
        

            _dataItems.append(RVS_SpinnerDataItem(title: shape.element.name, icon: shape.element.image, value: String(format: "Associated Text #%02d (\(shape.element.name))", shape.element.index + 1), isEnabled: isEnabled))
        }
        setUpSpinnerControl()
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
        thresholdSegmentedControlHit(thresholdSegmentedControl)
        updateAssociatedText()
        setUpSpinnerControl()
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
        associatedTextLabel?.textColor = UIColor.black
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }
    
    /* ################################################################## */
    /**
     This is called when a selection is made from a multiple selection list.
     
     In the case of the spinner variant, this is called repeatedly while the spinner is spinning.
     
     In the case of the picker variant, it is called once, after the picker has settled.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        updateAssociatedText()
    }
    
    /* ################################################################## */
    /**
     This is called when the popup opens.
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        let spinnerPicker = inSpinnerObject.opensAsSpinner ? "spinner" : "picker"
        associatedTextLabel?.text = "The user opened the \(spinnerPicker)."
        associatedTextLabel?.textColor = UIColor.black
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }
    
    /* ################################################################## */
    /**
     This is called when the popup closes.
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        let spinnerPicker = inSpinnerObject.opensAsSpinner ? "spinner" : "picker"
        associatedTextLabel?.text = "The user closed the \(spinnerPicker)."
        associatedTextLabel?.textColor = UIColor.black
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }
    
    /* ################################################################## */
    /**
     This is called before the user closes the spinner. It allows the delegate to interrupt the close process.
     */
    func spinner(_ inSpinner: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool {
        return inSpinner.isEnabled
    }
}
