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
 Exercises item counts, presentation modes, colors, feedback, and delegate callbacks.

 The storyboard supplies the controls. Launch with `--verify-spinner` in a Debug build
 to run synchronous regression checks followed by asynchronous flywheel checks.
 */
class RVS_Spinner_Basic_Test_Harness_ViewController: UIViewController, RVS_SpinnerDelegate {

    /* ################################################################################################################################## */
    /**
     A bundled icon, its filename-derived title, and its index in the complete icon list.
     */
    typealias ShapeValueTuple = (name: String, image: UIImage, index: Int)

    /* ################################################################################################################################## */
    /**
     Background presets, indexed by the center and open-background segmented controls.
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

    /* ################################################################## */
    /**
     Tint presets, indexed by the border and text color segmented control.
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
    /**
     The complete, filename-sorted icon list loaded from the bundle.
     */
    private var _shapes = [ShapeValueTuple]()

    /* ################################################################## */
    /**
     The sampled items and dimming flags currently assigned to the spinner.
     */
    private var _dataItems = [RVS_SpinnerDataItem]()

    /* ################################################################################################################################## */
    /**
     The storyboard spinner under test.
     */
    @IBOutlet weak var spinnerView: RVS_Spinner!

    /* ################################################################## */
    /**
     Selects the number of bundled icons to sample.
     */
    @IBOutlet weak var numberOfItemsSegmentedControl: UISegmentedControl!

    /* ################################################################## */
    /**
     Selects the fill color of the center and icon frames.
     */
    @IBOutlet weak var innerColorSegmentedControl: UISegmentedControl!

    /* ################################################################## */
    /**
     Selects the open ring-sector or picker-row background color.
     */
    @IBOutlet weak var radialColorSegmentedControl: UISegmentedControl!

    /* ################################################################## */
    /**
     Selects the tint used for template icons, frames, and picker text.
     */
    @IBOutlet weak var borderColorSegmentedControl: UISegmentedControl!

    /* ################################################################## */
    /**
     Selects ring, automatic, or picker presentation, in that order.
     */
    @IBOutlet weak var spinnerModeSegmentedControl: UISegmentedControl!

    /* ################################################################## */
    /**
     Selects the exclusive ring threshold used in automatic mode.
     */
    @IBOutlet weak var thresholdSegmentedControl: UISegmentedControl!

    /* ################################################################## */
    /**
     Enables haptic feedback on supported physical devices.
     */
    @IBOutlet weak var hapticsSwitch: UISwitch!

    /* ################################################################## */
    /**
     Enables system sounds for spinner interaction.
     */
    @IBOutlet weak var soundsSwitch: UISwitch!

    /* ################################################################## */
    /**
     Displays the selected item's String payload in white, or a temporary callback message in black.
     */
    @IBOutlet weak var associatedTextLabel: UILabel!

    /* ################################################################## */
    /**
     Selects which items are dimmed. Dimmed items remain selectable.
     */
    @IBOutlet weak var disabledItemsSegmentedControl: UISegmentedControl!

    /* ################################################################## */
    /**
     Toggles template-only HUD rendering without icon frames or sector backgrounds.
     */
    @IBOutlet weak var hudModeSwitch: UISwitch!

    /* ################################################################################################################################## */
    /* ################################################################## */
   /**
    Rebuilds the current item sample with the selected dimming pattern and resets its selection.

    - parameter inSegmentedControl: The dimming selector; its state is read through the outlet.
    */
   @IBAction func disabledSegmentedControlChanged(_ inSegmentedControl: UISegmentedControl) {
        setUpDataItemsArray()
        setUpSpinnerControl()
    }

    /* ################################################################## */
    /**
     Applies HUD mode and enables background selectors only when those colors are used.

     - parameter inSwitch: The switch whose on state enables HUD rendering.
     */
    @IBAction func hudModeSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView?.hudMode = inSwitch.isOn
        innerColorSegmentedControl.isEnabled = !inSwitch.isOn
        radialColorSegmentedControl.isEnabled = !inSwitch.isOn
    }

    /* ################################################################## */
    /**
     Applies the selected sound-feedback setting.

     - parameter inSwitch: The switch whose on state enables sounds.
     */
    @IBAction func soundsSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView.isSoundOn = inSwitch.isOn
    }

    /* ################################################################## */
    /**
     Applies the selected haptic-feedback setting.

     - parameter inSwitch: The switch whose on state enables haptics.
     */
    @IBAction func hapticsSwitchChanged(_ inSwitch: UISwitch) {
        spinnerView.isHapticsOn = inSwitch.isOn
    }

    /* ################################################################## */
    /**
     Reads the selected numeric title and applies the automatic-mode threshold.

     - parameter inSegmentedSwitch: The threshold selector.
     */
    @IBAction func thresholdSegmentedControlHit(_ inSegmentedSwitch: UISegmentedControl) {
        if let value = Int(inSegmentedSwitch.titleForSegment(at: inSegmentedSwitch.selectedSegmentIndex) ?? "") {
            spinnerView?.spinnerThreshold = value
        }
    }

    /* ################################################################## */
    /**
     Maps segments to -1, 0, and 1, and enables the threshold selector only in automatic mode.

     - parameter inSegmentedSwitch: The presentation-mode selector.
     */
    @IBAction func spinnerModeSegSwitchHit(_ inSegmentedSwitch: UISegmentedControl) {
        spinnerView.spinnerMode = inSegmentedSwitch.selectedSegmentIndex - 1
        thresholdSegmentedControl.isEnabled = 0 == spinnerView.spinnerMode
    }

    /* ################################################################## */
    /**
     Rebuilds the sample for the selected count, clears item dimming, and refreshes the payload label.

     - parameter inSegmentedSwitch: The item-count selector, whose titles contain numeric counts.
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
     Applies the selected preset to the center background, open background, or tint.

     - parameter inSegmentedSwitch: One of the three color selectors.
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
     Refreshes the payload label on a `.valueChanged` target/action event.

     Events include assignments in code and replacement of the values array. Ring selection
     can change repeatedly while spinning; picker selection changes when scrolling settles.
     This deliberately demonstrates target/action alongside the selection delegate.

     - parameter inSpinnerObject: The spinner that emitted the event.
     */
    @IBAction func valueChanged(_ inSpinnerObject: RVS_Spinner) {
        updateAssociatedText()
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Queues a main-thread update that displays the current selected item's String payload in white.

     The optional ignored argument allows the same method to restore the label after the
     one-shot timers used by activation and popup callbacks.
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
     Samples the complete icon list at evenly spaced fractional indices.

     - parameter inNumberOfShapes: A positive requested count from the count selector.
     - returns: Icons in their original order. Fractional stepping can round the resulting count.
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
     Loads filename-sorted files from the bundled SpinnerIcons directory as template images.

     Each successfully decoded image gets a title with its four-character extension removed
     and an index used in its associated payload. File-system errors are printed.
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
     Enables the two partial-dimming choices only for sufficiently large samples.

     The no-dimming and all-dimmed choices remain available at every count.
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
     Assigns the current items, selects the middle index, applies color presets, and installs the delegate.

     Assigning values closes any popup and sends a value-changed event; changing the
     selected index can also notify the delegate already installed on the control.
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
     Builds count-selector titles from the available icon count and selects the middle segment.

     The first segment always requests one item so that button behavior can be exercised.
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
     Builds sampled items with String payloads and the selected dimming pattern, then configures the spinner.

     Pattern 1 dims every third sampled item; pattern 2 dims offsets divisible by two or
     three; pattern 3 dims all items. Dimming does not prevent selection.

     - parameter inNumberOfItems: The requested count; zero reuses the current sample count.
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
     Prevents the launch-argument verification from running again on subsequent appearances.
     */
    private var didVerifySpinner = false

    /* ################################################################## */
    /**
     Runs optional verification once after the host view enters a window and installs manual event logging.

     The assertions and flywheel probe are active only in Debug builds. Wait for both
     verification groups to finish before interacting with the controls.

     - parameter animated: Whether UIKit animated the appearance.
     */
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

    /* ################################################################## */
    /**
     Logs a center touch-up event and the popup state during optional verification.
     */
    @objc private func verificationTouch() { print("SPINNER CENTER touchUpInside, open=\(spinnerView.isOpen)") }

    /* ################################################################## */
    /**
     Logs a primary-action event and the popup state during optional verification.
     */
    @objc private func verificationPrimary() { print("SPINNER CENTER primaryAction, open=\(spinnerView.isOpen)") }

    /* ################################################################## */
    /**
     Logs pan state and velocity at gesture boundaries during optional verification.

     - parameter gesture: A pan recognizer on the popup.
     */
    @objc private func verificationPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state != .changed { print("SPINNER PAN state=\(gesture.state.rawValue), velocity=\(gesture.velocity(in: gesture.view))") }
    }

    /* ################################################################## */
    /**
     Loads icon data, configures the count and mode selectors, and applies the initial spinner settings.
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

     Activation and popup callbacks briefly display a message in black, then restore the payload in white.
     */

    /* ################################################################## */
    /**
     Displays a temporary button-activation message for a one-item control.

     A one-shot timer restores the selected payload after half a second. The item can be dimmed.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
        associatedTextLabel?.text = "The user tapped the Button."
        associatedTextLabel?.textColor = UIColor.black
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }

    /* ################################################################## */
    /**
     Refreshes the payload label after a synchronous selection-delegate notification.

     This callback also occurs for a changed selected index assigned in code. Replacing
     values can clamp selection without delivering this particular callback.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        updateAssociatedText()
    }

    /* ################################################################## */
    /**
     Displays a temporary popup-opening message and optionally attaches pan logging.

     The callback observes `isOpen == true` before the opening animation finishes.
     The label returns to the payload after half a second.
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
     Displays a temporary popup-closing message, including closes caused by configuration changes.

     The callback observes `isOpen == false` before any closing animation finishes.
     The label returns to the payload after half a second.
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        let spinnerPicker = inSpinnerObject.opensAsSpinner ? "spinner" : "picker"
        associatedTextLabel?.text = "The user closed the \(spinnerPicker)."
        associatedTextLabel?.textColor = UIColor.black
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateAssociatedText), userInfo: nil, repeats: false)
    }

    /* ################################################################## */
    /**
     Allows an explicit close while the whole control is enabled.

     This checks the control, rather than the item's dimming flag, so a dimmed item is
     accepted. Forced cleanup for configuration changes or detachment bypasses this callback.

     - returns: The spinner's `isEnabled` state.
     */
    func spinner(_ inSpinner: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool {
        return inSpinner.isEnabled
    }
}

#if DEBUG
/**
 Runs optional synchronous Debug assertions against temporary controls in the existing app.

 Checks selection, callbacks, reentrancy, close vetoes, popup cleanup, picker rows,
 accessibility, rendering, and object release. It does not create a test target or enable coverage.
 */
@MainActor private final class SpinnerHarnessVerification: NSObject, RVS_SpinnerDelegate {

    /* ################################################################## */
    /**
     Number of value-changed target/action events observed by the synchronous probe.
     */
    private var events = 0

    /* ################################################################## */
    /**
     Number of touch-up activation events observed by the synchronous probe.
     */
    private var activations = 0

    /* ################################################################## */
    /**
     Number of primary-action events observed by the synchronous probe.
     */
    private var primaryActions = 0

    /* ################################################################## */
    /**
     Selected indices observed by the selection delegate, in callback order.
     */
    private var selected: [Int] = []

    /* ################################################################## */
    /**
     Number of opening callbacks observed by the synchronous probe.
     */
    private var opened = 0

    /* ################################################################## */
    /**
     Number of closing callbacks observed by the synchronous probe.
     */
    private var closed = 0

    /* ################################################################## */
    /**
     Number of one-item activations observed by the synchronous probe.
     */
    private var singles = 0

    /* ################################################################## */
    /**
     Whether the probe rejects explicit close requests.
     */
    private var veto = false

    /* ################################################################## */
    /**
     Optional reentrant work executed from a selection callback.
     */
    private var onSelect: ((RVS_Spinner) -> Void)?

    /* ################################################################## */
    /**
     Optional reentrant work executed from an opening callback.
     */
    private var onOpen: ((RVS_Spinner) -> Void)?

    /* ################################################################## */
    /**
     Optional reentrant work executed while the control consults its close delegate.
     */
    private var onCloseDecision: ((RVS_Spinner) -> Void)?

    /* ################################################################## */
    /**
     Counts a value-changed event.
     */
    @objc private func changed() { events += 1 }

    /* ################################################################## */
    /**
     Counts a touch-up activation event.
     */
    @objc private func activated() { activations += 1 }

    /* ################################################################## */
    /**
     Counts a primary-action event.
     */
    @objc private func primary() { primaryActions += 1 }

    /* ################################################################## */
    /**
     Records the new index and performs any configured reentrant selection work.
     */
    func spinner(_ spinner: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        selected.append(spinner.selectedIndex)
        onSelect?(spinner)
    }

    /* ################################################################## */
    /**
     Asserts logical opening, counts the callback, and performs any configured reentrant work.
     */
    func spinner(_ spinner: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        assert(spinner.isOpen, "Open callback must observe open state")
        opened += 1
        onOpen?(spinner)
    }

    /* ################################################################## */
    /**
     Asserts logical closure and counts the callback.
     */
    func spinner(_ spinner: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        assert(!spinner.isOpen, "Closed callback must observe closed state")
        closed += 1
    }

    /* ################################################################## */
    /**
     Performs any configured reentrant work before applying the probe's explicit-close veto.

      - returns: True unless the probe is configured to veto closing.
     */
    func spinner(_ spinner: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool {
        onCloseDecision?(spinner)
        return !veto
    }

    /* ################################################################## */
    /**
     Counts one-item activation.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) { singles += 1 }

    /* ################################################################## */
    /**
     Runs the synchronous checks using temporary controls and removes their host on return.

      - parameter host: A view already attached to a window.
      - precondition: Invoke from the main actor in a Debug build.
     */
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
        let normalCenter = UIGraphicsImageRenderer(bounds: spinner.bounds).image { spinner.layer.render(in: $0.cgContext) }.pngData()
        let eventsBeforeHighlight = probe.events
        spinner.isHighlighted = true
        spinner.layer.displayIfNeeded()
        let highlightedCenter = UIGraphicsImageRenderer(bounds: spinner.bounds).image { spinner.layer.render(in: $0.cgContext) }.pngData()
        assert(normalCenter != nil && highlightedCenter != nil && normalCenter != highlightedCenter,
               "Programmatic UIControl highlighting must update the center's rendered appearance")
        spinner.isHighlighted = false
        spinner.layer.displayIfNeeded()
        let restoredCenter = UIGraphicsImageRenderer(bounds: spinner.bounds).image { spinner.layer.render(in: $0.cgContext) }.pngData()
        assert(restoredCenter == normalCenter && spinner.selectedIndex == 0 && probe.events == eventsBeforeHighlight,
               "Clearing highlight must restore the center without changing selection or emitting events")
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
/* ###################################################################################################################################### */
/**
 Keeps the optional verification call available in Release builds without running Debug assertions.
 */
private enum SpinnerHarnessVerification {

    /* ################################################################## */
    /**
     The Release-build shim for the optional synchronous verification entry point.

      - parameter host: Unused; no assertions or temporary controls are created.
     */
    static func run(in host: UIView) {}
}
#endif

#if DEBUG
/**
 Supplies deterministic gesture samples to the production pan action in Debug builds.

 The probe allows flywheel checks without relying on an automated drag's velocity.
 It uses a private selector and must be updated if the production action is renamed.
 */
@MainActor private final class SpinnerHarnessPan: UIPanGestureRecognizer {

    /* ################################################################## */
    /**
     Gesture state returned to the production action.
     */
    var sampleState: UIGestureRecognizer.State = .began

    /* ################################################################## */
    /**
     Sampled touch location in the popup's coordinates.
     */
    var samplePoint = CGPoint.zero

    /* ################################################################## */
    /**
     Sampled translation used to reconstruct the gesture's starting angle.
     */
    var sampleTranslation = CGPoint.zero

    /* ################################################################## */
    /**
     Sampled velocity in points per second used to start the flywheel.
     */
    var sampleVelocity = CGPoint.zero

    /* ################################################################## */
    /**
     Reads and writes the deterministic state sample.
     */
    override var state: UIGestureRecognizer.State {
        get { sampleState }
        set { sampleState = newValue }
    }

    /* ################################################################## */
    /**
     Returns the deterministic location sample. The requested coordinate space is ignored.
     */
    override func location(in view: UIView?) -> CGPoint { samplePoint }

    /* ################################################################## */
    /**
     Returns the deterministic translation sample. The requested coordinate space is ignored.
     */
    override func translation(in view: UIView?) -> CGPoint { sampleTranslation }

    /* ################################################################## */
    /**
     Returns the deterministic velocity sample. The requested coordinate space is ignored.
     */
    override func velocity(in view: UIView?) -> CGPoint { sampleVelocity }
}

/* ###################################################################################################################################### */
/**
 Runs asynchronous Debug checks for ring drag direction, flywheel stopping, and release during a spin.
 */
@MainActor private enum SpinnerFlywheelVerification {

    /* ################################################################## */
    /**
     Runs deterministic pan and flywheel checks while allowing real display-link updates between samples.

      The private selector assertion fails if the production pan action is renamed.
      Reduce Motion must be off for the inertial-motion assertions.

      - parameter host: A view already attached to a window.
     */
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
