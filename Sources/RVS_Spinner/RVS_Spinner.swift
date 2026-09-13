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
 
 - version: 2.7.1
 */

import AudioToolbox
import UIKit

/* ###################################################################################################################################### */
/// An icon, optional display text, and application-defined value in a spinner.
///
/// Items remain in array order. An item whose `isEnabled` is false is dimmed, but
/// remains selectable so the application can explain why it is unavailable.
public struct RVS_SpinnerDataItem {
    /// The picker-row title and default accessibility value. Defaults to an empty string.
    public let title: String
    /// The icon. Template images use the spinner's tint; original images retain their colors.
    public let icon: UIImage
    /// Optional descriptive text, also used as the default accessibility hint.
    public let description: String?
    /// An optional application-defined payload. Cast it to your expected type before use.
    public let value: Any?
    /// Whether the item is drawn at full opacity. False dims it without preventing selection.
    public let isEnabled: Bool

    /// Creates an item. Only the icon is required.
    /// - Parameters:
    ///   - inTitle: Picker and accessibility text. Defaults to an empty string.
    ///   - inIcon: The image to display. Empty images are safely omitted.
    ///   - inDescription: Optional detail text; the control does not draw it.
    ///   - inValue: Optional application data, retained with the item.
    ///   - inIsEnabled: Whether to draw the item at full opacity. Defaults to true.
    public init(title inTitle: String = "", icon inIcon: UIImage, description inDescription: String? = nil, value inValue: Any? = nil, isEnabled inIsEnabled: Bool = true) {
        title = inTitle
        icon = inIcon
        description = inDescription
        value = inValue
        isEnabled = inIsEnabled
    }
}

/// Observes selection and presentation changes on the main actor.
///
/// All requirements have silent default implementations. The default close decision
/// is true. Retain your delegate elsewhere; the spinner's reference is weak.
@MainActor public protocol RVS_SpinnerDelegate: AnyObject {
    /// Called when the center is activated with exactly one item, without opening a popup.
    /// - Parameters:
    ///   - spinner: The control being activated.
    ///   - singleValueSelected: The sole item, including a dimmed item.
    func spinner(_ spinner: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?)
    /// Called synchronously when the clamped selected index changes, including assignments in code.
    /// - Parameters:
    ///   - spinner: The control whose selection changed.
    ///   - hasSelectedTheValue: The new selected item.
    func spinner(_ spinner: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?)
    /// Called after `isOpen` becomes true and the popup is installed, before animation completes.
    /// - Parameters:
    ///   - spinner: The opened control. It may be closed from this callback.
    ///   - hasOpenedWithTheValue: The item selected on opening.
    func spinner(_ spinner: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?)
    /// Called after `isOpen` becomes false, before any closing animation completes.
    /// - Parameters:
    ///   - spinner: The closed control. Configuration changes can also close it.
    ///   - hasClosedWithTheValue: The selected item at notification time; nil if the array is empty.
    func spinner(_ spinner: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?)
    /// Decides whether an explicit close request may proceed.
    ///
    /// Replacing values, changing presentation mode, disabling, hiding, or detaching
    /// the control closes it without asking this question. Such cleanup cannot be vetoed.
    /// Recursive close requests during this callback are ignored. Changing the
    /// selection or configuration cancels the pending close decision.
    /// - Parameters:
    ///   - spinner: The still-open control.
    ///   - willCloseWithTheValue: The item for which closing was requested.
    /// - Returns: True to close; false to leave the popup open.
    func spinner(_ spinner: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool
}

public extension RVS_SpinnerDelegate {
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {}
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {}
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {}
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {}
    func spinner(_: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool { true }
}

/// An icon control that expands into a radial spinner or a standard picker.
///
/// Set ``values`` and place the control inside a container with room for its popup.
/// The popup is a sibling inserted immediately below the control. Its size is derived
/// from the container's bounds. Keep the center comfortably away from the edges.
///
/// Tap the center to open or close, tap a side to step, or drag the ring to spin.
/// VoiceOver users can activate the center or adjust the selected value directly.
/// Empty controls do not open; one-item controls act as buttons. Dimmed data items
/// remain selectable; use the delegate to validate them when closing or acting.
///
/// Selection assignments send `.valueChanged`, as does replacing ``values``.
/// Physical center taps use UIKit's `.touchUpInside`; semantic activation also sends
/// `.primaryActionTriggered`. All access and callbacks belong on the main actor.
@IBDesignable
open class RVS_Spinner: UIControl, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - State and presentation

    private static let _kOpenPaddingInDisplayUnits: CGFloat = 8
    private var _radiusOfOpenControlInDisplayUnits: Double = 0
    private var _arclengthInRadians: CGFloat { isEmpty ? 0 : 2 * .pi / CGFloat(count) }
    private var _selectedIndex = 0
    private var _isOpen = false
    private var _isConsultingCloseDelegate = false
    private var _isDetaching = false
    private var _revision: UInt = 0
    private var _closedBackgroundColor: UIColor?
    private var _centerImageView: UIView?
    private var _openSpinnerView: UIView?
    private var _openPickerContainerView: UIView?
    private var _openPickerView: UIPickerView?
    private var _closingViews: [UIView] = []
    private var _animatedIconLayer: CALayer?
    private var _impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var _selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    private var _decelerationDisplayLink: CADisplayLink?
    private var _currentFlywheelVelocity: CGFloat = 0
    private var _decelerationAccumulator: CGFloat = 0
    private var _previousPanAngle: CGFloat = 0
    private var _panAccumulator: CGFloat = 0
    private var _doneTracking = true
    private var _animateCenter = false

    /// A display link retains its target. This proxy deliberately does not retain the control.
    private final class DisplayLinkTarget: NSObject {
        weak var owner: RVS_Spinner?
        init(owner: RVS_Spinner) { self.owner = owner }
        @objc func tick(_ link: CADisplayLink) {
            guard let owner = owner else { link.invalidate(); return }
            owner._decelerationStep(link)
        }
    }

    private var _openSpinnerFrame: CGRect {
        let radius = CGFloat(_radiusOfOpenControlInDisplayUnits)
        return CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
    }
    private var _openPickerFrame: CGRect {
        guard let container = superview else { return .zero }
        let available = container.bounds
        return CGRect(x: available.minX, y: available.minY, width: max(0, available.width),
                      height: max(0, center.y - bounds.height / 2 - available.minY))
    }
    private var _canActivate: Bool { isEnabled && isUserInteractionEnabled && !isHidden && !isEmpty && !_isDetaching }
    private var _effectiveTint: UIColor { (tintColor ?? .label).resolvedColor(with: traitCollection) }

    // MARK: - Configuration

    /// Receives synchronous selection and presentation callbacks. This reference is weak.
    public weak var delegate: RVS_SpinnerDelegate?

    /// The picker-row font. Defaults to bold system 20; nil uses the same fallback.
    public var displayFont: UIFont? = .boldSystemFont(ofSize: 20) {
        didSet { _refreshAppearance() }
    }

    /// The zero-based selected index, clamped to the available range.
    ///
    /// With no items this is zero and ``value`` is nil. Assigning a different clamped
    /// index synchronously calls the selection delegate, then sends `.valueChanged`.
    /// If the delegate changes the selection or values again, the superseded outer
    /// change does not send a second, stale event. Assigning the same index is silent.
    public var selectedIndex: Int {
        get { _selectedIndex }
        set {
            let index = max(0, min(count - 1, newValue))
            guard index != _selectedIndex else { return }
            _selectedIndex = index
            _revision &+= 1
            let revision = _revision
            _openPickerView?.selectRow(index, inComponent: 0, animated: false)
            setNeedsDisplay()
            _selectionFeedback()
            delegate?.spinner(self, hasSelectedTheValue: value)
            if revision == _revision { sendActions(for: .valueChanged) }
        }
    }

    /// The ordered items displayed by the control. Defaults to an empty array.
    ///
    /// Replacing this array stops spinning and closes the popup without a veto,
    /// clamps the selection, and sends one `.valueChanged`. It does not call the
    /// selection delegate just because clamping changed the index. An open control
    /// also sends its closed callback. A reentrant replacement supersedes this change.
    public var values: [RVS_SpinnerDataItem] = [] {
        didSet {
            _revision &+= 1
            let revision = _revision &+ (_isOpen ? 1 : 0)
            _selectedIndex = max(0, min(count - 1, _selectedIndex))
            _forceClose(animated: false)
            _refreshAppearance()
            if revision == _revision { sendActions(for: .valueChanged) }
        }
    }

    /// Whether a popup is logically open. Defaults to false.
    ///
    /// Opening requires at least two items, an enabled, visible, interactive control,
    /// and a superview. Explicit closing asks the delegate for permission. Logical
    /// state is committed before open/closed callbacks; animations finish afterward.
    public var isOpen: Bool {
        get { _isOpen }
        set {
            guard newValue != _isOpen else { return }
            if newValue {
                guard _canActivate, count > 1, superview != nil else { return }
                _isOpen = true
                _openControl()
                delegate?.spinner(self, hasOpenedWithTheValue: value)
            } else {
                guard !_isConsultingCloseDelegate else { return }
                let revision = _revision
                _isConsultingCloseDelegate = true
                let mayClose = delegate?.spinner(self, willCloseWithTheValue: value) ?? true
                _isConsultingCloseDelegate = false
                guard mayClose, _isOpen, revision == _revision else { return }
                _forceClose(animated: true)
            }
        }
    }

    /// Whether the center icon counter-rotates against its immediate container. Defaults to true.
    public var isCompensatingForContainerRotation = true { didSet { setNeedsDisplay() } }
    /// The selected item, or nil when ``values`` is empty.
    public var value: RVS_SpinnerDataItem? { values.indices.contains(selectedIndex) ? values[selectedIndex] : nil }
    /// Whether non-HUD icons have a circular frame, based on background and tint alpha.
    public var framedIcons: Bool { !hudMode && ((_closedBackgroundColor?.resolvedColor(with: traitCollection).cgColor.alpha ?? 0) > 0 || _effectiveTint.cgColor.alpha > 0) }
    /// Whether the next popup uses the ring. In automatic mode, equality with the threshold uses the picker.
    public var opensAsSpinner: Bool { spinnerMode == -1 || (spinnerMode == 0 && count < spinnerThreshold) }
    /// The number of items in ``values``.
    public var count: Int { values.count }
    /// Whether the control has no items to display or activate.
    public var isEmpty: Bool { values.isEmpty }

    /// Presentation choices for ``spinnerMode`` and the convenience initializer.
    public enum SpinnerMode: Int {
        /// Always use the radial spinner, regardless of item count.
        case spinnerOnly = -1
        /// Use the radial spinner when the count is less than ``RVS_Spinner/spinnerThreshold``.
        case both = 0
        /// Always use a standard picker above the center.
        case pickerOnly = 1
    }

    /// The fill color for the circular icon frames. The rectangular view stays transparent.
    public override var backgroundColor: UIColor? {
        get { _closedBackgroundColor ?? super.backgroundColor }
        set {
            _closedBackgroundColor = newValue
            super.backgroundColor = .clear
            _refreshAppearance()
        }
    }
    /// The template-icon and frame color. Picker text falls back to `.label` for a transparent tint.
    public override var tintColor: UIColor? { didSet { _refreshAppearance() } }
    /// The expanded ring-sector or picker-row background. Nil means clear. Ignored in HUD mode.
    @IBInspectable public var openBackgroundColor: UIColor? { didSet { _refreshAppearance() } }
    /// The presentation mode: -1 for ring, 0 for automatic, 1 for picker. Invalid values become 0.
    /// Changing this closes an open popup without asking the delegate for permission.
    @IBInspectable public var spinnerMode: Int = SpinnerMode.both.rawValue {
        didSet {
            if SpinnerMode(rawValue: spinnerMode) == nil { spinnerMode = 0 }
            if spinnerMode != oldValue { _configurationChanged() }
        }
    }
    /// Automatic mode's exclusive ring threshold. Defaults to 15; values below 2 become 2.
    /// Changing this closes an open popup without asking the delegate for permission.
    @IBInspectable public var spinnerThreshold: Int = 15 {
        didSet {
            spinnerThreshold = max(2, spinnerThreshold)
            if spinnerThreshold != oldValue { _configurationChanged() }
        }
    }
    /// Enables system feedback sounds for opening, closing, and selection while open. Defaults to true.
    @IBInspectable public var isSoundOn: Bool = true
    /// Enables impact and selection haptics on supported hardware. Defaults to true.
    @IBInspectable public var isHapticsOn: Bool = true
    /// An optional center image used in place of the selected icon while closed.
    /// Also used while open unless ``replaceCenterImage`` is true.
    @IBInspectable public var centerImage: UIImage? { didSet { setNeedsDisplay() } }
    /// Removes icon frames and sector backgrounds and renders icons as templates. Defaults to false.
    @IBInspectable public var hudMode: Bool = false { didSet { _refreshAppearance() } }
    /// Shows the selected item's icon while open, restoring ``centerImage`` on closing. Defaults to false.
    @IBInspectable public var replaceCenterImage: Bool = false { didSet { setNeedsDisplay() } }

    /// Disabling the control stops interaction and closes any popup without a veto.
    public override var isEnabled: Bool {
        didSet { if !isEnabled { _forceClose(animated: false) }; _refreshAppearance() }
    }
    /// Hiding the control removes its sibling popup and stops any flywheel animation.
    public override var isHidden: Bool {
        didSet { if isHidden { _forceClose(animated: false) } }
    }
    /// Disabling interaction also removes the popup and stops its gestures.
    public override var isUserInteractionEnabled: Bool {
        didSet { if !isUserInteractionEnabled { _forceClose(animated: false) } }
    }
    /// Applies the control's opacity once to its sibling popup as well as its center.
    public override var alpha: CGFloat {
        didSet { _openSpinnerView?.alpha = alpha; _openPickerContainerView?.alpha = alpha }
    }

    // MARK: - Construction and view lifecycle

    /// Creates an empty control with the supplied frame.
    public override init(frame inRect: CGRect) { super.init(frame: inRect); _setUp() }
    /// Restores a control and its inspectable configuration from a storyboard or archive.
    public required init?(coder inDecoder: NSCoder) { super.init(coder: inDecoder); _setUp() }
    /// Creates a control with items, an initial selection, a frame, presentation mode, and delegate.
    /// Initial configuration does not send delegate or target/action notifications.
    /// - Parameters:
    ///   - inValuesArray: Items in display order. Nil means no items.
    ///   - inSelectedIndex: The initial index, clamped to the available range.
    ///   - inFrame: The control's frame in its container.
    ///   - inSpinnerMode: Ring, picker, or automatic presentation. Defaults to automatic.
    ///   - inDelegate: A weakly held observer, assigned after initial configuration.
    public convenience init(values inValuesArray: [RVS_SpinnerDataItem]? = nil, selectedIndex inSelectedIndex: Int = 0, frame inFrame: CGRect = .zero, spinnerMode inSpinnerMode: SpinnerMode = .both, delegate inDelegate: RVS_SpinnerDelegate? = nil) {
        self.init(frame: inFrame)
        values = inValuesArray ?? []
        _selectedIndex = max(0, min(count - 1, inSelectedIndex))
        spinnerMode = inSpinnerMode.rawValue
        delegate = inDelegate
    }
    /// Creates an empty control with a zero frame.
    public convenience init() { self.init(frame: .zero) }

    private func _setUp() {
        _closedBackgroundColor = _closedBackgroundColor ?? super.backgroundColor
        super.backgroundColor = .clear
        isOpaque = false
        contentMode = .redraw
        isAccessibilityElement = true
        if #available(iOS 17.0, *) {
            registerForTraitChanges(UITraitCollection.systemTraitsAffectingColorAppearance) { (spinner: RVS_Spinner, _: UITraitCollection) in
                spinner._refreshAppearance()
            }
        }
    }
    /// Updates popup geometry when the control's container or bounds change.
    public override func layoutSubviews() {
        super.layoutSubviews()
        _correctRadius()
        setNeedsDisplay()
    }
    /// Removes owned sibling views before the control changes containers.
    public override func willMove(toSuperview newSuperview: UIView?) {
        if superview !== newSuperview {
            _isDetaching = true
            _forceClose(animated: false)
            _isDetaching = false
        }
        super.willMove(toSuperview: newSuperview)
    }
    /// Stops presentation when this control, or its container, leaves the window.
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            _isDetaching = true
            _forceClose(animated: false)
            _isDetaching = false
        }
    }
    /// Refreshes resolved layer colors on iOS 15 and 16; later versions use trait registration.
    @available(iOS, introduced: 15.0, deprecated: 17.0, message: "Appearance updates use trait registration on iOS 17 and later.")
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #unavailable(iOS 17.0), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            _refreshAppearance()
        }
    }
    /// Refreshes inherited tint changes as well as direct tint assignments.
    public override func tintColorDidChange() { super.tintColorDidChange(); _refreshAppearance() }

    private func _configurationChanged() {
        _revision &+= 1
        _forceClose(animated: false)
        setNeedsLayout()
        _refreshAppearance()
    }
    private func _refreshAppearance() {
        _animatedIconLayer?.removeFromSuperlayer()
        _animatedIconLayer = nil
        _openPickerView?.reloadAllComponents()
        if !isEmpty { _openPickerView?.selectRow(selectedIndex, inComponent: 0, animated: false) }
        setNeedsDisplay()
    }
    private func _correctRadius() {
        guard let container = superview else { return }
        let area = container.bounds
        let radius = max(0, min(center.x - area.minX, area.maxX - center.x, center.y - area.minY, area.maxY - center.y))
        if Double(radius) != _radiusOfOpenControlInDisplayUnits {
            _radiusOfOpenControlInDisplayUnits = Double(radius)
            _animatedIconLayer?.removeFromSuperlayer()
            _animatedIconLayer = nil
        }
        // Set bounds and center: frame is undefined while the opening transform is active.
        if let ring = _openSpinnerView {
            ring.bounds = CGRect(origin: .zero, size: _openSpinnerFrame.size)
            ring.center = center
            ring.layer.mask?.frame = ring.bounds
        }
        if let popup = _openPickerContainerView {
            let rect = _openPickerFrame
            popup.bounds = CGRect(origin: .zero, size: rect.size)
            popup.center = CGPoint(x: rect.midX, y: rect.midY)
            if _openPickerView?.frame != popup.bounds {
                _openPickerView?.frame = popup.bounds
                _openPickerView?.reloadAllComponents()
            }
        }
    }

    // MARK: - Popup lifecycle

    private func _openControl() {
        _removeClosingViews()
        _correctRadius()
        _impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        _selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        _impactFeedbackGenerator?.prepare()
        _selectionFeedbackGenerator?.prepare()
        _impactFeedback(sound: 1104)
        _animateCenter = replaceCenterImage && centerImage != nil
        let popup: UIView
        if opensAsSpinner {
            let ring = UIView(frame: _openSpinnerFrame)
            let tap = UITapGestureRecognizer(target: self, action: #selector(_handleOpenTapGesture(_:)))
            let hold = UILongPressGestureRecognizer(target: self, action: #selector(_handleOpenLongPressGesture(_:)))
            let pan = UIPanGestureRecognizer(target: self, action: #selector(_handleOpenPanGesture(_:)))
            tap.require(toFail: pan)
            tap.require(toFail: hold)
            ring.addGestureRecognizer(tap)
            ring.addGestureRecognizer(hold)
            ring.addGestureRecognizer(pan)
            ring.isAccessibilityElement = false
            ring.accessibilityElementsHidden = true
            _openSpinnerView = ring
            popup = ring
        } else {
            let container = UIView(frame: _openPickerFrame)
            let picker = UIPickerView(frame: container.bounds)
            picker.dataSource = self
            picker.delegate = self
            container.addSubview(picker)
            _openPickerView = picker
            _openPickerContainerView = container
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
            popup = container
        }
        popup.backgroundColor = .clear
        popup.alpha = alpha
        superview?.insertSubview(popup, belowSubview: self)
        if !UIAccessibility.isReduceMotionEnabled {
            popup.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 7,
                           options: [.allowUserInteraction, .beginFromCurrentState], animations: { popup.transform = .identity })
        }
        _refreshAppearance()
    }
    private func _forceClose(animated: Bool) {
        _stopSpinning()
        if !animated { _removeClosingViews() }
        guard _isOpen else { return }
        _isOpen = false
        _animateCenter = replaceCenterImage && centerImage != nil
        _revision &+= 1
        _impactFeedback(sound: 1105)
        let popup = _openSpinnerView ?? _openPickerContainerView
        _openPickerView?.delegate = nil
        _openPickerView?.dataSource = nil
        _openPickerView = nil
        _openSpinnerView = nil
        _openPickerContainerView = nil
        _animatedIconLayer = nil
        _selectionFeedbackGenerator = nil
        _impactFeedbackGenerator = nil
        if let popup = popup {
            popup.isUserInteractionEnabled = false
            popup.gestureRecognizers?.forEach { popup.removeGestureRecognizer($0) }
            if animated && !UIAccessibility.isReduceMotionEnabled {
                _closingViews.append(popup)
                UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    popup.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    popup.alpha = 0
                }, completion: { [weak self] _ in
                    popup.removeFromSuperview()
                    self?._closingViews.removeAll { $0 === popup }
                })
            } else {
                popup.layer.removeAllAnimations()
                popup.removeFromSuperview()
            }
        }
        setNeedsDisplay()
        delegate?.spinner(self, hasClosedWithTheValue: value)
    }
    private func _removeClosingViews() {
        let views = _closingViews
        _closingViews.removeAll()
        for view in views { view.layer.removeAllAnimations(); view.removeFromSuperview() }
    }
    private func _impactFeedback(sound: SystemSoundID) {
        if isSoundOn { AudioServicesPlaySystemSound(sound) }
        if isHapticsOn { _impactFeedbackGenerator?.impactOccurred(); _impactFeedbackGenerator?.prepare() }
    }
    private func _selectionFeedback() {
        guard isOpen else { return }
        if isSoundOn { AudioServicesPlaySystemSound(1103) }
        if isHapticsOn { _selectionFeedbackGenerator?.selectionChanged(); _selectionFeedbackGenerator?.prepare() }
    }

    // MARK: - Rendering

    /// Draws the center and updates the expanded ring, using full bounds even for a partial invalidation.
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        _drawControlCenter()
        _drawOpenControl()
    }
    private func _drawControlCenter() {
        guard let item = value else {
            _centerImageView?.removeFromSuperview()
            _centerImageView = nil
            return
        }
        let icon = isOpen && replaceCenterImage ? item.icon : centerImage ?? item.icon
        let holder: UIView
        if let existing = _centerImageView {
            holder = existing
            holder.frame = bounds
            holder.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        } else {
            holder = UIView(frame: bounds)
            holder.isUserInteractionEnabled = false
            holder.accessibilityElementsHidden = true
            addSubview(holder)
            _centerImageView = holder
        }
        let imageLayer = _makeIconLayer(icon, inFrame: holder.bounds, tintColor: _effectiveTint,
                                       isDimmed: !item.isEnabled || !isEnabled || (isTracking && isTouchInside && !_doneTracking))
        if isCompensatingForContainerRotation, let transform = superview?.transform {
            imageLayer.transform = CATransform3DMakeRotation(-atan2(transform.b, transform.a), 0, 0, 1)
        }
        holder.layer.addSublayer(imageLayer)
        if _animateCenter {
            _animateCenter = false
            if !UIAccessibility.isReduceMotionEnabled {
                holder.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 7,
                               options: [.beginFromCurrentState, .allowUserInteraction], animations: { holder.transform = .identity })
            }
        }
    }
    private func _makeIconLayer(_ icon: UIImage, inFrame frame: CGRect, tintColor color: UIColor, isDimmed: Bool = false) -> CALayer {
        let layer = CALayer()
        layer.frame = frame
        layer.opacity = isDimmed ? 0.5 : 1
        let rect = layer.bounds
        guard rect.width > 0, rect.height > 0, rect.width.isFinite, rect.height.isFinite else { return layer }
        if framedIcons {
            let outline = CAShapeLayer()
            outline.path = UIBezierPath(ovalIn: rect.insetBy(dx: 0.5, dy: 0.5)).cgPath
            outline.strokeColor = color.cgColor
            outline.fillColor = (_closedBackgroundColor ?? .clear).resolvedColor(with: traitCollection).cgColor
            outline.lineWidth = 1
            layer.addSublayer(outline)
        }
        guard icon.size.width > 0, icon.size.height > 0, icon.size.width.isFinite, icon.size.height.isFinite else { return layer }
        let target = framedIcons ? rect.insetBy(dx: rect.width * 0.2, dy: rect.height * 0.2) : rect
        let scale = min(target.width / icon.size.width, target.height / icon.size.height)
        let size = CGSize(width: icon.size.width * scale, height: icon.size.height * scale)
        guard size.width > 0, size.height > 0 else { return layer }
        // Rendering through UIImage handles SF Symbols, CI-backed images, orientation, and original colors.
        let format = UIGraphicsImageRendererFormat(for: traitCollection)
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let rendered = renderer.image { _ in
            let image = hudMode || icon.renderingMode == .alwaysTemplate ? icon.withTintColor(color, renderingMode: .alwaysOriginal) : icon
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: target.midX - size.width / 2, y: target.midY - size.height / 2, width: size.width, height: size.height)
        imageLayer.contents = rendered.cgImage
        imageLayer.contentsScale = rendered.scale
        layer.addSublayer(imageLayer)
        return layer
    }
    private func _drawOneValueRadius(_ inIndex: Int) -> CALayer? {
        guard values.indices.contains(inIndex) else { return nil }
        
        let value = values[inIndex]
    
        let centerPointInDisplayUnits = CGPoint(x: (_openSpinnerView?.bounds.size.width ?? 0) / 2, y: (_openSpinnerView?.bounds.size.height ?? 0) / 2)
        
        let circumferenceInDisplayUnits = CGFloat(Double.pi * 2 * _radiusOfOpenControlInDisplayUnits)
        
        let arcCircumferenceInDisplayUnits = circumferenceInDisplayUnits / CGFloat(values.count)

        let radiusInDisplayUnits = CGFloat(_radiusOfOpenControlInDisplayUnits)
    
        let centerAngleInRadians = (3 * CGFloat.pi) / 2
    
        let ret = CAShapeLayer()
        
        ret.frame = _openSpinnerView?.bounds ?? .zero

        let paddingWidth = Self._kOpenPaddingInDisplayUnits * 2

        let workingLength = max(0, CGFloat(_radiusOfOpenControlInDisplayUnits) - bounds.size.height / 2 - paddingWidth)
    
        let radiansPerValue = (2 * CGFloat.pi) / CGFloat(count) // This is how many radians in our 2π circle it takes to account for one value.
    
        let oppositeLength = min(workingLength, abs(2 * workingLength * sin(radiansPerValue / 2)))
    
        let path = UIBezierPath()
        path.move(to: centerPointInDisplayUnits)
        path.addArc(withCenter: centerPointInDisplayUnits, radius: radiusInDisplayUnits, startAngle: centerAngleInRadians - (_arclengthInRadians / 2), endAngle: centerAngleInRadians + (_arclengthInRadians / 2), clockwise: true)
        path.move(to: centerPointInDisplayUnits)
        
        ret.fillColor = (hudMode ? UIColor.clear : openBackgroundColor ?? .clear).resolvedColor(with: traitCollection).cgColor
        
        let iconSize = CGSize(width: oppositeLength, height: oppositeLength)
        
        let maxWidth = Swift.min(iconSize.width, oppositeLength)  // This is how wide the displayed icon will be.
        
        let imageSquareSize = Swift.min(maxWidth, arcCircumferenceInDisplayUnits / 2)  // The image is displayed in a square.
        
        let imageFrame = CGRect(origin: .zero, size: CGSize(width: imageSquareSize, height: imageSquareSize))

        let displayLayer = _makeIconLayer(value.icon, inFrame: imageFrame, tintColor: tintColor ?? .label, isDimmed: !value.isEnabled)

        let imageXPos = centerPointInDisplayUnits.x - (imageSquareSize / 2)
        let imageYPos = -(radiusInDisplayUnits - ((_openSpinnerView?.bounds.size.height ?? 0) / 2) - Self._kOpenPaddingInDisplayUnits)
        
        displayLayer.frame = displayLayer.frame.offsetBy(dx: imageXPos, dy: imageYPos)
        
        ret.path = path.cgPath
        
        ret.addSublayer(displayLayer)
        
        let rotationAngleInRadians = CGFloat.pi - (CGFloat(inIndex) * _arclengthInRadians)

        ret.transform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1.0)

        return ret
    }
    
    private func _drawOpenControl() {
        guard isOpen, let ring = _openSpinnerView, count > 1 else { return }
        if _animatedIconLayer == nil {
            let icons = CALayer()
            icons.frame = ring.bounds
            for index in values.indices {
                if let spoke = _drawOneValueRadius(index) { icons.addSublayer(spoke) }
            }
            let mask = CAGradientLayer()
            mask.frame = ring.bounds
            mask.type = .conic
            mask.startPoint = CGPoint(x: 0.5, y: 0.5)
            mask.endPoint = CGPoint(x: 0.5, y: 0)
            mask.colors = [1.0, 0.75, 0.5, 0.25, 0.25, 0.25, 0.5, 0.75, 1.0].map { UIColor.white.withAlphaComponent($0).cgColor }
            ring.layer.mask = mask
            ring.layer.addSublayer(icons)
            _animatedIconLayer = icons
        }
        CATransaction.begin()
        CATransaction.setDisableActions(UIAccessibility.isReduceMotionEnabled)
        CATransaction.setAnimationDuration(0.2)
        _animatedIconLayer?.transform = CATransform3DMakeRotation(CGFloat(selectedIndex) * _arclengthInRadians - .pi, 0, 0, 1)
        CATransaction.commit()
    }

    // MARK: - Interaction and flywheel

    private func _activate() -> Bool {
        guard _canActivate else { return false }
        if _decelerationDisplayLink != nil {
            _stopSpinning()
        } else if count == 1 {
            delegate?.spinner(self, singleValueSelected: value)
        } else {
            isOpen.toggle()
        }
        setNeedsDisplay()
        return true
    }
    /// Begins center tracking only when the control can be activated.
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard _canActivate else { return false }
        _doneTracking = false
        setNeedsDisplay()
        return true
    }
    /// Updates the pressed appearance while the touch moves.
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setNeedsDisplay()
        return true
    }
    /// Activates an inside release. UIKit delivers the physical `.touchUpInside` once.
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        _doneTracking = true
        if isTouchInside, _activate() { sendActions(for: .primaryActionTriggered) }
        setNeedsDisplay()
        super.endTracking(touch, with: event)
    }
    /// Clears the pressed appearance after a canceled touch, without changing selection.
    public override func cancelTracking(with event: UIEvent?) {
        _doneTracking = true
        setNeedsDisplay()
        super.cancelTracking(with: event)
    }
    @objc private func _handleOpenTapGesture(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended, let view = gesture.view else { return }
        _handleOpenTouchEvent(gesture.location(in: view), forView: view)
    }
    @objc private func _handleOpenLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began, let view = gesture.view else { return }
        _handleOpenTouchEvent(gesture.location(in: view), forView: view)
    }
    private func _handleOpenTouchEvent(_ point: CGPoint, forView view: UIView) {
        guard _canActivate, isOpen, count > 1 else { return }
        if _decelerationDisplayLink != nil { _stopSpinning(); return }
        _step(by: point.x < view.bounds.midX ? -1 : 1)
    }
    private func _step(by steps: Int) {
        guard count > 1 else { return }
        // Reduce before adding, avoiding repeated loops and overflow from large steps.
        let step = steps % count
        let index = selectedIndex
        selectedIndex = step >= 0 ? (index >= count - step ? index - (count - step) : index + step)
            : (index < -step ? count + step + index : index + step)
    }
    @objc private func _handleOpenPanGesture(_ gesture: UIPanGestureRecognizer) {
        guard _canActivate, isOpen, count > 1, let ring = _openSpinnerView else { _stopSpinning(); return }
        let point = gesture.location(in: ring)
        let angle = atan2(point.y - ring.bounds.midY, point.x - ring.bounds.midX)
        guard angle.isFinite else { return }
        if gesture.state == .began {
            _stopSpinning()
            let translation = gesture.translation(in: ring)
            _previousPanAngle = atan2(point.y - translation.y - ring.bounds.midY, point.x - translation.x - ring.bounds.midX)
            _panAccumulator = 0
        }
        if gesture.state == .began || gesture.state == .changed || gesture.state == .ended {
            var delta = angle - _previousPanAngle
            if delta > .pi { delta -= 2 * .pi }
            if delta < -.pi { delta += 2 * .pi }
            _previousPanAngle = angle
            let damping = max(1, CGFloat(count) / CGFloat(spinnerThreshold))
            _panAccumulator += delta / (_arclengthInRadians * damping)
            guard let steps = Int(exactly: _panAccumulator.rounded(.towardZero)) else {
                _panAccumulator = 0
                _stopSpinning()
                return
            }
            _panAccumulator -= CGFloat(steps)
            _step(by: steps)
            // A selection callback may have closed or replaced the popup.
            guard isOpen, _openSpinnerView === ring else { return }
            if gesture.state == .ended, !UIAccessibility.isReduceMotionEnabled {
                let velocity = gesture.velocity(in: ring)
                let tangent = -sin(angle) * velocity.x + cos(angle) * velocity.y
                _startYourEngines(tangent / 600)
            }
        } else if gesture.state == .cancelled || gesture.state == .failed { _stopSpinning() }
    }
    private func _startYourEngines(_ velocity: CGFloat) {
        _stopSpinning()
        guard velocity.isFinite, abs(velocity) >= 0.8, isOpen, _openSpinnerView != nil else { return }
        _currentFlywheelVelocity = max(-100, min(100, velocity))
        let target = DisplayLinkTarget(owner: self)
        let link = CADisplayLink(target: target, selector: #selector(DisplayLinkTarget.tick(_:)))
        link.preferredFramesPerSecond = 60
        _decelerationDisplayLink = link
        link.add(to: .main, forMode: .common)
    }
    private func _stopSpinning() {
        _decelerationDisplayLink?.invalidate()
        _decelerationDisplayLink = nil
        _currentFlywheelVelocity = 0
        _decelerationAccumulator = 0
    }
    private func _decelerationStep(_ link: CADisplayLink) {
        guard _canActivate, isOpen, count > 1, !UIAccessibility.isReduceMotionEnabled else { _stopSpinning(); return }
        let frameScale = CGFloat(max(0, min(0.1, link.targetTimestamp - link.timestamp))) * 60
        _currentFlywheelVelocity *= pow(0.994, frameScale)
        // Check on every frame, even if no whole item was traversed.
        guard abs(_currentFlywheelVelocity) >= 0.8 else { _stopSpinning(); return }
        _decelerationAccumulator += 0.1 * _currentFlywheelVelocity * frameScale
        let steps = Int(_decelerationAccumulator)
        _decelerationAccumulator -= CGFloat(steps)
        if steps != 0 { _step(by: steps) }
    }

    // MARK: - Accessibility

    /// The item's title by default. Set a custom value to override it; set nil to restore the default.
    public override var accessibilityValue: String? {
        get { super.accessibilityValue ?? value?.title }
        set { super.accessibilityValue = newValue }
    }
    /// The item's optional description, unless the application provides a custom hint.
    public override var accessibilityHint: String? {
        get { super.accessibilityHint ?? value?.description }
        set { super.accessibilityHint = newValue }
    }
    /// Exposes button activation, adjustment for multiple items, and the disabled state.
    public override var accessibilityTraits: UIAccessibilityTraits {
        get {
            var traits = super.accessibilityTraits.union(.button)
            if count > 1 { traits.insert(.adjustable) }
            if !_canActivate { traits.insert(.notEnabled) }
            return traits
        }
        set { super.accessibilityTraits = newValue }
    }
    /// Performs center activation for assistive technology and sends the two activation events once.
    public override func accessibilityActivate() -> Bool {
        guard _activate() else { return false }
        sendActions(for: [.touchUpInside, .primaryActionTriggered])
        return true
    }
    /// Performs semantic primary activation, using the same path as accessibility.
    @available(iOS 17.4, *)
    public override func performPrimaryAction() { _ = accessibilityActivate() }
    /// Selects the next item, wrapping at the end, without requiring an open popup.
    public override func accessibilityIncrement() { if _canActivate { _stopSpinning(); _step(by: 1) } }
    /// Selects the previous item, wrapping at the start, without requiring an open popup.
    public override func accessibilityDecrement() { if _canActivate { _stopSpinning(); _step(by: -1) } }

    // MARK: - UIPickerView integration

    /// Returns the single component used by the built-in picker.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    /// Returns the current number of items for the built-in picker.
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { count }
    /// Returns a 40-point row height, independent of the popup's available height.
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { 40 }
    /// Builds a row from current data, colors, and font; previously supplied row contents are discarded.
    /// Invalid row indices return an empty view.
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let result = UIView(frame: CGRect(x: 0, y: 0, width: max(0, pickerView.bounds.width), height: 40))
        guard values.indices.contains(row) else { return result }
        let item = values[row]
        result.backgroundColor = hudMode ? .clear : openBackgroundColor
        let label = UILabel()
        label.font = displayFont ?? .boldSystemFont(ofSize: 20)
        label.text = item.title
        label.textColor = _effectiveTint.cgColor.alpha == 0 ? .label : _effectiveTint
        label.alpha = item.isEnabled ? 1 : 0.5
        let iconSize = min(24, result.bounds.width)
        let gap: CGFloat = item.title.isEmpty ? 0 : 8
        let labelWidth = min(max(0, result.bounds.width - iconSize - gap), label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 24)).width)
        let left = max(0, (result.bounds.width - iconSize - gap - labelWidth) / 2)
        let icon = _makeIconLayer(item.icon, inFrame: CGRect(x: left, y: 8, width: iconSize, height: 24), tintColor: _effectiveTint, isDimmed: !item.isEnabled)
        result.layer.addSublayer(icon)
        label.frame = CGRect(x: left + iconSize + gap, y: 8, width: labelWidth, height: 24)
        result.addSubview(label)
        result.isAccessibilityElement = true
        result.accessibilityLabel = item.title
        return result
    }
    /// Selects a valid row, including a dimmed item; invalid or disabled-control callbacks are ignored.
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard _canActivate, values.indices.contains(row) else { return }
        selectedIndex = row
    }
}
