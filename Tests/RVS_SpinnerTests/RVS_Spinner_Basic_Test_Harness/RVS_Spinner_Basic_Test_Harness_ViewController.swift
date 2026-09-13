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
    /// The switch that toggles HUD mode.
    @IBOutlet weak var hudModeSwitch: UISwitch!
    
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
     This is called when the HUD Mode switch changes.
     */
    @IBAction func hudModeSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView?.hudMode = inSwitch.isOn
        innerColorSegmentedControl.isEnabled = !inSwitch.isOn
        radialColorSegmentedControl.isEnabled = !inSwitch.isOn
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
                    if let imageData = FileManager.default.contents(atPath: "\(imagePath)/\(fileName)"), let image = UIImage(data: imageData)?.withRenderingMode(.alwaysTemplate) {
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
    private var didVerifySpinner = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didVerifySpinner, ProcessInfo.processInfo.arguments.contains("--verify-spinner") else { return }
        didVerifySpinner = true
        SpinnerHarnessVerification.run(in: view)
        #if DEBUG
        Task { await SpinnerFlywheelVerification.run(in: view) }
        #endif
        spinnerView.addTarget(self, action: #selector(verificationTouch), for: .touchUpInside)
        spinnerView.addTarget(self, action: #selector(verificationPrimary), for: .primaryActionTriggered)
    }

    @objc private func verificationTouch() { print("SPINNER CENTER touchUpInside, open=\(spinnerView.isOpen)") }
    @objc private func verificationPrimary() { print("SPINNER CENTER primaryAction, open=\(spinnerView.isOpen)") }
    @objc private func verificationPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state != .changed { print("SPINNER PAN state=\(gesture.state.rawValue), velocity=\(gesture.velocity(in: gesture.view))") }
    }

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
        if ProcessInfo.processInfo.arguments.contains("--verify-spinner") {
            for sibling in inSpinnerObject.superview?.subviews ?? [] {
                for recognizer in sibling.gestureRecognizers ?? [] where recognizer is UIPanGestureRecognizer {
                    recognizer.addTarget(self, action: #selector(verificationPan(_:)))
                }
            }
        }
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

#if DEBUG
/// Optional, repeatable regression checks inside the existing app; no test target or coverage instrumentation.
@MainActor private final class SpinnerHarnessVerification: NSObject, RVS_SpinnerDelegate {
    private var events = 0
    private var activations = 0
    private var primaryActions = 0
    private var selected: [Int] = []
    private var opened = 0
    private var closed = 0
    private var singles = 0
    private var veto = false
    private var onSelect: ((RVS_Spinner) -> Void)?
    private var onOpen: ((RVS_Spinner) -> Void)?
    private var onCloseDecision: ((RVS_Spinner) -> Void)?
    @objc private func changed() { events += 1 }
    @objc private func activated() { activations += 1 }
    @objc private func primary() { primaryActions += 1 }
    func spinner(_ spinner: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        selected.append(spinner.selectedIndex)
        onSelect?(spinner)
    }
    func spinner(_ spinner: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        assert(spinner.isOpen, "Open callback must observe open state")
        opened += 1
        onOpen?(spinner)
    }
    func spinner(_ spinner: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        assert(!spinner.isOpen, "Closed callback must observe closed state")
        closed += 1
    }
    func spinner(_ spinner: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool {
        onCloseDecision?(spinner)
        return !veto
    }
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) { singles += 1 }

    static func run(in host: UIView) {
        let probe = SpinnerHarnessVerification()
        let image = UIGraphicsImageRenderer(size: CGSize(width: 12, height: 6)).image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 12, height: 6))
        }.withRenderingMode(.alwaysOriginal)
        let items = [RVS_SpinnerDataItem(title: "Red", icon: image),
                     RVS_SpinnerDataItem(title: "Dimmed", icon: image, description: "Unavailable example", isEnabled: false),
                     RVS_SpinnerDataItem(title: "Empty icon", icon: UIImage())]
        let container = UIView(frame: host.bounds)
        host.addSubview(container)
        defer { container.removeFromSuperview() }
        let spinner = RVS_Spinner(values: items, selectedIndex: 0,
                                  frame: CGRect(x: container.bounds.midX - 25, y: container.bounds.midY - 25, width: 50, height: 50), delegate: probe)
        spinner.isSoundOn = false
        spinner.isHapticsOn = false
        container.addSubview(spinner)
        spinner.addTarget(probe, action: #selector(changed), for: .valueChanged)
        spinner.addTarget(probe, action: #selector(activated), for: .touchUpInside)
        spinner.addTarget(probe, action: #selector(primary), for: .primaryActionTriggered)
        assert(probe.events == 0 && probe.selected.isEmpty)
        spinner.selectedIndex = Int.max
        assert(spinner.selectedIndex == 2 && probe.events == 1 && probe.selected == [2])
        spinner.selectedIndex = Int.max
        assert(probe.events == 1)
        spinner.selectedIndex = Int.min
        assert(spinner.selectedIndex == 0 && probe.events == 2)
        probe.onSelect = { value in if value.selectedIndex == 1 { value.selectedIndex = 2 } }
        spinner.selectedIndex = 1
        assert(spinner.selectedIndex == 2 && probe.events == 3, "Nested selection must not emit a stale outer event")
        probe.onSelect = nil
        spinner.isOpen = true
        probe.veto = true
        spinner.isOpen = false
        assert(spinner.isOpen)
        let beforeReplacement = probe.events
        spinner.values = [items[0]]
        assert(!spinner.isOpen && spinner.selectedIndex == 0 && probe.events == beforeReplacement + 1)
        assert(container.subviews.count == 1, "Replacement must remove an open popup even with a veto")
        assert(spinner.accessibilityActivate() && probe.singles == 1 && probe.activations == 1 && probe.primaryActions == 1)
        spinner.values = []
        spinner.selectedIndex = Int.max
        spinner.isOpen = true
        assert(spinner.value == nil && spinner.selectedIndex == 0 && !spinner.isOpen && !spinner.accessibilityActivate())
        spinner.values = items
        probe.veto = false
        probe.onOpen = { $0.isOpen = false }
        spinner.isOpen = true
        assert(!spinner.isOpen, "Opening delegate may close synchronously")
        probe.onOpen = nil
        spinner.isOpen = true
        probe.onCloseDecision = { value in value.isOpen = false; value.selectedIndex = 1 }
        spinner.isOpen = false
        assert(spinner.isOpen && spinner.selectedIndex == 1, "A changed selection invalidates a pending close decision")
        probe.onCloseDecision = nil
        spinner.isOpen = false
        spinner.isOpen = true
        assert(spinner.isOpen && container.subviews.count == 2)
        spinner.spinnerMode = RVS_Spinner.SpinnerMode.pickerOnly.rawValue
        assert(!spinner.isOpen && container.subviews.count == 1)
        spinner.isOpen = true
        spinner.selectedIndex = 2
        let picker = container.subviews.flatMap(\.subviews).compactMap { $0 as? UIPickerView }.first!
        assert(picker.selectedRow(inComponent: 0) == 2)
        let row0 = spinner.pickerView(picker, viewForRow: 0, forComponent: 0, reusing: nil)
        let row1 = spinner.pickerView(picker, viewForRow: 1, forComponent: 0, reusing: row0)
        assert(row1.accessibilityLabel == "Dimmed" && row0 !== row1)
        _ = spinner.pickerView(picker, viewForRow: Int.max, forComponent: 0, reusing: row0)
        spinner.pickerView(picker, didSelectRow: Int.min, inComponent: 0)
        assert(spinner.selectedIndex == 2)
        spinner.pickerView(picker, didSelectRow: 1, inComponent: 0)
        assert(spinner.value?.isEnabled == false && spinner.accessibilityValue == "Dimmed")
        spinner.tintColor = UIColor.red.withAlphaComponent(0)
        spinner.backgroundColor = UIColor.blue.withAlphaComponent(0)
        assert(!spinner.framedIcons, "Transparent RGB colors must not create frames")
        spinner.isEnabled = false
        assert(!spinner.isOpen && !spinner.accessibilityActivate())
        spinner.accessibilityIncrement()
        assert(spinner.selectedIndex == 1)
        spinner.isEnabled = true
        spinner.accessibilityIncrement()
        assert(spinner.selectedIndex == 2)
        spinner.accessibilityIncrement()
        assert(spinner.selectedIndex == 0)
        spinner.accessibilityDecrement()
        assert(spinner.selectedIndex == 2)
        spinner.spinnerMode = Int.max
        spinner.spinnerThreshold = Int.min
        assert(spinner.spinnerMode == 0 && spinner.spinnerThreshold == 2 && !spinner.opensAsSpinner)
        spinner.spinnerMode = -1
        spinner.selectedIndex = 0
        spinner.tintColor = .blue
        spinner.backgroundColor = .clear
        spinner.hudMode = false
        spinner.layoutIfNeeded()
        spinner.setNeedsDisplay(CGRect(x: 1, y: 1, width: 2, height: 2))
        spinner.layer.displayIfNeeded()
        _ = UIGraphicsImageRenderer(bounds: spinner.bounds).image { spinner.layer.render(in: $0.cgContext) }
        spinner.selectedIndex = 2
        spinner.layer.displayIfNeeded() // Empty UIImage must not produce invalid layer geometry.
        spinner.isOpen = true
        spinner.isHidden = true
        assert(!spinner.isOpen && container.subviews.count == 1)
        spinner.isHidden = false
        spinner.isOpen = true
        spinner.removeFromSuperview()
        assert(!spinner.isOpen && container.subviews.isEmpty)
        weak var released: RVS_Spinner?
        autoreleasepool {
            let transient = RVS_Spinner(values: items, frame: CGRect(x: 50, y: 100, width: 50, height: 50))
            transient.isSoundOn = false
            transient.isHapticsOn = false
            released = transient
            container.addSubview(transient)
            transient.isOpen = true
            transient.isOpen = false
            transient.isOpen = true
            transient.removeFromSuperview()
        }
        assert(released == nil && container.subviews.isEmpty, "Popup lifetime must not retain the control")
        print("SPINNER VERIFICATION PASSED: selection, callbacks, veto/reentrancy, popup cleanup, picker rows, accessibility, and rendering")
    }
}
#else
private enum SpinnerHarnessVerification {
    static func run(in host: UIView) {}
}
#endif

#if DEBUG
/// Supplies deterministic samples to the production pan action. Device Hub's automated
/// drag currently delivers zero velocity, so it cannot exercise the flywheel reliably.
@MainActor private final class SpinnerHarnessPan: UIPanGestureRecognizer {
    var sampleState: UIGestureRecognizer.State = .began
    var samplePoint = CGPoint.zero
    var sampleTranslation = CGPoint.zero
    var sampleVelocity = CGPoint.zero
    override var state: UIGestureRecognizer.State {
        get { sampleState }
        set { sampleState = newValue }
    }
    override func location(in view: UIView?) -> CGPoint { samplePoint }
    override func translation(in view: UIView?) -> CGPoint { sampleTranslation }
    override func velocity(in view: UIView?) -> CGPoint { sampleVelocity }
}

@MainActor private enum SpinnerFlywheelVerification {
    static func run(in host: UIView) async {
        let area = UIView(frame: host.bounds)
        host.addSubview(area)
        defer { area.removeFromSuperview() }
        let image = UIImage(systemName: "circle")!
        let items = (0..<10).map { RVS_SpinnerDataItem(title: String($0), icon: image) }
        var spinner: RVS_Spinner? = RVS_Spinner(values: items, frame: CGRect(x: area.bounds.midX - 25, y: area.bounds.midY - 25, width: 50, height: 50))
        spinner?.isSoundOn = false
        spinner?.isHapticsOn = false
        area.addSubview(spinner!)
        spinner?.isOpen = true
        let action = NSSelectorFromString("_handleOpenPanGesture:")
        assert(spinner!.responds(to: action), "Update this gesture probe if the production selector changes")
        let pan = SpinnerHarnessPan()
        let radius = min(area.bounds.width, area.bounds.height) / 2
        pan.samplePoint = CGPoint(x: radius * 1.5, y: radius)
        _ = spinner?.perform(action, with: pan)
        pan.sampleState = .changed
        pan.samplePoint = CGPoint(x: radius, y: radius * 1.5)
        _ = spinner?.perform(action, with: pan)
        assert(spinner?.selectedIndex == 2, "A quarter-turn must advance two of ten items")
        // A low but qualifying velocity produces no whole-item movement before stopping.
        pan.sampleState = .ended
        pan.sampleVelocity = CGPoint(x: -486, y: 0)
        _ = spinner?.perform(action, with: pan)
        try? await Task.sleep(nanoseconds: 350_000_000)
        _ = spinner?.accessibilityActivate()
        assert(spinner?.isOpen == false, "Slow flywheel must stop even without crossing an item boundary")
        spinner?.isOpen = true
        pan.sampleState = .began
        _ = spinner?.perform(action, with: pan)
        pan.sampleState = .ended
        pan.sampleVelocity = CGPoint(x: -30_000, y: 0)
        _ = spinner?.perform(action, with: pan)
        let before = spinner?.selectedIndex
        try? await Task.sleep(nanoseconds: 100_000_000)
        assert(spinner?.selectedIndex != before, "Fast flywheel must advance selection")
        spinner?.values = []
        assert(spinner?.isOpen == false && spinner?.value == nil)
        spinner?.values = items
        spinner?.isOpen = true
        pan.sampleState = .began
        _ = spinner?.perform(action, with: pan)
        pan.sampleState = .ended
        _ = spinner?.perform(action, with: pan)
        weak var released = spinner
        spinner?.removeFromSuperview()
        spinner = nil
        // Allow UIKit's current display transaction and autorelease pool to drain.
        try? await Task.sleep(nanoseconds: 100_000_000)
        assert(released == nil, "Removing a spinning control must release it")
        released = nil
        print("SPINNER FLYWHEEL VERIFICATION PASSED: drag direction, slow stop, fast spin, empty replacement, and release during spin")
    }
}
#endif
