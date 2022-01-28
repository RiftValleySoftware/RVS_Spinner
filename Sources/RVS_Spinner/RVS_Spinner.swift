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
 
 - version: 2.5.10
 */

import AudioToolbox

#if os(iOS) // This prevents the IB errors from showing up, under SPM (From SO Answer: https://stackoverflow.com/a/66334661/879365).
import UIKit

/* ###################################################################################################################################### */
// MARK: - Color Test Extension -
/* ###################################################################################################################################### */
/**
 This allows us to see if a color is clear.
 */
private extension UIColor {
    /* ################################################################## */
    /**
     - returns true, if the color is clear.
     */
    var isClear: Bool {
        var white: CGFloat = 0, h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if !getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            return 0.0 == a
        } else if getWhite(&white, alpha: &a) {
            return 0.0 == a
        }
        
        return false
    }
}

/* ################################################################################################################################## */
// MARK: - Public Control Value Data Struct
/* ################################################################################################################################## */
/* ################################################################## */
/**
 This struct is used to represent one value of the spinner.
 
 It has only one required value: an icon, represented by a UIImage. It can be any size, but you shouldn't need anything bigger than about 100 display units square.
 */
public struct RVS_SpinnerDataItem {
    /** This is the optional title for the data item. */
    public let title: String
    /** This is the required image to be displayed for the data item. This is what is most prominently displayed. */
    public let icon: UIImage
    /** This is an optional description String, which can provide more detailed information about the data item. */
    public let description: String?
    /** This is any associated data value. It is an optional "Any," and needs to be cast. */
    public let value: Any?
    /** This is the enabled flag for the item. It is defaulted to true. */
    public let isEnabled: Bool
    
    /* ################################################################## */
    /**
     The default initializer. The only required argument is the icon.
     
     - parameter inTitle: A String, with the title of this value. This is optional. Default is a blank String.
     - parameter icon: An image to be displayed for the value. This is the only required argument.
     - parameter description: An optional String (default is nil), with a description of the value.
     - parameter value: An optional value (default is nil) to be associated with this value item.
     - parameter isEnabled: An optional value (default is true). If false, the item is disabled.
     */
    public init(title inTitle: String = "", icon inIcon: UIImage, description inDescription: String? = nil, value inValue: Any? = nil, isEnabled inIsEnabled: Bool = true) {
        title = inTitle
        icon = inIcon
        description = inDescription
        value = inValue
        isEnabled = inIsEnabled
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Delegate Protocol -
/* ###################################################################################################################################### */
/**
 This is the delegate protocol for the Spinner. It is a Swift class protocol, because it provides the delegate with a Swift object, and is weakly referenced by the Spinner.
 
 Its methods are all "optional" (they have default implementations that do nothing), but the control works best if you use them.
 */
@available(iOS 13.0, *)
public protocol RVS_SpinnerDelegate: AnyObject {
    /* ################################################################## */
    /**
     This is called if there was only one value, and the user selected the central button.
     In this case, the control will not open, but we will send a message.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter singleValueSelected: The value that was just selected. This is optional.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?)
    
    /* ################################################################## */
    /**
     This is called after the user has used the Spinner to select a value.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasSelectedTheValue: The value that was just selected. This is optional.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?)
    
    /* ################################################################## */
    /**
     This is called after the user has "opened" the Spinner.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasOpenedWithTheValue: The value that was selected when the control opened. This is optional.
     */
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?)

    /* ################################################################## */
    /**
     This is called after the user has "closed" the Spinner.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasClosedWithTheValue: The value that was selected when the control closed. This is optional.
     */
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?)
    
    /* ################################################################## */
    /**
     This is called before the user closes the spinner. It allows the delegate to interrupt the close process.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter willCloseWithTheValue: The value that was selected when the control close was attempted. This is optional.
     - returns: True, if the spinner is allowed to continue closing. False, to prevent the spinner from closing.
     */
    func spinner(_: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool
}

/* ###################################################################################################################################### */
/**
 These empty methods allow the protocol methods to be "optional."
 */
@available(iOS 13.0, *)
public extension RVS_SpinnerDelegate {
    /* ################################################################## */
    /**
     This is an optional method.
     
     This is called if there was only one value, and the user selected the central button.
     In this case, the control will not open, but we will send a message.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter singleValueSelected: The value that was just selected. This is optional.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, singleValueSelected:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     This is called after the user has used the Spinner to select a value.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasSelectedTheValue: The value that was just selected. This is optional.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasSelectedTheValue:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     This is called after the user has "opened" the Spinner.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasOpenedWithTheValue: The value that was selected when the control opened. This is optional.
     */
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasOpenedWithTheValue:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     This is called after the user has "closed" the Spinner.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasClosedWithTheValue: The value that was selected when the control closed. This is optional.
     */
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasClosedWithTheValue:) called in default.")
        #endif
    }
    
    /* ################################################################## */
    /**
     This is called before the user closes the spinner. It allows the delegate to interrupt the close process.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter willCloseWithTheValue: The value that was selected when the control close was attempted. This is optional.
     - returns: True, if the spinner is allowed to continue closing. False, to prevent the spinner from closing.
     */
    func spinner(_: RVS_Spinner, willCloseWithTheValue: RVS_SpinnerDataItem?) -> Bool {
        #if DEBUG
            print("spinner(:, willCloseWithTheValue:) called in default.")
        #endif
        return true
    }
}

/* ###################################################################################################################################### */
// MARK: - Public Main Class -
/* ###################################################################################################################################### */
/**
 This is a "spinner" control, which acts a bit like a circular UIPickerView.
 
 However, instead of having the values provided by a delegate/datasource, the values are associated directly with the control in an Array.
 
 This control has a lot of "little things" to make it usable and intuitive. It has "inertia," where you can start it spinning, it has "one-tap increment/decrement,"
 and it has haptic and audio feedback.
 
 It can switch between the circular spinner, and a standard UIPickerView, if there are too many items to handle efficiently in a spinner. You can choose to either
 always use the picker, or never use the picker.
 
 There is a delegate protocol, and the control will also emit "valueChanged" messages (the selected item changed), and "touchUpInside" messages (the center was tapped).
 */
@IBDesignable
@available(iOS 13.0, *)
open class RVS_Spinner: UIControl, UIPickerViewDelegate, UIPickerViewDataSource {
    /* ################################################################################################################################## */
    // MARK: - Private Static Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the "opening" system sound.
     */
    private static let _kOpenSystemSoundID: UInt32 = 1104
    
    /* ################################################################## */
    /**
     This is the "setting" system sound.
     */
    private static let _kSelectSystemSoundID: UInt32 = 1103
    
    /* ################################################################## */
    /**
     This is the "closing" system sound.
     */
    private static let _kCloseSystemSoundID: UInt32 = 1105

    /* ################################################################## */
    /**
     This is the width of the lines in the control, in display units.
     */
    private static let _kBorderWidthInDisplayUnits: CGFloat = 1.0
    
    /* ################################################################## */
    /**
     This is The inset we give images, if there will be a frame around them.
     */
    private static let _kFrameInsetMultiplier: CGFloat = 0.2
    
    /* ################################################################## */
    /**
     This is the opacity to use as a quotient, when calculating reduced opacity, away from the top.
     */
    private static let _kDistanceOpacityQuotient: Float = 0.25
    
    /* ################################################################## */
    /**
     This is the opacity to use when dimmed.
     */
    private static let _kDimmedOpacity: Float = 0.5

    /* ################################################################## */
    /**
     This is the duration for opening animations
     */
    private static let _kOpeningAnimationDurationInSeconds: TimeInterval = 0.25

    /* ################################################################## */
    /**
     This is the duration for closing animations
     */
    private static let _kClosingAnimationDurationInSeconds: TimeInterval = 0.3
    
    /* ################################################################## */
    /**
     The damping coefficient for the closing animation.
     */
    private static let _kCloseDamping: CGFloat = 0.8
    
    /* ################################################################## */
    /**
     The damping coefficient for the opening animation.
     */
    private static let _kOpenDamping: CGFloat = 1.0
    
    /* ################################################################## */
    /**
     The damping coefficient for the opening animation (alternate).
     */
    private static let _kOpenDamping2: CGFloat = 0.8
    
    /* ################################################################## */
    /**
     The bounce scale coefficient for the opening animation.
     */
    private static let _kBounceScale: CGFloat = 0.001

    /* ################################################################## */
    /**
     The initial velocity coefficient for the opening animation.
     */
    private static let _kOpenInitialVelocity: CGFloat = 7.0
    
    /* ################################################################## */
    /**
     The initial velocity coefficient for the opening animation (alternate).
     */
    private static let _kOpenInitialVelocity2: CGFloat = 25.0

    /* ################################################################## */
    /**
     This is the padding in the open control "pie slices.".
     */
    private static let _kOpenPaddingInDisplayUnits: CGFloat = 8.0
    
    /* ################################################################## */
    /**
     This is the largest square image we allow in the pickerview.
     */
    private static let _kMaxOpenPickerViewImageSizeInDisplayUnits: CGFloat = 40.0
    
    /* ################################################################## */
    /**
     This is the maximum velocity for the "flywheel."
     */
    private static let _kMaxFlywheelVelocity: CGFloat = 100
    
    /* ################################################################## */
    /**
     This is the minimum velocity for the "flywheel." Below this, the spinner "clicks" in a value.
     */
    private static let _kMinFlywheelVelocity: CGFloat = 0.8
    
    /* ################################################################## */
    /**
     This is the deceleration constant for the "flywheel." It is reduced to this amount, each iteration.
     */
    private static let _kFlywheelVelocityDecelerationMultiplier: CGFloat = 0.994
    
    /* ################################################################## */
    /**
     This is a constant for the "accumulator" of the "flywheel."
     */
    private static let _kFlywheelVelocityDecelerationNudgeMultiplier: CGFloat = 0.1
    
    /* ################################################################## */
    /**
     This is the preferred frames per second for our decelerator.
     */
    private static let _kFlywheelPreferredFramesPerSecond: Int = 60
    
    /* ################################################################## */
    /**
     This is used to derive the velocity from the pan.
     */
    private static let _kFlywheelVelocityDivisor: CGFloat = 600
    
    /* ################################################################## */
    /**
     These denote the transparency mask that we use to fade unselected items.
     */
    private static let _kTransparencyGradientSteps = [UIColor.white.cgColor,
                                                      UIColor.white.withAlphaComponent(0.55).cgColor,
                                                      UIColor.white.withAlphaComponent(0.40).cgColor,
                                                      UIColor.white.withAlphaComponent(0.25).cgColor,
                                                      UIColor.white.withAlphaComponent(0.1).cgColor,
                                                      UIColor.white.withAlphaComponent(0.03).cgColor,
                                                      UIColor.clear.cgColor,
                                                      UIColor.white.withAlphaComponent(0.03).cgColor,
                                                      UIColor.white.withAlphaComponent(0.1).cgColor,
                                                      UIColor.white.withAlphaComponent(0.25).cgColor,
                                                      UIColor.white.withAlphaComponent(0.40).cgColor,
                                                      UIColor.white.withAlphaComponent(0.55).cgColor,
                                                      UIColor.white.cgColor
    ]

    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is a flag, ensuring that we don't overdo the registration.
     */
    private var _registeredOrientationObserver: Bool = false
    
    /* ################################################################## */
    /**
     This is the display view for the center image.
     
     It's a weak reference to avoid memory leaks.
     */
    private weak var _centerImageView: UIView!
    
    /* ################################################################## */
    /**
     This is the display layer for the animated circle of icons image.
     
     It's a weak reference to avoid memory leaks.
     */
    private weak var _animatedIconLayer: CALayer!
    
    /* ################################################################## */
    /**
     This is used to animate the spin.
     */
    private var _spinnerAnimation: CABasicAnimation!
    
    /* ################################################################## */
    /**
     This is a layer that contains a transparency mask for the spinner. It is applied to the open spinner layer as a mask.
     */
    private var _spinnerTransparencyMask: CAGradientLayer?

    /* ################################################################## */
    /**
     This is the background color associated with the "closed" control.
     
     This is set from the view background color. When we set it, we set the UIView background color to clear.
     */
    private var _closedBackgroundColor: UIColor? {
        didSet {
            DispatchQueue.main.async {
                super.backgroundColor = UIColor.clear
                self._clearDisplayCaches()
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is the radius of the open control "pie slices.".
     */
    private var _radiusOfOpenControlInDisplayUnits: Double = 0.0
    
    /* ################################################################## */
    /**
     This is the circumferential length of one "spoke" arc.
     */
    private var _arclengthInRadians: CGFloat = 0.0

    /* ################################################################## */
    /**
     This is used to track the velocity for "flywheel" behavior.
     */
    private var _flywheelVelocity: CGFloat = 0
    
    /* ################################################################## */
    /**
     This is also used to track the velocity for "flywheel" behavior during deceleration.
     */
    private var _currentFlywheelVelocity: CGFloat = 0
    
    /* ################################################################## */
    /**
     This is a Core Animation Display Link pointer that we use for the decelerator.
     */
    private var _decelerationDisplayLink: CADisplayLink?
    
    /* ################################################################## */
    /**
     This accumulates "bumps" to "nudge" the value as we decelerate.
     */
    private var _decelerationAccumulator: CGFloat = 0
    
    /* ################################################################## */
    /**
     This is the first angle for a pan. We use this to track the delta.
     */
    private var _initialAngleForPan: CGFloat = 0
    
    /* ################################################################## */
    /**
     This is the item that was selected when we started the pan.
     */
    private var _initialSelectionForPan: Int = 0
    
    /* ################################################################## */
    /**
     This is an invisible view that we instantiate over the control to catch gestures and display the open control.
     It is only available when the control is open, and it is the spinner variant.
     */
    private var _openSpinnerView: UIView!

    /* ################################################################## */
    /**
     This is the gesture recognizer we will use to determine if the control is being spun/panned.
     */
    private var _rotateGestureRecognizer: UIPanGestureRecognizer!

    /* ################################################################## */
    /**
     This is the gesture recognizer we will use to determine if the control is being tapped.
     */
    private var _tapGestureRecognizer: UITapGestureRecognizer!

    /* ################################################################## */
    /**
     This is the gesture recognizer we will use to determine if the control is being tapped, but in a long, lingering, kinda creepy way.
     */
    private var _longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    /* ################################################################## */
    /**
     This is a UIView that will hold the picker. It is only available for the picker variant.
     */
    private var _openPickerContainerView: UIView!
    
    /* ################################################################## */
    /**
     This is standard UIPickerView, for when we have too much.
     */
    private var _openPickerView: UIPickerView!

    /* ################################################################## */
    /**
     This is a semaphore to indicate that we are done tracking the control.
     */
    private var _doneTracking: Bool = true
    
    /* ################################################################## */
    /**
     This is a flag (yuch) that we use when opening, so we know to replace the center (maybe).
     It is only relevant during the opening phase of the control center.
     */
    private var _isOpening: Bool = false
    
    /* ################################################################## */
    /**
     This is the stored property for the isOpen computed property.
     */
    private lazy var _isOpen: Bool = false

    /* ################################################################## */
    /**
     This will provide haptic/audio feedback for opening and closing the control.
     */
    private var _impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    /* ################################################################## */
    /**
     This will provide haptic/audio feedback for selection "ticks."
     */
    private var _selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    
    /* ################################################################## */
    /**
     This stupid flag will be set the first time we open, so we do the animation.
     
     Semaphores are a bad idea, in general. I used to love them, but they don't play well with asynchronous environments.
     */
    private var _stupidAnimationFlag: Bool = false
    
    /* ################################################################## */
    /**
     This stupid flag is used to force animation of the center. We set it to true, after opening the control, so the center gets animated.
     
     Semaphores are a bad idea, in general. I used to love them, but they don't play well with asynchronous environments.
     */
    private var _stupidAnimationFlagCenter: Bool = false

    /* ################################################################################################################################## */
    // MARK: - Private Instance Calculated Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the frame for the open spinner.
     */
    private var _openSpinnerFrame: CGRect { CGRect(x: frame.midX - CGFloat(_radiusOfOpenControlInDisplayUnits), y: frame.midY - CGFloat(_radiusOfOpenControlInDisplayUnits), width: CGFloat(_radiusOfOpenControlInDisplayUnits) * 2, height: CGFloat(_radiusOfOpenControlInDisplayUnits) * 2) }
    
    /* ################################################################## */
    /**
     This is the frame for the open picker. It starts at a place just above the vertical center.
     */
    private var _openPickerFrame: CGRect { CGRect(x: _openSpinnerFrame.origin.x, y: _openSpinnerFrame.origin.y, width: _openSpinnerFrame.size.width, height: (_openSpinnerFrame.size.height / 2) - (bounds.size.height / 2)) }

    /* ################################################################################################################################## */
    // MARK: - Private Instance Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This begins the deceleration/flywheel.
     
     - parameter inVelocity: The initial velocity. Negative is clockwise, positive, widdershins.
     */
    private func _startYourEngines(_ inVelocity: CGFloat) {
        _flywheelVelocity = inVelocity
        _currentFlywheelVelocity = _flywheelVelocity
        _decelerationAccumulator = 0
        _decelerate()
    }
    
    /* ################################################################## */
    /**
     This plays a sound (and gives haptic feedback) for the "opening" animation.
     */
    private func _playOpenSound() {
        guard !isOpen else { return }
        
        if isSoundOn {
            AudioServicesPlaySystemSound(Self._kOpenSystemSoundID)
        }
        
        if isHapticsOn {
            _impactFeedbackGenerator?.impactOccurred()
            _impactFeedbackGenerator?.prepare()
        }
    }
    
    /* ################################################################## */
    /**
     This plays the faint "tink" sound when a new value is selected.
     */
    private func _playSelectionTink() {
        guard isOpen else { return }
        
        if isSoundOn {
            AudioServicesPlaySystemSound(Self._kSelectSystemSoundID)
        }
        
        if isHapticsOn {
            _selectionFeedbackGenerator?.selectionChanged()
            _selectionFeedbackGenerator?.prepare()
        }
    }

    /* ################################################################## */
    /**
     This plays a sound for the control closing.
     */
    private func _playCloseSound() {
        guard isOpen else { return }
        
        if isSoundOn {
            AudioServicesPlaySystemSound(Self._kCloseSystemSoundID)
        }
        
        if isHapticsOn {
            _impactFeedbackGenerator?.impactOccurred()
            _impactFeedbackGenerator?.prepare()
        }
    }

    /* ################################################################## */
    /**
     This continues the deceleration/flywheel.
     */
    private func _decelerate() {
        if nil != _openSpinnerView && isOpen {
            _currentFlywheelVelocity = Swift.min(abs(_currentFlywheelVelocity), Self._kMaxFlywheelVelocity) * (0 > _currentFlywheelVelocity ? -1 : 1)
            if Swift.abs(_currentFlywheelVelocity) >= Self._kMinFlywheelVelocity {
                _decelerationDisplayLink?.invalidate()
                // The displaylink will keep "poking," until we are done.
                _decelerationDisplayLink = CADisplayLink(target: self, selector: #selector(Self._decelerationStep))
                _decelerationDisplayLink?.preferredFramesPerSecond = Self._kFlywheelPreferredFramesPerSecond
                _decelerationDisplayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)  // In the main loop, so we can tweak UI.
            } else {
                _decelerationDisplayLink?.invalidate()
                _decelerationDisplayLink = nil
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is a callback that handles one step in the decelerator.
     What we do, is "nudge" an "accumulator" as each cycle goes.
     When it has gone past 1 (or -1), then we move the selection.
     The faster we're going, the bigger the "nudge."
     
     Normally, what you do in these cases, is calculate a "logarithmic decrement."
     That gives you a very realistic deceleration. However, it's a bit of a pain to
     translate that to a "detented" set of integer values.
     This way does that, and gives a fairly realistic logarithmic response.
     */
    @objc private func _decelerationStep() {
        let newVelocity = _currentFlywheelVelocity * Self._kFlywheelVelocityDecelerationMultiplier
        _currentFlywheelVelocity = newVelocity
        let nudge = Self._kFlywheelVelocityDecelerationNudgeMultiplier * newVelocity
        _decelerationAccumulator += nudge

        // This just gives a slightly smoother round.
        let stepsToRotate = Int(round(_decelerationAccumulator * 10) / 10)

        // If we have exceeded 1, then we need to adjust the value.
        if 0 != stepsToRotate {
            _decelerationAccumulator = 0
            let currentIndex = selectedIndex
            var newSelection = currentIndex + stepsToRotate

            while newSelection >= count {
                newSelection -= count
            }
            
            while newSelection < 0 {
                newSelection += count
            }
            
            selectedIndex = newSelection
            _selectionFeedbackGenerator?.prepare()
            setNeedsDisplay()
            _decelerate()
        }
    }

    /* ################################################################## */
    /**
     This draws the control in a "closed" state. This is also used to draw the center, which is the same for both.
     
     It will always be a filled circle outline.
     
     - parameter inRect: The drawing rectangle
     */
    private func _drawControlCenter(_ inRect: CGRect) {
        _centerImageView?.removeFromSuperview()
        _centerImageView = nil
        
        if 0 < values.count {   // Have to have values to draw anything more.
            // We stroke and fill the basic shape with the colors we have set up.
            let centerLayer = CAShapeLayer()
            centerLayer.frame = bounds

            // Get the image to be displayed over the oval. We first see if one has been assigned. If we are in HUD mode, then the value will always be in template mode.
            let selectedValueIcon = hudMode ? values[selectedIndex].icon.withRenderingMode(.alwaysTemplate) : values[selectedIndex].icon
            let selectCenterImage = centerImage ?? selectedValueIcon
            let useCenterImage = !(replaceCenterImage && (_isOpening || isOpen)) || !replaceCenterImage
            let centerImage = useCenterImage ? selectCenterImage : selectedValueIcon
            let isDimmed = !values[selectedIndex].isEnabled || !isEnabled || (isTracking && isTouchInside && !_doneTracking)
            let imageLayer = _makeIconLayer(centerImage, inFrame: centerLayer.frame, tintColor: tintColor, isDimmed: isDimmed)
            if isCompensatingForContainerRotation { // If we are compensating for container rotation, we null out that rotation for the center icon.
                if let superTransform = superview?.transform {
                    let rotationInRadians = -CGFloat(atan2(Double(superTransform.b), Double(superTransform.a)))
                    imageLayer.transform = CATransform3DRotate(imageLayer.transform, rotationInRadians, 0.0, 0.0, 1.0)
                }
            }
            
            centerLayer.addSublayer(imageLayer)
            
            let temp = UIView(frame: bounds)
            temp.layer.addSublayer(centerLayer)
            temp.tintColor = tintColor
            temp.isUserInteractionEnabled = false
            _centerImageView = temp
            
            if _stupidAnimationFlagCenter {
                _centerImageView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                // We animate the center display, making it "bounce."
                UIView.animate(withDuration: Self._kOpeningAnimationDurationInSeconds,
                               delay: 0,
                               usingSpringWithDamping: Self._kOpenDamping2,
                               initialSpringVelocity: Self._kOpenInitialVelocity2,
                               options: .allowUserInteraction,
                               animations: { [weak self] in self?._centerImageView.transform = .identity },
                               completion: { [weak self] _ in self?._stupidAnimationFlagCenter = false
                               }
                )
            }
            
            addSubview(temp)
        }
    }
    
    /* ################################################################## */
    /**
     This draws one of the "spokes" that surround the center of an open spinner.
     It calculates the size of the images to be drawn at the end of each spoke to fit in the space provided.
     
     - parameter inIndex: The 0-based index of the value to be used.
     */
    private func _drawOneValueRadius(_ inIndex: Int) -> CALayer! {
        guard !values.isEmpty else { return nil }
        
        let value = values[inIndex]
    
        // This is the center of the control. All spokes start here.
        let centerPointInDisplayUnits = CGPoint(x: _openSpinnerView.bounds.size.width / 2, y: _openSpinnerView.bounds.size.height / 2)
        
        // This is the circumference of the entire open spinner.
        let circumferenceInDisplayUnits = CGFloat(Double.pi * 2 * _radiusOfOpenControlInDisplayUnits)
        
        // This is the length (circular) of the arc segment that caps each spoke.
        let arcCircumferenceInDisplayUnits = circumferenceInDisplayUnits / CGFloat(values.count)

        // This is the radius we have available. It will be calculated dynamically to fit in our allotted space.
        let radiusInDisplayUnits = CGFloat(_radiusOfOpenControlInDisplayUnits)
    
        // This is the angle at which this spoke will be shown (Right up and down).
        let centerAngleInRadians = (3 * CGFloat.pi) / 2
    
        // This is what we'll be changing and returning.
        let ret = CAShapeLayer()
        
        ret.frame = _openSpinnerView.bounds

        // This is how much padding we'll want around the image.
        let paddingWidth = Self._kOpenPaddingInDisplayUnits * 2

        // This is the distance between our circumference, and the outside of the center circle, and adding some padding on either end.
        let workingLength = (CGFloat(_radiusOfOpenControlInDisplayUnits) - bounds.size.height) - paddingWidth
    
        // This is all pretty rough, but it will get us there. We use some basic trig to get a rough idea of how much room we have, if we need to shrink.
        let radiansPerValue = (2 * CGFloat.pi) / CGFloat(count) // This is how many radians in our 2π circle it takes to account for one value.
    
        // This is the width of the end of our little "measuring triangle." It is the distance in a straight line from the center of the spoke to the edge.
        // The workingLength is our adjacent side, and we know the angle, which is a spoke angle, divided by 2.
        let oppositeLength = Swift.min(workingLength, abs((workingLength * tan(radiansPerValue / 2)) * 2))
    
        // Draw the spoke.
        let path = UIBezierPath()
        path.move(to: centerPointInDisplayUnits)
        path.addArc(withCenter: centerPointInDisplayUnits, radius: radiusInDisplayUnits, startAngle: centerAngleInRadians - (_arclengthInRadians / 2), endAngle: centerAngleInRadians + (_arclengthInRadians / 2), clockwise: true)
        path.move(to: centerPointInDisplayUnits)
        
        ret.fillColor = hudMode ? UIColor.clear.cgColor : !openBackgroundColor.isClear ? openBackgroundColor.withAlphaComponent(alpha).cgColor : nil
        
        // This is how big each icon will be, in our rendered spoke.
        let iconSize = CGSize(width: oppositeLength, height: oppositeLength)
        
        // We like to have a fixed size, but if the image is smaller, or we are packed in too tight, we may need to go smaller.
        let maxWidth = Swift.min(iconSize.width, oppositeLength)  // This is how wide the displayed icon will be.
        
        let imageSquareSize = Swift.min(maxWidth, arcCircumferenceInDisplayUnits / 2)  // The image is displayed in a square.
        
        let imageFrame = CGRect(origin: .zero, size: CGSize(width: imageSquareSize, height: imageSquareSize))

        // Each image is the same as the center.
        let displayLayer = _makeIconLayer(value.icon, inFrame: imageFrame, tintColor: tintColor, isDimmed: !value.isEnabled)

        let imageXPos = centerPointInDisplayUnits.x - (imageSquareSize / 2)
        let imageYPos = -(radiusInDisplayUnits - (_openSpinnerView.bounds.size.height / 2) - Self._kOpenPaddingInDisplayUnits)
        
        displayLayer.frame = displayLayer.frame.offsetBy(dx: imageXPos, dy: imageYPos)
        
        ret.path = path.cgPath
        
        ret.addSublayer(displayLayer)
        
        // Apply the rotation. This is the angle we need to rotate by to fit the spoke in the wheel.
        let rotationAngleInRadians = CGFloat.pi - (CGFloat(inIndex) * _arclengthInRadians)

        ret.transform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1.0)

        return ret
    }
    
    /* ################################################################## */
    /**
     This creates a displayable icon; either standalone, or enclosed in a frame.
     
     - parameter inIcon: The image to be displayed as an icon.
     - parameter inFrame: The frame we want the icon displayed in. It will be normalized to zero-origin on return.
     - parameter tintColor: The tint color to be applied to template mode images. This will be applied to the image only; the frame will use the control tintColor.
     - parameter isDimmed: If true (default is false), then the icon will be displayed as "dimmed."
     
     - returns a new CALayer, with the display-ready icon.
     */
    private func _makeIconLayer(_ inIcon: UIImage, inFrame: CGRect, tintColor inTintColor: UIColor, isDimmed inIsDimmed: Bool = false) -> CALayer {
        let returnLayer = CALayer()
        returnLayer.frame = inFrame
        returnLayer.backgroundColor = UIColor.clear.cgColor
        returnLayer.opacity = (inIsDimmed ? Self._kDimmedOpacity : 1.0) * Float(alpha)

        // If we'll be framing the icons, we need to shrink them a bit.
        let insetMultiplier: CGFloat = framedIcons ? Self._kFrameInsetMultiplier : 0.0
        
        let tweakedFrame = inFrame.insetBy(dx: inFrame.size.width * insetMultiplier, dy: inFrame.size.height * insetMultiplier)
        
        let iconDisplayLayer = CALayer()
        
        // What we do here, is resize the image, keeping its aspect, but making sure that it fills the display area.
        let iconAspect = inIcon.size.height / inIcon.size.width
        let maxWidth = 1.0 >= iconAspect ? tweakedFrame.size.width : tweakedFrame.size.height / iconAspect
        let maxHeight = 1.0 >= iconAspect ? tweakedFrame.size.width * iconAspect : tweakedFrame.size.height
        let top = tweakedFrame.origin.y + (tweakedFrame.size.height - maxHeight) / 2
        let left = tweakedFrame.origin.x + (tweakedFrame.size.width - maxWidth) / 2
        iconDisplayLayer.frame = CGRect(origin: CGPoint(x: left, y: top), size: CGSize(width: maxWidth, height: maxHeight))
        
        iconDisplayLayer.backgroundColor = UIColor.clear.cgColor
        iconDisplayLayer.mask?.contentsGravity = .resizeAspect
        if .alwaysTemplate == inIcon.renderingMode {    // If we are forced template, then we use the image as a "see through" mask.
            iconDisplayLayer.mask = CALayer()
            iconDisplayLayer.mask?.frame = iconDisplayLayer.bounds
            iconDisplayLayer.mask?.contents = inIcon.cgImage
            iconDisplayLayer.backgroundColor = inTintColor.cgColor
        } else {
            iconDisplayLayer.contents = inIcon.withTintColor(inTintColor).cgImage
        }

        // If we are displaying framed icons, then we need to surround the icon with a circle, and shrink it.
        if framedIcons {
            let frameLayer = CAShapeLayer() // This is the circle "frame."
            frameLayer.path = UIBezierPath(arcCenter: CGPoint(x: inFrame.midX, y: inFrame.midY), radius: inFrame.size.height / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
            frameLayer.strokeColor = tintColor.cgColor
            frameLayer.fillColor = _closedBackgroundColor?.withAlphaComponent(alpha).cgColor
            frameLayer.lineWidth = Self._kBorderWidthInDisplayUnits
            returnLayer.addSublayer(frameLayer)
        }
        
        returnLayer.addSublayer(iconDisplayLayer)

        return returnLayer
    }
    
    /* ################################################################## */
    /**
     This draws the control in an "open" state. It does not include the center.
     
     This only draws the spinner variant.
     
     - parameter inRect: The drawing rectangle
     */
    private func _drawOpenControl(_ inRect: CGRect) {
        guard isOpen else { return }
        
        if nil != _openSpinnerView {
            if nil == _spinnerTransparencyMask {
                _spinnerTransparencyMask = CAGradientLayer()
                _spinnerTransparencyMask?.frame = _openSpinnerView.bounds
                _spinnerTransparencyMask?.type = .conic
                _spinnerTransparencyMask?.startPoint = CGPoint(x: 0.5, y: 0.5)
                _spinnerTransparencyMask?.endPoint = CGPoint(x: 0.5, y: 0)
                _spinnerTransparencyMask?.colors = Self._kTransparencyGradientSteps

                _openSpinnerView.layer.mask = _spinnerTransparencyMask
            }
            
            if nil == _animatedIconLayer {
                let iconLayer = CALayer()
                iconLayer.frame = _openSpinnerView.bounds

                for index in 0..<count {
                    if let subLayer = _drawOneValueRadius(index) {
                        iconLayer.insertSublayer(subLayer, at: 0)
                    }
                }
                
                _animatedIconLayer = iconLayer
                _openSpinnerView.layer.addSublayer(_animatedIconLayer)
            }
            
            // We use a...gag...retch...semaphore to flag that we just opened a new bar, and are looking for a bouncer.
            if _stupidAnimationFlag {
                _openSpinnerView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                // We animate the opening of the spinner, making it "bounce."
                UIView.animate(withDuration: Self._kOpeningAnimationDurationInSeconds,
                               delay: 0,
                               usingSpringWithDamping: Self._kOpenDamping2,
                               initialSpringVelocity: Self._kOpenInitialVelocity2,
                               options: .allowUserInteraction,
                               animations: { [weak self] in
                                self?._openSpinnerView.transform = .identity
                    },
                               completion: { [weak self] (_: Bool) -> Void in
                                DispatchQueue.main.async {
                                    self?._stupidAnimationFlag = false
                                    self?.setNeedsDisplay()
                                }
                    }
                )
            }
            
            // This is how much we should be rotated.
            let rotationAngleInRadians = (CGFloat.pi - (CGFloat(selectedIndex) * _arclengthInRadians))

            // We animate the rotation, so we get the spinning effect.
            let transform = CATransform3DRotate(CATransform3DIdentity, rotationAngleInRadians, 0.0, 0.0, -1.0)
            if nil == _spinnerAnimation {
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.2)
                CATransaction.setCompletionBlock {
                    DispatchQueue.main.async { [weak self] in
                        self?._spinnerAnimation = nil
                        self?._animatedIconLayer?.transform = transform
                    }
               }
                
                _animatedIconLayer?.transform = transform
                
                CATransaction.commit()
           }
        } else {
            _clearDisplayCaches()  // Make sure we don't leave any dingleberries...
        }
    }
    
    /* ################################################################## */
    /**
     This will either increment by one, decrement by one, or close the control, depending on which part of the open control is referenced by the point.
     
     - parameter inPointInLocalCoordinates: This is a point, in the coordinate system of the given view, to test.
     - parameter forView: The view in which we will test.
     */
    private func _handleOpenTouchEvent(_ inPointInLocalCoordinates: CGPoint, forView inView: UIView) {
        guard isOpen, nil != _openSpinnerView else { return }
        
        if nil != _decelerationDisplayLink {   // If we are spinning, a tap in the control will stop the spin.
            _decelerationDisplayLink?.invalidate()
            _decelerationDisplayLink = nil
            setNeedsDisplay()
        } else {
            // We will hit test in the center (selects the current value and closes the control), the right side (decrements the value), or the left side (increments the value).
            let center = CGRect(origin: CGPoint(x: inView.bounds.midX - (bounds.size.width / 2), y: inView.bounds.midY - (bounds.size.height / 2)), size: CGSize(width: bounds.size.width, height: bounds.size.height))
            let leftSide = CGRect(origin: CGPoint(x: inView.bounds.origin.x, y: inView.bounds.origin.y), size: CGSize(width: inView.bounds.size.width / 2, height: inView.bounds.size.height))
        
            if center.contains(inPointInLocalCoordinates) { // Simply close the control.
                isOpen = false
            } else {    // Increment or decrement by 1.
                var newValue = selectedIndex

                if leftSide.contains(inPointInLocalCoordinates) {
                    newValue -= 1
                    if 0 > newValue {
                        newValue = count - 1
                    }
                } else {
                    newValue += 1
                    if count == newValue {
                        newValue = 0
                    }
                }
                
                selectedIndex = newValue
                
                setNeedsDisplay()
            }
        }
    }
    
    /* ################################################################## */
    /**
     Handle the control opening.
     */
    private func _openControl() {
        guard !isEmpty else { return }

        _stupidAnimationFlag = true // Make sure the opening is animated.
        _stupidAnimationFlagCenter = self.replaceCenterImage    // Maybe we also need to animate a center image replacement.

        if isHapticsOn {
            _selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            _selectionFeedbackGenerator?.prepare()
            _impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            _impactFeedbackGenerator?.prepare()
        }
        
        // We play our sounds in the main queue.
        DispatchQueue.main.async {
            self._playOpenSound()
        }

        if opensAsSpinner { // Only if we are opening the radial spinner.
            // We will add our big ol' getsure recognizer view.
            _openSpinnerView = UIView(frame: _openSpinnerFrame)
            _openSpinnerView.backgroundColor = UIColor.clear

            // We will add our view to the superview of the control, just under the center.
            if let holderView = superview {
                holderView.insertSubview(_openSpinnerView, belowSubview: self)
            }
            
            // Add our tap gesture recognizer. Make sure to scrub any existing one, first (fast open/close can do that).
            if nil != _tapGestureRecognizer {
                _tapGestureRecognizer?.removeTarget(self, action: #selector(Self._handleOpenTapGesture(_:)))
                _openSpinnerView.removeGestureRecognizer(_tapGestureRecognizer)
            }
            _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Self._handleOpenTapGesture(_:)))
            _openSpinnerView.addGestureRecognizer(_tapGestureRecognizer)
            
            // Add our long press gesture recognizer.
            if nil != _longPressGestureRecognizer {
                _longPressGestureRecognizer?.removeTarget(self, action: #selector(Self._handleOpenLongPressGesture(_:)))
                _openSpinnerView.removeGestureRecognizer(_longPressGestureRecognizer)
            }
            _longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(Self._handleOpenLongPressGesture(_:)))
            _longPressGestureRecognizer.require(toFail: _tapGestureRecognizer)
            _openSpinnerView.addGestureRecognizer(_longPressGestureRecognizer)
            
            // Add our rotation pan tracker gesture recognizer.
            if nil != _rotateGestureRecognizer {
                _rotateGestureRecognizer?.removeTarget(self, action: #selector(Self._handleOpenPanGesture(_:)))
                _openSpinnerView.removeGestureRecognizer(_rotateGestureRecognizer)
            }
            _rotateGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(Self._handleOpenPanGesture(_:)))
            _rotateGestureRecognizer.require(toFail: _tapGestureRecognizer)
            _rotateGestureRecognizer.require(toFail: _longPressGestureRecognizer)
            _openSpinnerView.addGestureRecognizer(_rotateGestureRecognizer)
            _rotateGestureRecognizer.delaysTouchesBegan = false
        } else {    // Otherwise, we are using the picker.
            _openPickerContainerView = UIView(frame: _openPickerFrame)
            if let pickerContainer = _openPickerContainerView {    // Just to be sure, but what the heck...
                pickerContainer.backgroundColor = UIColor.clear
                _openPickerView = UIPickerView(frame: pickerContainer.bounds)
                _openPickerView.dataSource = self
                _openPickerView.delegate = self
                pickerContainer.addSubview(_openPickerView!)
            }
            
            if let holderView = superview {
                holderView.insertSubview(_openPickerContainerView!, belowSubview: self)
            }
            
            _openPickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            _openPickerContainerView?.transform =  CGAffineTransform(scaleX: Self._kBounceScale, y: Self._kBounceScale).concatenating(CGAffineTransform(translationX: 0, y: _openPickerContainerView.bounds.size.height / 2))
            
            // We animate the opening of the picker.
            UIView.animate(withDuration: Self._kOpeningAnimationDurationInSeconds,
                           delay: 0,
                           usingSpringWithDamping: Self._kCloseDamping,
                           initialSpringVelocity: 25.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            if let container = self?._openPickerContainerView {
                                container.transform = .identity
                            }
                },
                           completion: { [weak self] _ in self?._stupidAnimationFlag = false}
            )
        }
    }
    
    /* ################################################################## */
    /**
     This ensures that we don't get bigger than our container.
     */
    private func _correctRadius() {
        DispatchQueue.main.async {
            let oldRadius = self._radiusOfOpenControlInDisplayUnits

            // We make sure that our frames are correct, if we rotated.
            if let openView = self._openSpinnerView {
                if openView.frame != self._openSpinnerFrame {
                    openView.frame = self._openSpinnerFrame
                    self._clearDisplayCaches()
                }
            } else if let openView = self._openPickerContainerView {
                openView.frame = self._openPickerFrame
            }

            let myCenter = CGPoint(x: self.frame.midX, y: self.frame.midY)
            if self.opensAsSpinner {    // If we are a spinner, we need to look all around.
                if let mySuperView = self.superview {
                    let minReachX = Float(Swift.min(myCenter.x, mySuperView.bounds.size.width - myCenter.x))
                    let minReachY = Float(Swift.min(myCenter.y, mySuperView.bounds.size.height - myCenter.y))
                    self._radiusOfOpenControlInDisplayUnits = Double(Swift.min(minReachX, minReachY))
                }
            } else {
                self._radiusOfOpenControlInDisplayUnits = Double(myCenter.y)    // PickerView is easy. That's just above us.
            }
            
            if self._radiusOfOpenControlInDisplayUnits != oldRadius {   // Only if we changed.
                self.setNeedsDisplay()
            }
            self._openPickerContainerView?.frame = self._openPickerFrame
            self._openPickerView?.frame = self._openPickerContainerView?.bounds ?? CGRect.zero
            self._openPickerView?.reloadAllComponents()
        }
    }

    /* ################################################################## */
    /**
     Handle the control closing.
     */
    private func _closeControl() {
        _decelerationDisplayLink?.invalidate() // Stop any spinning.
        _decelerationDisplayLink = nil

        DispatchQueue.main.async {
            self._playCloseSound()
            self._selectionFeedbackGenerator = nil   // No more need of the haptic generators.
            self._impactFeedbackGenerator = nil

            if nil != self._openSpinnerView {
                if nil != self._rotateGestureRecognizer {
                    self._rotateGestureRecognizer.removeTarget(self, action: #selector(Self._handleOpenPanGesture(_:)))
                    self._openSpinnerView.removeGestureRecognizer(self._rotateGestureRecognizer)
                    self._rotateGestureRecognizer = nil
                }
                
                if nil != self._tapGestureRecognizer {
                    self._tapGestureRecognizer.removeTarget(self, action: #selector(Self._handleOpenTapGesture(_:)))
                    self._openSpinnerView.removeGestureRecognizer(self._tapGestureRecognizer)
                    self._tapGestureRecognizer = nil
                }
                
                self._openSpinnerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                
                // We animate the closing of the spinner.
                UIView.animate( withDuration: Self._kOpeningAnimationDurationInSeconds,
                                delay: 0,
                                usingSpringWithDamping: Self._kOpenDamping,
                                initialSpringVelocity: Self._kOpenInitialVelocity,
                                options: .allowUserInteraction,
                                animations: { [weak self] in
                                    self?._openSpinnerView.transform = CGAffineTransform(scaleX: Self._kBounceScale, y: Self._kBounceScale)
                                },
                               completion: { [weak self] (_: Bool) -> Void in
                                self?._stupidAnimationFlag = false
                                DispatchQueue.main.async {
                                    self?._clearDisplayCaches()
                                    self?._openSpinnerView.removeFromSuperview()
                                    self?._openSpinnerView = nil
                                    self?._stupidAnimationFlagCenter = (self?.replaceCenterImage ?? false)
                                    self?.setNeedsLayout()
                                }
                    }
                )
            } else if let container = self._openPickerContainerView {
                self._openPickerContainerView = nil
                container.transform = .identity

                // We animate the closing of the picker.
                UIView.animate(withDuration: Self._kClosingAnimationDurationInSeconds,
                               delay: 0,
                               usingSpringWithDamping: Self._kOpenDamping,
                               initialSpringVelocity: Self._kOpenInitialVelocity,
                               options: .allowUserInteraction,
                               animations: { [weak self] in
                                self?.transform = .identity
                                let height = container.bounds.size.height
                                container.transform =  CGAffineTransform(scaleX: Self._kBounceScale, y: Self._kBounceScale).concatenating(CGAffineTransform(translationX: 0, y: height / 2))
                               },
                               completion: { [weak self] (_: Bool) in
                                self?.transform = .identity
                                self?._stupidAnimationFlag = false
                                self?._stupidAnimationFlagCenter = (self?.replaceCenterImage ?? false)
                                container.removeFromSuperview()
                                self?.setNeedsLayout()
                                self?._clearDisplayCaches()
                    }
                )
            }
        }
    }
    
    /* ################################################################## */
    /**
     We call this to clear the display caches, and tell the control to redraw.
     */
    private func _clearDisplayCaches() {
        _animatedIconLayer?.removeFromSuperlayer()
        _animatedIconLayer = nil
        _centerImageView?.removeFromSuperview()
        _centerImageView = nil
        _openSpinnerView?.layer.mask = nil
        _spinnerTransparencyMask = nil
        setNeedsDisplay()
    }
    
    /* ################################################################## */
    /**
     This method reacts to the tap gesture recognizer (for the open control).
     
     - parameter inGesture: The tap gesture recognizer.
     */
    @objc private func _handleOpenTapGesture(_ inGesture: UITapGestureRecognizer) {
        guard isOpen, nil != _openSpinnerView, let view = inGesture.view else { return }
        
        _doneTracking = true
        _handleOpenTouchEvent(inGesture.location(in: view), forView: view)
    }

    /* ################################################################## */
    /**
     This method reacts to the long press gesture recognizer (for the open control).
     
     - parameter inGesture: The tap gesture recognizer.
     */
    @objc private func _handleOpenLongPressGesture(_ inGesture: UILongPressGestureRecognizer) {
        guard isOpen, nil != _openSpinnerView, let view = inGesture.view else { return }
        
        _doneTracking = true
        _handleOpenTouchEvent(inGesture.location(in: view), forView: view)
    }

    /* ################################################################## */
    /**
     This method reacts to the pan gesture recognizer (for the open control).
     
     - parameter inGesture: The specialized pan gesture recognizer.
     */
    @objc private func _handleOpenPanGesture(_ inGesture: UIPanGestureRecognizer) {
        guard isOpen, nil != _openSpinnerView else { return }

        _doneTracking = true
        if .began == inGesture.state || .changed == inGesture.state || .ended == inGesture.state {  // Make sure we're in the correct state.
            if let view = inGesture.view {  // ...and the correct view.
                let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
                let gestureLocation = inGesture.location(in: view)
                let touchAngle = atan2(gestureLocation.y - center.y, gestureLocation.x - center.x)  // Calculate the angle from the gesture's relationship to the control center.
                var newSelection = 0
                
                if .began == inGesture.state {  // If we are just starting, we prime the haptic engine, and record the starting angle.
                    _initialAngleForPan = touchAngle
                    _initialSelectionForPan = selectedIndex
                    // We also increment or decrement by one to get started. This will not always jive with the ultimate pan direction, but it avoids any hesitation.
                    newSelection = selectedIndex
                    let leftSide = CGRect(origin: CGPoint(x: view.bounds.origin.x, y: view.bounds.origin.y), size: CGSize(width: view.bounds.size.width / 2, height: view.bounds.size.height))
                    if leftSide.contains(gestureLocation) { // Left side increment. Right side decrement.
                        newSelection -= 1
                    } else {
                        newSelection += 1
                    }
                } else {    // If this is not the initial call, then we simply determine a delta from the start.
                    let delta = (_initialAngleForPan - touchAngle)
                    let radiansPerValue = -(2 * CGFloat.pi) / CGFloat(count) // This is how many radians in our 2π circle it takes to account for one value.
                    // What happens here, is that we slow the scrolling down a bit if we have "stuffed" the spinner.
                    let dampenedRadiansPerValue = radiansPerValue * Swift.max(1.0, Swift.min(0.1, CGFloat(spinnerThreshold) / CGFloat(count)))
                    let changedItems = Int(round(delta / dampenedRadiansPerValue))
                    newSelection = _initialSelectionForPan + changedItems
                }
                
                // Yeah, we could do this with math, but this works fine. We simply make sure that we are within bounds.
                while newSelection >= count {
                    newSelection -= count
                }
                
                while newSelection < 0 {
                    newSelection += count
                }
                
                selectedIndex = newSelection

                if .ended == inGesture.state {
                    let rawVelocity = inGesture.velocity(in: inGesture.view)
                    
                    var linearVelocity: CGFloat = 0
                    
                    switch touchAngle {
                    case -(CGFloat.pi / 2)..<0:
                        linearVelocity =  -(rawVelocity.y + rawVelocity.x)

                    case 0..<(CGFloat.pi / 2):
                        linearVelocity = rawVelocity.x - rawVelocity.y

                    case (CGFloat.pi / 2)..<CGFloat.pi:
                        linearVelocity = rawVelocity.x + rawVelocity.y
                        
                    default:
                        linearVelocity =  rawVelocity.y - rawVelocity.x
                    }
                    
                    linearVelocity = -linearVelocity
                    _flywheelVelocity += linearVelocity
                    
                    // See if we will be giving this a spin.
                    let finalVelocity = Swift.min(Self._kMaxFlywheelVelocity, Swift.abs(linearVelocity / Self._kFlywheelVelocityDivisor)) * ((0 > linearVelocity) ? -1 : 1)
                    if Self._kMinFlywheelVelocity < Swift.abs(finalVelocity) {
                        _startYourEngines(finalVelocity)
                    }
                }
                
                setNeedsDisplay()
            }
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an optional delegate object that can be informed of selected values.
     
     This cannot be made inspectable, because the delegate class is not one that can be accessed as ObjC.
     */
    public weak var delegate: RVS_SpinnerDelegate?
    
    /* ################################################################## */
    /**
     This property can be overridden. It returns a UIBezierPath that defines the shape of the center.
     */
    public var centerShape: UIBezierPath {
        // We shrink by one border width, because the shape is stroked halfway through the border.
        let inset = Self._kBorderWidthInDisplayUnits / 2.0
        return UIBezierPath(ovalIn: bounds.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)))
    }
    
    /* ################################################################## */
    /**
     This is the display font that we'll use in the picker. Default is system bold 20. It can be overridden.
     */
    public var displayFont: UIFont! = UIFont.boldSystemFont(ofSize: 20) {
        didSet {
            // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                self.setNeedsLayout()
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is the selected index of the value Array. It is 0-based.
     */
    public var selectedIndex: Int = 0 {
        didSet {
            // Make sure we are in range.
            selectedIndex = Swift.max(0, Swift.min(values.count - 1, selectedIndex))
            // We will want to update our layout and tell the delegate we changed. Do it in the main thread, just in case.
            if selectedIndex != oldValue {
                DispatchQueue.main.async {
                    self._playSelectionTink()
                    // Let any delegate know that we have a new selected item.
                    self.delegate?.spinner(self, hasSelectedTheValue: self.value)
                    self.setNeedsLayout()
                    self.sendActions(for: .valueChanged)
                }
            }
        }
    }

    /* ################################################################## */
     /**
     This property represents the values to be selected and displayed by the spinner. Instead of a datasource, we use an instance property. This can be overloaded to make it dynamic.
     At minimum, each value needs an icon to be displayed.
     Optionally, it can have a title String, a description String, with more information, and abritrary associated data.
     The associated data is an "Any?" item. It can be anything (or nothing). It is up to the implementor to cast and manage this. This is just a "context hook."
     The order is not changed by the spinner. Values are displayed in the order they are set in this Array, clockwise.
     */
    public var values: [RVS_SpinnerDataItem] = [] {
        didSet {
            selectedIndex = Swift.max(0, Swift.min(values.count - 1, selectedIndex))
            _arclengthInRadians = (CGFloat.pi * 2) / CGFloat(values.count)
            if self.isOpen {
                self.isOpen = false // Close our picker/spinner, if open.
            } else {
                self.setNeedsLayout()
                self._clearDisplayCaches()
            }
            self.sendActions(for: .valueChanged)
        }
    }

    /* ################################################################## */
    /**
     If this is true, then the spinner is open. Setting this will open or close the control. Default is false.
     */
    public var isOpen: Bool {
        get { _isOpen }
        set {    // This is the way we open and close the control.
            if !_isOpen && _isOpen != newValue, 1 < count {
                _isOpening = true
                _openControl()
                setNeedsLayout()
                _clearDisplayCaches()
                _isOpening = false
                // Let any delegate know that we have opened with a selected item.
                delegate?.spinner(self, hasOpenedWithTheValue: value)
                _isOpen = true
            } else if _isOpen && _isOpen != newValue,
                  delegate?.spinner(self, willCloseWithTheValue: value) ?? true {
                _isOpening = false  // Just to make sure...
                _closeControl()
                // Let any delegate know that we have closed with a selected item.
                delegate?.spinner(self, hasClosedWithTheValue: value)
                _isOpen = false
            }
        }
    }

    /* ################################################################## */
    /**
     If this is true, then center of the spinner will rotate against any rotation applied to its container, making it "straight up." Default is true.
     */
    public var isCompensatingForContainerRotation: Bool = true {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Calculated Propeties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This calculated property will return either the currently selected item, or nil. READ-ONLY
     */
    public var value: RVS_SpinnerDataItem? { (0..<count).contains(selectedIndex) ? values[selectedIndex] : nil }

    /* ################################################################## */
    /**
     If we have either a border color (tint), or a background color, then we display the icons enclosed in a frame.
     If that is the case, then the icon is displayed slightly smaller. READ-ONLY
     
     - returns: True, if the images should be framed.
     */
    public var framedIcons: Bool { !hudMode && (!(_closedBackgroundColor?.isClear ?? true) || !(tintColor?.isClear ?? true)) }
    
    /* ################################################################## */
    /**
     - returns: True, if the control will open as a spinner (as opposed to a picker). READ-ONLY
     */
    public var opensAsSpinner: Bool { SpinnerMode.spinnerOnly.rawValue == spinnerMode || ((SpinnerMode.both.rawValue == spinnerMode) && spinnerThreshold > count) }
    
    /* ################################################################## */
    /**
     - returns: The number of values. READ-ONLY
     */
    public var count: Int { values.count }
    
    /* ################################################################## */
    /**
     - returns: Yes, we have no bananas. READ-ONLY
     */
    public var isEmpty: Bool { values.isEmpty }

    /* ################################################################################################################################## */
    // MARK: - Public Enums
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is just a convenient way to denote the spinner modes.
     */
    public enum SpinnerMode: Int {
        /** This means that the radial spinner will be used at all times. */
        case spinnerOnly = -1
        /** This means that the Spinner will choose which to bring up, depending upon the value of the spinnerThreshold property, and the number of values in the Array. */
        case both = 0
        /** This means that the picker will be used at all times. */
        case pickerOnly = 1
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Overridden IB Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the background color associated with the "closed" control. We use the UIView's backgroundColor as the source.
     
     This is set from the view background color.
     */
    public override var backgroundColor: UIColor? {
        didSet {
            _closedBackgroundColor = backgroundColor
        }
    }
    
    /* ################################################################## */
    /**
     This is the tint color , which governs the display of the border, and of text in the picker.
     
     This is set from the view background color.
     */
    public override var tintColor: UIColor! {
        didSet {
            // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                self._openPickerView?.reloadAllComponents()
                self._clearDisplayCaches()
            }
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public IB Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the background color associated with the "open" control "pie-slices." Default is nil (clear).
     */
    @IBInspectable public var openBackgroundColor: UIColor! {
        didSet {
            // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                self._openPickerView?.reloadAllComponents()
                self._clearDisplayCaches()
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is the spinner mode. It determines which control is displayed when the spinner is open.
     
     - both (default) is 0 The spinnerThreshold is used to determine which will be displayed.
     - radial spinner only is -1
     - picker only is 1
     */
    @IBInspectable public var spinnerMode: Int = SpinnerMode.both.rawValue {
        didSet {
            DispatchQueue.main.async {
                if self.isOpen {    // We close any open spinner.
                    self.isOpen = false
                } else {
                    self.setNeedsLayout()
                    self._clearDisplayCaches()
                 }
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is the maximum number of elements that can be displayed in a spinner.
     Above this, needs to be displayed in a picker. Default is 15.
     */
    @IBInspectable public var spinnerThreshold: Int = 15 {
        didSet {
            DispatchQueue.main.async {
                if self.isOpen {    // We close any open spinner.
                    self.isOpen = false
                } else {
                    self.setNeedsLayout()
                    self._clearDisplayCaches()
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     If true, the control will play sounds. Default is true.
     */
    @IBInspectable public var isSoundOn: Bool = true
    
    /* ################################################################## */
    /**
     If true, the control will play haptics (on devices that support haptics). Default is true.
     */
    @IBInspectable public var isHapticsOn: Bool = true
    
    /* ################################################################## */
    /**
     This is an alternative fixed center image. If left alone, the selected value image will be used. Default is nil (use selected value image).
     */
    @IBInspectable public var centerImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self._clearDisplayCaches()
            }
        }
    }
    
    /* ################################################################## */
    /**
     If true, then the various options will be set to emulate a "HUD" display. Default is false.
     */
    @IBInspectable public var hudMode: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self._clearDisplayCaches()
            }
        }
    }
    
    /* ################################################################## */
    /**
     If true, and an explicit image has been assigned to the center, when the cotrol is opened, the image will be replaced with the current selection.
     This is ignored, if `centerImage` is nil. Default is false.
     */
    @IBInspectable public var replaceCenterImage: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self._clearDisplayCaches()
            }
        }
    }

    /* ################################################################################################################################## */
    // MARK: - Required Init
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The NSCoder init.
     
     - parameter coder: The decoder with the view state.
     */
    required public init?(coder inDecoder: NSCoder) {
        super.init(coder: inDecoder)
    }

    /* ################################################################################################################################## */
    // MARK: - Public Overrides
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is called when the control is about to be drawn.
     
     - parameter inRect: The rect to be drawn into.
     */
    override public func draw(_ inRect: CGRect) {
        // See if we need to switch out the background color.
        if nil == _closedBackgroundColor {
            _closedBackgroundColor = backgroundColor
        }
        
        super.backgroundColor = UIColor.clear   // The main background is always clear.

        super.draw(inRect)  // Won't do much, but lets the superclass do any housekeeping. It's only polite.
        
        // Draw the control; either open or closed.
        if 0 < values.count && isOpen {
            _drawOpenControl(inRect)
        }
     
        _drawControlCenter(inRect)
    }

    /* ################################################################## */
    /**
     This is required for a designable.
     
     - parameter frame: The new frame for the view.
     */
    override public init(frame inRect: CGRect) {
        super.init(frame: inRect)
    }

    /* ################################################################## */
    /**
     This is called when we start tracking a pan.
     
     - parameter inTouch: The touch object associated with this event.
     - parameter with: The event that triggered this.
     */
    override public func beginTracking(_ inTouch: UITouch, with inEvent: UIEvent?) -> Bool {
        _doneTracking = false
        DispatchQueue.main.async {
            self._clearDisplayCaches()
        }
        
        return super.beginTracking(inTouch, with: inEvent)
    }
    
    /* ################################################################## */
    /**
     This is called repeatedly while we are tracking a pan. We just make sure that we keep updating the display.
     
     - parameter inTouch: The touch object associated with this event.
     - parameter with: The event that triggered this.
     */
    override public func continueTracking(_ inTouch: UITouch, with inEvent: UIEvent?) -> Bool {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
        return super.continueTracking(inTouch, with: inEvent)
    }
    
    /* ################################################################## */
    /**
     We end the tracking, and make sure that we update the display properly.
     
     - parameter inTouch: The touch object associated with this event.
     - parameter with: The event that triggered this.
     */
    override public func endTracking(_ inTouch: UITouch?, with inEvent: UIEvent?) {
        _doneTracking = true

        if isTouchInside {
            if nil != _decelerationDisplayLink {   // If we are spinning, a tap in the control will stop the spin.
                _decelerationDisplayLink?.invalidate()
                _decelerationDisplayLink = nil
                DispatchQueue.main.async {
                    self.setNeedsDisplay()
                }
            } else {
                DispatchQueue.main.async {
                    if 1 < self.count {
                        self.isOpen = !self.isOpen
                        self.sendActions(for: .touchUpInside)
                    } else if 1 == self.count { // If we are a single value, there's a special case, where we don't open, but send a message.
                        self.sendActions(for: .touchUpInside)
                        self.delegate?.spinner(self, singleValueSelected: self.values[0])
                        self._clearDisplayCaches()
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.setNeedsDisplay()
            }
        }

        super.endTracking(inTouch, with: inEvent)
    }
    
    /* ################################################################## */
    /**
     We cancel the tracking, and make sure that we update the display.
     
     - parameter with: The event that triggered this.
     */
    override public func cancelTracking(with inEvent: UIEvent?) {
        DispatchQueue.main.async {
            self._doneTracking = true
            self._clearDisplayCaches()
        }
        super.cancelTracking(with: inEvent)
    }

    /* ################################################################## */
    /**
     This is called before the subviews (aren't any) will get laid out.
     We use it to switch out the background color.
     We use the set background color as the "closed" control background color.
     We use the tint color as the border color.
     */
    override public func layoutSubviews() {
        if nil == openBackgroundColor {
            openBackgroundColor = .clear    // We are at least clear.
        }
        
        contentMode = .redraw
        
        super.layoutSubviews()
        _correctRadius()    // Make sure we stay in our lane.
        
        // This ensures that the layout is recalculated, when the orientation changes.
        if !_registeredOrientationObserver {
            _registeredOrientationObserver = true
            NotificationCenter.default.addObserver(self, selector: #selector(setNeedsLayout), name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     A convenience init with a preset values array and value.
     
     - parameter values: The values to be associated with the control. It is optional, and default is nil.
     - parameter selectedIndex: An initial selected index for the control. It is 0-based, and optional. Default is 0.
     - parameter frame: Any initial frame for the control. It is optional, and default is an empty frame.
     - parameter spinnerMode: An integer, eith -1 (Spinner only), 0 (Both), or 1 (Picker only). It is optional, and default is 0 (Both).
     - parameter delegate: A delegate instance for the spinner. It is optional, and default is nil.
     */
    public convenience init(values inValuesArray: [RVS_SpinnerDataItem]? = nil, selectedIndex inSelectedIndex: Int = 0, frame inFrame: CGRect = CGRect.zero, spinnerMode inSpinnerMode: SpinnerMode = .both, delegate inDelegate: RVS_SpinnerDelegate? = nil) {
        self.init(frame: inFrame)
        delegate = inDelegate
        spinnerMode = inSpinnerMode.rawValue
        if let valuesArray = inValuesArray, !valuesArray.isEmpty {
            values = valuesArray
            selectedIndex = inSelectedIndex
        }
    }
    
    /* ################################################################## */
    /**
     A convenience "quiet" init.
     */
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    /* ################################################################## */
    /**
     We cancel any decelerator display link from here, and remove our listener.
     */
    deinit {
        NotificationCenter.default.removeObserver(self)
        _decelerationDisplayLink?.invalidate()
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public UIPickerViewDataSource/Delegate Protocol Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Simple number of components response (always 1)
     
     - parameter in: The UIPickerView doing the querying.
     
     - returns 1 (always).
     */
    public func numberOfComponents(in inPickerView: UIPickerView) -> Int {
        return 1
    }
    
    /* ################################################################## */
    /**
     This returns how many rows will be displayed by the pickerview.
     
     - parameter inPickerView: The pickerview doing the querying.
     - parameter numberOfRowsInComponent: The 0-based index (always 0, and ignored) of the component we are asking after.
     
     - returns the number of rows (the number of values in our Array).
     */
    public func pickerView(_ inPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return count
    }
    
    /* ################################################################## */
    /**
     - parameter inPickerView: The pickerview doing the querying.
     - parameter rowHeightForComponent: The 0-based index (always 0, and ignored) of the component we are asking after.
     
     - returns: float, with the row height for that component.
     */
    public func pickerView(_ inPickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Swift.min(Self._kMaxOpenPickerViewImageSizeInDisplayUnits, inPickerView.bounds.height)
    }
    
    /* ################################################################## */
    /**
     This builds one row view, including the icon and the text.
     It will center them over the center of the Spinner.
     
     - parameter inPickerView: The pickerview doing the querying.
     - parameter viewForRow: the 0-based index of the row (used to index our values).
     - parameter forComponent: The 0-based index (always 0, and ignored) of the component we are asking after.
     - parameter reusing: The view object to reuse.
     
     - returns: a new (or refurbed) view object.
     */
    public func pickerView(_ inPickerView: UIPickerView, viewForRow inRow: Int, forComponent inComponent: Int, reusing inView: UIView?) -> UIView {
        if nil != inView { // Since the values don't change in this. It's safe to do this.
            return inView!
        }
        
        let rowFrame = CGRect(origin: .zero, size: CGSize(width: inPickerView.bounds.size.width, height: inPickerView.rowSize(forComponent: 0).height))
        
        let imageSize = rowFrame.size.height - (Self._kOpenPaddingInDisplayUnits * 2)
        // We create a frame for the image and the label, giving them a bit of "breathing room."
        let imageFrame = CGRect(origin: .zero, size: CGSize(width: imageSize, height: imageSize))
        let labelFrame = CGRect(origin: CGPoint(x: imageSize + Self._kOpenPaddingInDisplayUnits, y: 0), size: CGSize(width: rowFrame.size.width - (Self._kOpenPaddingInDisplayUnits + imageSize), height: imageSize))

        let ret: UIView = UIView(frame: rowFrame)
        ret.backgroundColor = hudMode ? .clear : openBackgroundColor
        
        let imageView = UIView(frame: imageFrame)
        imageView.backgroundColor = UIColor.clear
        let displayLayer = _makeIconLayer(values[inRow].icon, inFrame: imageFrame, tintColor: tintColor, isDimmed: !values[inRow].isEnabled)
        imageView.layer.addSublayer(displayLayer)

        let containerView = UIView()
        
        var enclosingRect: CGRect = .zero
        if !values[inRow].title.isEmpty {   // If we have title text, then that goes in the label. If we don't have any, we won't even create a label.
            let label = UILabel(frame: labelFrame)
            label.textColor = tintColor?.isClear ?? true ? UIColor.black : tintColor    // This prevents us from drawing transparent text.
            label.backgroundColor = UIColor.clear
            label.font = displayFont
            label.text = values[inRow].title
            containerView.addSubview(label)
            // This is how we center the combination of the icon and the text. This calculates the size necessary for the text.
            enclosingRect = label.text?.boundingRect(with: labelFrame.size, context: nil) ?? .zero
            enclosingRect.size.width += Self._kOpenPaddingInDisplayUnits
        }
        
        let containerRect = CGRect(x: ret.bounds.midX - enclosingRect.midX, y: Self._kOpenPaddingInDisplayUnits, width: (enclosingRect.size.width + imageSize), height: imageSize)
        
        containerView.frame = containerRect
        containerView.addSubview(imageView)
        ret.addSubview(containerView)
        
        return ret
    }
    
    /* ################################################################## */
    /**
     This is called when a row is selected in the picker.
     
     - parameter inPickerView: The pickerview doing the querying.
     - parameter didSelectRow: the 0-based index of the row (used to index our values).
     - parameter inComponent: The 0-based index (always 0, and ignored) of the component we are asking after.
     */
    public func pickerView(_ inPickerView: UIPickerView, didSelectRow inRow: Int, inComponent: Int) {
        selectedIndex = inRow
        setNeedsDisplay()
    }
}
#endif
