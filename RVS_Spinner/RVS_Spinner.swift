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
import AudioToolbox

/* ###################################################################################################################################### */
// MARK: - Color Test Extension -
/* ###################################################################################################################################### */
/**
 This allows us to see if a color is clear.
 */
extension UIColor {
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

/* ###################################################################################################################################### */
// MARK: - Delegate Protocol -
/* ###################################################################################################################################### */
/**
 This is the delegate protocol for the Spinner. It is a Swift class protocol, because it provides the delegate with a Swift object, and is weakly referenced by the Spinner.
 
 Its methods are all "optional" (they have default implementations that do nothing), but the control works best if you use them.
 */
public protocol RVS_SpinnerDelegate: class {
    /* ################################################################## */
    /**
     This is called if there was only one value, and the user selected the central button.
     In this case, the control will not open, but we will send a message.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter singleValueSelected: The value that was just selected. This is optional.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_Spinner.RVS_SpinnerDataItem?)
    
    /* ################################################################## */
    /**
     This is called after the user has used the Spinner to select a value.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasSelectedTheValue: The value that was just selected. This is optional.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_Spinner.RVS_SpinnerDataItem?)
    
    /* ################################################################## */
    /**
     This is called after the user has "opened" the Spinner.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasOpenedWithTheValue: The value that was selected when the control opened. This is optional.
     */
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_Spinner.RVS_SpinnerDataItem?)
    
    /* ################################################################## */
    /**
     This is called after the user has "closed" the Spinner.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter hasClosedWithTheValue: The value that was selected when the control closed. This is optional.
     */
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_Spinner.RVS_SpinnerDataItem?)
}

/* ###################################################################################################################################### */
/**
 These empty methods allow the protocol methods to be "optional."
 */
public extension RVS_SpinnerDelegate {
    /* ################################################################## */
    /**
     This is an optional method.
     
     This is called if there was only one value, and the user selected the central button.
     In this case, the control will not open, but we will send a message.
     
     - parameter spinner: The RVS_Spinner instance.
     - parameter singleValueSelected: The value that was just selected. This is optional.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_Spinner.RVS_SpinnerDataItem?) {
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
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_Spinner.RVS_SpinnerDataItem?) {
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
    func spinner(_: RVS_Spinner, hasOpenedWithTheValue: RVS_Spinner.RVS_SpinnerDataItem?) {
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
    func spinner(_: RVS_Spinner, hasClosedWithTheValue: RVS_Spinner.RVS_SpinnerDataItem?) {
        #if DEBUG
            print("spinner(:, hasClosedWithTheValue:) called in default.")
        #endif
    }
}

/* ###################################################################################################################################### */
// MARK: - Main Class -
/* ###################################################################################################################################### */
/**
 This is a "spinner" control, which acts a bit like a circular UIPickerView.
 
 However, instead of having the values provided by a delegate/datasource, the values are associated directly with the control in an Array.
 
 This class has a number of Array-like methods, properties and subscripts, so it can be treated much like an Array (and iterated).
 Making changes to the Array will result in a setNeedsLayout(), which is done in the main thread, allowing you to call the methods in non-main threads.
 They will also send valueChanged events.
 Values and Arrays of values are captured by RVS_Spinner instances, so the modifications will only apply to values and arrays for individual instances.
 
 This control has a lot of "little things" to make it usable and intuitive. It has "inertia," where you can start it spinning, it has "one-tap increment/decrement,"
 and it has haptic and audio feedback.
 
 It can switch between the circular spinner, and a standard UIPickerView, if there are too many items to handle efficiently in a spinner. You can choose to either
 always use the picker, or never use the picker.
 */
@IBDesignable
public class RVS_Spinner: UIControl, UIPickerViewDelegate, UIPickerViewDataSource, Sequence {
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
     This is the width of the lines in the control.
     */
    private static let _kBorderWidth: CGFloat = 1.0
    
    /* ################################################################## */
    /**
     This is the height of the label in the open spinner.
     */
    private static let _kDisplayLabelHeight: CGFloat = 30.0
    
    /* ################################################################## */
    /**
     This is the padding in the open control "pie slices.".
     */
    private static let _kOpenPaddingInDisplayUnits: CGFloat = 8.0
    
    /* ################################################################## */
    /**
     This is the largest square image we allow in the pickerview.
     */
    private static let _kMaxOpenImageSizeInDisplayUnits: CGFloat = 40.0
    
    /* ################################################################## */
    /**
     This is the maximum velocity for the "flywheel."
     */
    private static let _kMaxFlywheelVelocity: CGFloat = 4
    
    /* ################################################################## */
    /**
     This is the minimum velocity for the "flywheel." Below this, "clicks" in a value.
     */
    private static let _kMinFlywheelVelocity: CGFloat = 0.94
    
    /* ################################################################## */
    /**
     This is the deceleration constant for the "flywheel."
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

    /* ################################################################################################################################## */
    // MARK: - Private Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the background color associated with the "closed" control.
     
     This is set from the view background color.
     */
    private var _closedBackgroundColor: UIColor? {
        didSet {
            // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                self._layerCache = [CAShapeLayer?](repeating: nil, count: self.values.count)    // Clear the cache.
                self.setNeedsDisplay()
            }
        }
    }
    
    /* ################################################################## */
    /**
     This is the radius of the open control "pie slices.".
     */
    private var _radiusOfOpenControlInDisplayUnits: Float = 0.0

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
     This accumulates "bumps" to "nudge the value as we decelerate.
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
     This caches all the "spokes."
     */
    private var _layerCache: [CAShapeLayer?] = []
    
    /* ################################################################## */
    /**
     This is an invisible view that we instantiate over the control to catch gestures.
     It is only available when the control is open.
     */
    private var _openSpinnerView: UIView!

    /* ################################################################## */
    /**
     This is the gesture recognizer we will use to determine if the control is being fiddled with.
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
     This is a UIView that will hold the picker.
     */
    private var _openPickerContainerView: UIView!
    
    /* ################################################################## */
    /**
     This is standard UIPickerView, for when we have too much.
     */
    private var _openPickerView: UIPickerView!

    /* ################################################################## */
    /**
     This is the animation layer for the control center.
     */
    private var _centerLayer: CAShapeLayer!
    
    /* ################################################################## */
    /**
     This is a semaphore to indicate that we are done tracking the control.
     */
    private var _doneTracking: Bool = true
    
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
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Calculated Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the frame for the open spinner.
     */
    internal var openSpinnerFrame: CGRect {
        var ret = CGRect.zero
        
        ret.origin.x = frame.midX - CGFloat(_radiusOfOpenControlInDisplayUnits)
        ret.origin.y = frame.midY - CGFloat(_radiusOfOpenControlInDisplayUnits)
        ret.size.width = CGFloat(_radiusOfOpenControlInDisplayUnits) * 2
        ret.size.height = CGFloat(_radiusOfOpenControlInDisplayUnits) * 2

        return ret
    }
    
    /* ################################################################## */
    /**
     This is the frame for the open picker.
     */
    internal var openPickerFrame: CGRect {
        var ret = openSpinnerFrame
        
        ret.size.height /= 2    // Start at the midpoint.
        ret.size.height -= (bounds.size.height / 2)    // And just above the center.
        
        return ret
    }
    
    /* ################################################################################################################################## */
    // MARK: - Internal Instance Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is an additional "bump" that may be added to the bottom of the button (for markers).
     */
    internal var kAdditionalBottomInset: CGFloat = 0

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
        if isSoundOn {
            AudioServicesPlaySystemSound(type(of: self)._kOpenSystemSoundID)
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
        if isOpen {
            if isSoundOn {
                AudioServicesPlaySystemSound(type(of: self)._kSelectSystemSoundID)
            }
            if isHapticsOn {
                _selectionFeedbackGenerator?.selectionChanged()
                _selectionFeedbackGenerator?.prepare()
            }
        }
    }

    /* ################################################################## */
    /**
     This plays a sound for the control closing.
     */
    private func _playCloseSound() {
        if isSoundOn {
            AudioServicesPlaySystemSound(type(of: self)._kCloseSystemSoundID)
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
            _currentFlywheelVelocity = Swift.min(abs(_currentFlywheelVelocity), type(of: self)._kMaxFlywheelVelocity) * (0 > _currentFlywheelVelocity ? -1 : 1)
            if Swift.abs(_currentFlywheelVelocity) >= type(of: self)._kMinFlywheelVelocity {
                _decelerationDisplayLink?.invalidate()
                // The displaylink will keep "poking," until we are done.
                _decelerationDisplayLink = CADisplayLink(target: self, selector: #selector(type(of: self)._decelerationStep))
                _decelerationDisplayLink?.preferredFramesPerSecond = type(of: self)._kFlywheelPreferredFramesPerSecond
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
        let newVelocity = _currentFlywheelVelocity * type(of: self)._kFlywheelVelocityDecelerationMultiplier
        _currentFlywheelVelocity = newVelocity
        let nudge = type(of: self)._kFlywheelVelocityDecelerationNudgeMultiplier * newVelocity
        _decelerationAccumulator += nudge

        // This just gives a slightly smoother round.
        let stepsToRotate = Int(round(_decelerationAccumulator * 10) / 10)

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
        if nil != _centerLayer {
            _centerLayer?.removeFromSuperlayer()
            _centerLayer = nil
        }
        
        // We stroke and fill the basic shape with the colors we have set up.
        _centerLayer = CAShapeLayer()
        // The control is an oval (should be a circle, but we allow an oval).
        _centerLayer.path = centerShape.cgPath
        _centerLayer.fillColor = _closedBackgroundColor?.cgColor
        _centerLayer.strokeColor = tintColor.cgColor
        _centerLayer.lineWidth = type(of: self)._kBorderWidth

        if 0 < values.count {   // Have to have values to draw anything more.
            // Next, see if we have been given an image to be displayed over the oval.
            let centerImage = values[selectedIndex].icon
            let isDimmed = !isEnabled || (isTracking && isTouchInside && !_doneTracking)
            let imageLayer = _createIconDisplay(centerImage, inFrame: bounds, isDimmed: isDimmed)
            _centerLayer.addSublayer(imageLayer)
        }
        
        if let centerLayer = _centerLayer {
            layer.addSublayer(centerLayer)
        }
    }
    
    /* ################################################################## */
    /**
     This draws one of the "flower petals" that surround the center of an open spinner.
     
     - parameter inIndex: The index of the value to be used.
     */
    private func _drawOneValueRadius(_ inIndex: Int) -> CALayer! {
        var ret: CAShapeLayer! = nil
        let arclengthInRadians = (CGFloat.pi * 2) / CGFloat(values.count)

        if !values.isEmpty {
            if _layerCache.isEmpty {   // Make sure that we have an allocated cache array.
                _layerCache = [CAShapeLayer?](repeating: nil, count: values.count)
            }
            
            if let subLayer = _layerCache[inIndex] {  // See if we already have it.
                ret = subLayer
            } else {
                let value = values[inIndex]

                let paddingWidth = type(of: self)._kOpenPaddingInDisplayUnits * 2
                
                let centerPointInDisplayUnits = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
                let radiusInDisplayUnits = CGFloat(_radiusOfOpenControlInDisplayUnits)
                let centerAngleInRadians = (3 * CGFloat.pi) / 2
                let circumferenceInDisplayUnits = CGFloat(Double.pi * 2 * Double(radiusInDisplayUnits))
                let arcCircumferenceInDisplayUnits = circumferenceInDisplayUnits / CGFloat(values.count)

                ret = CAShapeLayer()
                ret.frame = bounds
                // This is the distance between our circumference, and the outside of the center circle, and adding some padding on either end.
                let workingLength = (CGFloat(_radiusOfOpenControlInDisplayUnits) - bounds.size.height) - paddingWidth
                // This is all pretty rough, but it will get us there. We use some basic trig to get a rough idea of how much room we have, if we need to shrink.
                let radiansPerValue = (2 * CGFloat.pi) / CGFloat(count) // This is how many radians in our 2π circle it takes to account for one value.
                let oppositeLength = Swift.min(workingLength, (workingLength * tan(radiansPerValue / 2)) * 2)
                
                let maxIconSize = value.icon.size
                let iconSize = CGSize(width: Swift.min(maxIconSize.width, oppositeLength), height: Swift.min(maxIconSize.height, oppositeLength))
                let path = UIBezierPath()
                path.move(to: centerPointInDisplayUnits)
                path.addArc(withCenter: centerPointInDisplayUnits, radius: radiusInDisplayUnits, startAngle: centerAngleInRadians - (arclengthInRadians / 2), endAngle: centerAngleInRadians + (arclengthInRadians / 2), clockwise: true)
                path.move(to: centerPointInDisplayUnits)
                ret.fillColor = openBackgroundColor.cgColor
                
                // We like to have a fixed size, but if the image is smaller, or we are packed in too tight, we may need to go smaller.
                let maxWidth = Swift.min(iconSize.width, oppositeLength)  // This is how wide the displayed icon will be.
                let imageSquareSize = Swift.min(maxWidth, arcCircumferenceInDisplayUnits / 2)  // The image is displayed in a square.
                
                let imageFrame = CGRect(x: centerPointInDisplayUnits.x - (imageSquareSize / 2), y: -(radiusInDisplayUnits - (bounds.size.height / 2) - type(of: self)._kOpenPaddingInDisplayUnits), width: imageSquareSize, height: imageSquareSize)
                
                let displayLayer = _createIconDisplay(value.icon, inFrame: imageFrame)
                
                let newFrame = displayLayer.frame
                
                displayLayer.frame = CGRect(x: centerPointInDisplayUnits.x - (newFrame.size.width / 2), y: -(radiusInDisplayUnits - (bounds.size.height / 2) - type(of: self)._kOpenPaddingInDisplayUnits), width: newFrame.size.width, height: newFrame.size.height)

                ret.path = path.cgPath
                ret.addSublayer(displayLayer)
                
                // Make sure that we clip the contents (should be unnecessary).
                let clipLayer = CAShapeLayer()
                clipLayer.path = path.cgPath
                ret.mask = clipLayer
                _layerCache[inIndex] = ret
            }

            // This displays the wedge rotated properly.
            let rotationAngleInRadians = (CGFloat(inIndex - selectedIndex) * arclengthInRadians) + CGFloat(selectedItemOffsetInRadians)
            ret.transform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1.0)

            // We use this to reduce the opacity of the values that are not actually on top.
            // This is a ring buffer distance calculation. Works for the circle we're using.
            let maximumIndexPlusOne = count
            var indexDistance = (maximumIndexPlusOne + selectedIndex - inIndex) % maximumIndexPlusOne
            if indexDistance >= (maximumIndexPlusOne / 2) { // If we are beyond the end, we loop back.
                indexDistance -= maximumIndexPlusOne
            }

            switch Swift.abs(indexDistance) {
            case 0:
                ret.opacity = 1.0   // Top item gets all the goodies.
            default:
                ret.opacity = 0.25 / Float(Swift.abs(indexDistance))   // 3 or more away, hidden.
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     This creates a displayable icon; either standalone, or enclosed in a frame.
     
     - parameter inIcon: The image to be displayed as an icon.
     - parameter inFrame: The frame we want the icon displayed in. It will be normalized to zero-origin on return.
     - parameter isDimmed: If true (default is false), then the icon will be displayed as "dimmed."
     
     - returns a new CALayer, with the display-ready icon.
     */
    private func _createIconDisplay(_ inIcon: UIImage, inFrame: CGRect, isDimmed inIsDimmed: Bool = false) -> CALayer {
        let iconDisplayLayer = CALayer()
        iconDisplayLayer.backgroundColor = UIColor.clear.cgColor
        iconDisplayLayer.frame = inFrame
        iconDisplayLayer.frame.origin = CGPoint.zero
        iconDisplayLayer.contents = inIcon.cgImage
        iconDisplayLayer.contentsGravity = .resizeAspect  // We will always display the icon accurately, as large as possible to fill the rectangle. Keep this in mind, when designing icons.
        
        if inIsDimmed {
            iconDisplayLayer.opacity = 0.5
        }

        var displayLayer = iconDisplayLayer
        
        if framedIcons { // If we are displaying framed icons, then we need to surround the icon with a circle, and shrink it.
            let frameCircleLayer = CAShapeLayer() // This is the circle "frame."
            let circleFrame = iconDisplayLayer.frame
            frameCircleLayer.frame.origin = CGPoint.zero
            frameCircleLayer.frame = circleFrame
            frameCircleLayer.path = UIBezierPath(arcCenter: CGPoint(x: circleFrame.midX, y: circleFrame.midY), radius: circleFrame.size.height / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
            frameCircleLayer.strokeColor = tintColor.cgColor
            frameCircleLayer.lineWidth = type(of: self)._kBorderWidth
            frameCircleLayer.fillColor = _centerLayer.fillColor
            
            let inset = Swift.max(iconDisplayLayer.frame.size.width, iconDisplayLayer.frame.size.height) / 6
            iconDisplayLayer.frame = iconDisplayLayer.frame.insetBy(dx: inset, dy: inset)
            
            frameCircleLayer.addSublayer(iconDisplayLayer)
            
            displayLayer = frameCircleLayer
        }

        return displayLayer
    }
    
    /* ################################################################## */
    /**
     This draws the control in an "open" state.
     
     It will always be a filled circle outline.
     
     - parameter inRect: The drawing rectangle
     */
    private func _drawOpenControl(_ inRect: CGRect) {
        if isOpen { // Only counts if we're open.
            _drawControlCenter(inRect) // Draw the center.
            if nil != _openSpinnerView {
                for index in 0..<count {
                    if let subLayer = _drawOneValueRadius(index) {
                        if 0 < subLayer.opacity {  // Only insert the ones that matter.
                            layer.insertSublayer(subLayer, at: 0)
                        }
                    }
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     This will either increment by one, decrement by one, or close the control, depending on which part of the open control is referenced by the point.
     
     - parameter inPointInLocalCoordinates: This is a point, in the coordinate system of the given view, to test.
     - parameter forView: The view in which we will test.
     */
    private func _handleOpenTouchEvent(_ inPointInLocalCoordinates: CGPoint, forView inView: UIView) {
        if isOpen && nil != _openSpinnerView { // Only counts if we're open.
            if nil != _decelerationDisplayLink {   // If we are spinning, a tap in the control will stop the spin.
                _decelerationDisplayLink?.invalidate()
                _decelerationDisplayLink = nil
            } else {
                // We will hit test in the center (selects the current value and closes the control), the right side (decrements the value), or the left side (increments the value).
                let center = CGRect(origin: CGPoint(x: inView.bounds.midX - (bounds.size.width / 2), y: inView.bounds.midY - (bounds.size.height / 2)), size: CGSize(width: bounds.size.width, height: bounds.size.height))
                let leftSide = CGRect(origin: CGPoint(x: inView.bounds.origin.x, y: inView.bounds.origin.y), size: CGSize(width: inView.bounds.size.width / 2, height: inView.bounds.size.height))
            
                if center.contains(inPointInLocalCoordinates) {
                    isOpen = false
                } else {
                    var newValue = selectedIndex

                    if leftSide.contains(inPointInLocalCoordinates) {
                        newValue += 1
                        if count == newValue {
                            newValue = 0
                        }
                    } else {
                        newValue -= 1
                        if 0 > newValue {
                            newValue = count - 1
                        }
                    }
                    
                    selectedIndex = newValue
                    
                    setNeedsDisplay()
                }
            }
        }
    }
    
    /* ################################################################## */
    /**
     Handle the control opening.
     */
    private func _openControl() {
        if !isEmpty {  // Only if we have something to display.
            if isHapticsOn {
                _selectionFeedbackGenerator = UISelectionFeedbackGenerator()
                _selectionFeedbackGenerator?.prepare()
                _impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                _impactFeedbackGenerator?.prepare()
            }
            _playOpenSound()

            if opensAsSpinner { // Only if we are opening the radial spinner.
                // We will add our big ol' getsure recognizer view.
                _openSpinnerView = UIView(frame: openSpinnerFrame)
                _openSpinnerView.backgroundColor = UIColor.clear

                // We will add our view to the superview of the control, just under the center.
                if let holderView = superview {
                    holderView.insertSubview(_openSpinnerView, belowSubview: self)
                }
                
                // Add our tap gesture recognizer.
                if nil == _tapGestureRecognizer {   // Just to be absolutely sure...
                    _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(type(of: self)._handleOpenTapGesture(_:)))
                    _openSpinnerView.addGestureRecognizer(_tapGestureRecognizer)
                }
                
                // Add our long press gesture recognizer.
                if nil == _longPressGestureRecognizer {   // Just to be absolutely sure...
                    _longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(type(of: self)._handleOpenLongPressGesture(_:)))
                    _longPressGestureRecognizer.require(toFail: _tapGestureRecognizer)
                    _openSpinnerView.addGestureRecognizer(_longPressGestureRecognizer)
                }
                
                // Add our rotation pan tracker gesture recognizer.
                if nil == _rotateGestureRecognizer {   // Just to be absolutely sure...
                    _rotateGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(type(of: self)._handleOpenPanGesture(_:)))
                    _rotateGestureRecognizer.require(toFail: _tapGestureRecognizer)
                    _rotateGestureRecognizer.require(toFail: _longPressGestureRecognizer)
                    _openSpinnerView.addGestureRecognizer(_rotateGestureRecognizer)
                    _rotateGestureRecognizer.delaysTouchesBegan = false
                }
                
                transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            } else {    // Otherwise, we are using the picker.
                _openPickerContainerView = UIView(frame: openPickerFrame)
                _openPickerContainerView!.backgroundColor = UIColor.clear
                _openPickerView = UIPickerView(frame: _openPickerContainerView!.bounds)
                _openPickerView.dataSource = self
                _openPickerView.delegate = self
                _openPickerView.showsSelectionIndicator = true
                _openPickerContainerView!.addSubview(_openPickerView!)
                if let holderView = superview {
                    holderView.insertSubview(_openPickerContainerView!, belowSubview: self)
                }
                
                _openPickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
                _openPickerContainerView!.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: openPickerFrame.size.height))
                transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
            // We animate the opening of both, and the closing of the picker.
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 25.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.transform = .identity
                            if nil != self?._openPickerContainerView {
                                self?._openPickerContainerView!.transform = .identity
                            }
                },
                           completion: nil
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
            let myCenter = CGPoint(x: self.frame.midX, y: self.frame.midY)
            if self.opensAsSpinner {    // If we are a spinner, we need to look all around.
                if let mySuperView = self.superview {
                    let minReachX = Float(Swift.min(myCenter.x, mySuperView.bounds.size.width - myCenter.x))
                    let minReachY = Float(Swift.min(myCenter.y, mySuperView.bounds.size.height - myCenter.y))
                    self._radiusOfOpenControlInDisplayUnits = Swift.min(minReachX, minReachY)
                }
            } else {
                self._radiusOfOpenControlInDisplayUnits = Float(myCenter.y)    // PickerView is easy. That's just above us.
            }
            
            if self._radiusOfOpenControlInDisplayUnits != oldRadius {
                self._layerCache = [CAShapeLayer?](repeating: nil, count: self.values.count)    // Clear the cache.
                self.setNeedsDisplay()
            }
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
                    self._rotateGestureRecognizer.removeTarget(self, action: #selector(type(of: self)._handleOpenPanGesture(_:)))
                    self._openSpinnerView.removeGestureRecognizer(self._rotateGestureRecognizer)
                    self._rotateGestureRecognizer = nil
                }
                
                if nil != self._tapGestureRecognizer {
                    self._tapGestureRecognizer.removeTarget(self, action: #selector(type(of: self)._handleOpenTapGesture(_:)))
                    self._openSpinnerView.removeGestureRecognizer(self._tapGestureRecognizer)
                    self._tapGestureRecognizer = nil
                }
                
                self._openSpinnerView.removeFromSuperview()
                self._layerCache = [CAShapeLayer?](repeating: nil, count: self.values.count) // Clear the cache.
                self._openSpinnerView = nil
                self.setNeedsLayout()
                self.setNeedsDisplay()
            } else if nil != self._openPickerContainerView {
                self._openPickerContainerView!.transform = .identity
            }
        
            // We animate the closing of the picker, but not the spinner.
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 7.0,
                           options: .allowUserInteraction,
                           animations: { [weak self] in
                            self?.transform = .identity
                            if nil != self?._openPickerContainerView {
                                self?._openPickerContainerView!.transform =  CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(CGAffineTransform(translationX: 0, y: self?.openPickerFrame.size.height ?? 0 / 2))
                            }
                },
                           completion: { [weak self] (_: Bool) in
                            self?.transform = .identity
                            if nil != self?._openPickerContainerView {
                                self?._openPickerContainerView!.removeFromSuperview()
                                self?._openPickerContainerView = nil
                                self?.setNeedsLayout()
                                self?.setNeedsDisplay()
                            }
                }
            )
        }
    }
    
    /* ################################################################## */
    // MARK: - Private Selector Methods
    /* ################################################################## */
    /**
     This is called when the orientation of the device has changed.
     
     - parameter notification: The notification object (ignored).
     */
    @objc private func _orientationChanged(notification inNotification: Notification) {
        _correctRadius()    // Make sure we stay in our lane.
    }
    
    /* ################################################################## */
    /**
     This method reacts to the tap gesture recognizer (for the open control).
     
     - parameter inGesture: The tap gesture recognizer.
     */
    @objc private func _handleOpenTapGesture(_ inGesture: UITapGestureRecognizer) {
        if isOpen && nil != _openSpinnerView { // Only counts if we're open.
            if let view = inGesture.view {
                let touchPoint = inGesture.location(in: view)
                _handleOpenTouchEvent(touchPoint, forView: view)
            }
        }
    }
    
    /* ################################################################## */
    /**
     This method reacts to the long press gesture recognizer (for the open control).
     
     - parameter inGesture: The tap gesture recognizer.
     */
    @objc private func _handleOpenLongPressGesture(_ inGesture: UILongPressGestureRecognizer) {
        if isOpen && nil != _openSpinnerView { // Only counts if we're open.
            if let view = inGesture.view {
                let touchPoint = inGesture.location(in: view)
                _handleOpenTouchEvent(touchPoint, forView: view)
            }
        }
    }

    /* ################################################################## */
    /**
     This method reacts to the pan gesture recognizer (for the open control).
     
     - parameter inGesture: The specialized pan gesture recognizer.
     */
    @objc private func _handleOpenPanGesture(_ inGesture: UIPanGestureRecognizer) {
        if isOpen && nil != _openSpinnerView { // Only counts if we're open.
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
                            newSelection += 1
                        } else {
                            newSelection -= 1
                        }
                    } else {    // If this is not the initial call, then we simply determine a delta from the start.
                        let delta = _initialAngleForPan - touchAngle
                        let radiansPerValue = (2 * CGFloat.pi) / CGFloat(count) // This is how many radians in our 2π circle it takes to account for one value.
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
                        
                        // See if we will be giving this a spin.
                        let finalVelocity = Swift.min(type(of: self)._kMaxFlywheelVelocity, Swift.abs(linearVelocity / type(of: self)._kFlywheelVelocityDivisor)) * ((0 > linearVelocity) ? -1 : 1)
                        if type(of: self)._kMinFlywheelVelocity < Swift.abs(finalVelocity) {
                            _startYourEngines(finalVelocity)
                        }
                    }
                    
                    setNeedsDisplay()
                }
            }
        }
    }

    /* ################################################################################################################################## */
    // MARK: - Public Control Value Data Class
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This class is used to represent one value of the spinner. We specify a class, as opposed to a struct, because we want to reference items.
     
     You need to watch out when comparing instances of this class, because we don't take the owner or the actual value into account.
     We compare the title, icon and description.
     The value is only tested for nil/not-nil. This is because it is an "Any", and we want to be able to jam whatever we want in there.
     The owner is not tested in the equatable test, but you can test it explicitly.
     */
    public class RVS_SpinnerDataItem: Equatable {
        /** This is the required title for the data item. This is what is most prominently displayed. */
        public var title: String
        /** This is an image to be displayed for the data item. */
        public var icon: UIImage
        /** This is an optional description String, which can provide more detailed information about the data item. */
        public var description: String?
        /** This is any associated data value. It is an optional "Any," and needs to be cast. */
        public var value: Any?
        /** This is the RVS_Spinner instance that "owns" this value . */
        public var owner: RVS_Spinner?
        /** This returns the index, in the owner. -1 if there is no owner, or the object cannot be found in the owner. READ ONLY */
        public var myIndex: Int {
            if let owner = owner {
                var index = 0

                for value in owner {
                    if value === self {
                        return index
                    }
                    
                    index += 1
                }
            }
            
            return -1
        }
        
        /* ################################################################## */
        /**
         This is the basic equatable operator.
         
         We compare all the fields except for the value (which may not be equatable), and the owner (because that's kind of dynamic).
         
         - parameter lhs: The left-hand side of the comparison.
         - parameter rhs: The right-hand side of the comparator.
         - returns true, if the two instances appear equal.
         */
        public static func == (lhs: RVS_Spinner.RVS_SpinnerDataItem, rhs: RVS_Spinner.RVS_SpinnerDataItem) -> Bool {
            var ret = lhs.title == rhs.title && lhs.icon == rhs.icon && lhs.description == rhs.description
            
            // We can't compare values, because they may not be equatable. However, we will look to see if their nil status is the same.
            ret = ret && ((nil == lhs.value) == (nil == rhs.value))
            
            return ret
        }
        
        /* ################################################################## */
        /**
         The default initializer. The only required parameter is the title.
         
         - parameter inTitle: A String, with the title of this value.
         - parameter icon: An image to be displayed for the value.
         - parameter description: A String, with a description of the value.
         - parameter value: A value to be associated with this value item.
         */
        public init(title inTitle: String, icon inIcon: UIImage, description inDescription: String? = nil, value inValue: Any? = nil) {
            title = inTitle
            icon = inIcon
            description = inDescription
            value = inValue
        }
        
        /* ################################################################## */
        /**
         A convenience initializer, allowing a title/image-only instantiation with a simple parameter list.
         
         - parameter inTitle: A String, with the title of this value.
         - parameter icon: An image, to be used as the icon for the value.
         */
        public convenience init(_ inTitle: String, icon inIcon: UIImage) {
            self.init(title: inTitle, icon: inIcon)
        }
        
        /* ################################################################## */
        /**
         This allows you to select the selectedIndex from the data item.
         
         This only works for a valid owner that actually owns this instance.
         */
        public func select() {
            if 0 <= myIndex {
                owner?.selectedIndex = myIndex
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
        let inset = type(of: self)._kBorderWidth / 2.0
        return UIBezierPath(ovalIn: bounds.inset(by: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)))
    }
    
    /* ################################################################## */
    /**
     This is the display font that we'll use.
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
            DispatchQueue.main.async {
                if self.selectedIndex != oldValue {
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
     At minimum, each value needs a "title," which is a String. It may also have an icon, to be displayed, a description, with more information, and associated data.
     The order is not changed by the spinner. Values are displayed in the order they are set in this Array, clockwise.
     */
    public var values: [RVS_SpinnerDataItem] = [] {
        didSet {
            // Who's your daddy? Who's your daddy?
            _ = values.compactMap({ [unowned self] in
                $0.owner = self
            })
            
            selectedIndex = Swift.max(0, Swift.min(values.count - 1, selectedIndex))
            _layerCache = [CAShapeLayer?](repeating: nil, count: values.count)    // Clear the cache.
           // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                if self.isOpen {
                    self.isOpen = false
                } else {
                    self.setNeedsLayout()
                    self.setNeedsDisplay()
                }
                self.sendActions(for: .valueChanged)
            }
        }
    }
    
    /* ################################################################## */
    /**
     If true, the control will play sounds.
     */
    public var isSoundOn: Bool = true
    
    /* ################################################################## */
    /**
     If true, the control will play haptics (on devices that support haptics).
     */
    public var isHapticsOn: Bool = true
    
    /* ################################################################## */
    /**
     This is the maximum number of elements that can be displayed in a spinner.
     Above this, needs to be displayed in a picker.
     */
    public  var spinnerThreshold: Int = 15
    
    /* ################################################################## */
    /**
     This is the spinner mode. It determines which control is displayed when the spinner is open.
     
     - both is 0 The spinnerThreshold is used to determine which will be displayed.
     - radial spinner only is -1 (default)
     - picker only is 1
     */
    public var spinnerMode: Int = SpinnerMode.both.rawValue {
        didSet {
            DispatchQueue.main.async {
                if self.isOpen {
                    self.isOpen = false
                } else {
                    self.setNeedsLayout()
                    self.setNeedsDisplay()
                }
            }
        }
    }

    /* ################################################################## */
    /**
     This is the offset from the top, in radians, of a spinner (ignored for picker).
     */
    public var selectedItemOffsetInRadians: Float = 0 {
        didSet {
            // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                self._layerCache = [CAShapeLayer?](repeating: nil, count: self.values.count)    // Clear the cache.
                self.setNeedsDisplay()
            }
        }
    }

    /* ################################################################################################################################## */
    // MARK: - Public Calculated Propeties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This calculated property will return either the currently selected item, or nil.
     */
    public var value: RVS_SpinnerDataItem? {
        get {
            if !values.isEmpty, selectedIndex < values.count, 0 <= selectedIndex {
                return values[selectedIndex]
            }
            
            return nil
        }
        
        // We allow "setting," as long as the Element is ours.
        set {
            if newValue?.owner == self {
                newValue?.select()
            }
        }
    }

    /* ################################################################## */
    /**
     If we have either a border color (tint), or a background color, then we display the icons enclosed in a frame.
     If that is the case, then the icon is displayed slightly smaller.
     
     - returns: True, if the images should be framed.
     */
    public var framedIcons: Bool {
        return !(_closedBackgroundColor?.isClear ?? true) || !(tintColor?.isClear ?? true)
    }
    
    /* ################################################################## */
    /**
     - returns: True, if the control will open as a spinner (as opposed to a picker).
     */
    public var opensAsSpinner: Bool {
        return SpinnerMode.spinnerOnly.rawValue == spinnerMode || ((SpinnerMode.both.rawValue == spinnerMode) && spinnerThreshold > count)
    }

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
     This is the background color associated with the "closed" control.
     
     This is set from the view background color.
     */
    public override var backgroundColor: UIColor! {
        didSet {
            // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                self._closedBackgroundColor = self.backgroundColor
                super.backgroundColor = UIColor.clear
            }
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
                self._layerCache = [CAShapeLayer?](repeating: nil, count: self.values.count)    // Clear the cache.
                self._openPickerView?.reloadAllComponents()
                self.setNeedsDisplay()
            }
        }
    }
    
    /* ################################################################################################################################## */
    // MARK: - Public IB Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is the background color associated with the "open" control "pie-slices."
     */
    @IBInspectable public var openBackgroundColor: UIColor! {
        didSet {
            // We will want to update our layout. Do it in the main thread, just in case.
            DispatchQueue.main.async {
                self._layerCache = [CAShapeLayer?](repeating: nil, count: self.values.count)    // Clear the cache.
                self._openPickerView?.reloadAllComponents()
                self.setNeedsDisplay()
            }
        }
    }

    /* ################################################################## */
    /**
     If this is true, then the spinner is open. Setting this will open or close the control.
     */
    @IBInspectable public var isOpen: Bool = false {
        didSet {    // This is the way we open and close the control.
            if isOpen && isOpen != oldValue, 1 < count {
                _openControl()
                // Let any delegate know that we have opened with a selected item.
                delegate?.spinner(self, hasOpenedWithTheValue: value)
            } else if !isOpen && isOpen != oldValue {
                _closeControl()
                // Let any delegate know that we have closed with a selected item.
                delegate?.spinner(self, hasClosedWithTheValue: value)
            }
            
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.setNeedsDisplay()
            }
        }
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
        // Clear the decks.
        layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        
        if 0 < values.count && isOpen {
            _drawOpenControl(inRect)
        } else {
            _drawControlCenter(inRect)
        }
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
     */
    override public func beginTracking(_ inTouch: UITouch, with inEvent: UIEvent?) -> Bool {
        _doneTracking = false
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
        return super.beginTracking(inTouch, with: inEvent)
    }
    
    /* ################################################################## */
    /**
     */
    override public func continueTracking(_ inTouch: UITouch, with inEvent: UIEvent?) -> Bool {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
        return super.continueTracking(inTouch, with: inEvent)
    }
    
    /* ################################################################## */
    /**
     */
    override public func endTracking(_ inTouch: UITouch?, with inEvent: UIEvent?) {
        _doneTracking = true

        if isTouchInside {
            if nil != _decelerationDisplayLink {   // If we are spinning, a tap in the control will stop the spin.
                _decelerationDisplayLink?.invalidate()
                _decelerationDisplayLink = nil
                DispatchQueue.main.async {
                    self._doneTracking = true
                    self.setNeedsDisplay()
                }
            } else {
                DispatchQueue.main.async {
                    if 1 < self.count {
                        self.isOpen = !self.isOpen
                    } else if 1 == self.count { // If we are a single value, there's a special case, where we don't open, but send a message.
                        self.delegate?.spinner(self, singleValueSelected: self.values[0])
                        self.setNeedsDisplay()
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
     */
    override public func cancelTracking(with inEvent: UIEvent?) {
        DispatchQueue.main.async {
            self._doneTracking = true
            self.setNeedsDisplay()
        }
        super.cancelTracking(with: inEvent)
    }

    /* ################################################################## */
    /**
     This is called before the subviews (aren't any) will get laid out.
     We use it to switch out the background color.
     We need the main UIView background to be clear, and use the set background
     as the "closed" control background color.
     We use the tint color as the border color.
     */
    override public func layoutSubviews() {
        if nil == openBackgroundColor {
            openBackgroundColor = UIColor.clear    // We are at least clear.
        }
        
        if nil == self._closedBackgroundColor {
            self._closedBackgroundColor = self.backgroundColor
            super.backgroundColor = UIColor.clear
        }

        super.layoutSubviews()
        
        _correctRadius()    // Make sure we stay in our lane.

        // We make sure that our frames are correct, if we rotated.
        if let openView = _openSpinnerView {
            openView.frame = openSpinnerFrame
        } else if let openView = _openPickerContainerView {
            openView.frame = openPickerFrame
        }
    }

    /* ################################################################################################################################## */
    // MARK: - Public Instance Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     A convenience init with a preset values array and value.
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
     The NSCoder init.
     
     - parameter coder: The decoder with the view state.
     */
    required init?(coder inDecoder: NSCoder) {
        super.init(coder: inDecoder)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(type(of: self)._orientationChanged(notification:)),
            name: UIApplication.didChangeStatusBarOrientationNotification,
            object: nil
        )
    }
    
    /* ################################################################## */
    /**
     We cancel any decelerator display link from here.
     */
    deinit {
        _decelerationDisplayLink?.invalidate()
    }

    /* ################################################################################################################################## */
    // MARK: - Public Array-Like Typealiases, Methods and Calculated Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /** This is the Sequence and Array Element typedef (an alias of RVS_SpinnerDataItem). */
    public typealias Element = RVS_SpinnerDataItem
    
    /* ################################################################## */
    /**
     - returns the number of elements in the value list
     */
    public var count: Int {
        return values.count
    }
    
    /* ################################################################## */
    /**
     - returns true, if the list is empty.
     */
    public var isEmpty: Bool {
        return 0 == count
    }
    
    /* ################################################################## */
    /**
     - returns the first element of the list. Nil, if the list is empty.
     */
    public var first: Element? {
        return isEmpty ? nil : self[0]
    }
    
    /* ################################################################## */
    /**
     - returns the last element of the list. Nil, if the list is empty.
     */
    public var last: Element? {
        return isEmpty ? nil : self[count - 1]
    }

    /* ################################################################## */
    /**
     Allows read/write access to one of the elements in the value list.
     
     - parameter inIndex: The 0-based index of the element to access. If it is out of range, the method will return nil, or ignore the set.
     - returns: One Element (or nil)
     */
    public subscript(_ inIndex: Int) -> Element! {
        get {
            var ret: Element?
            
            if (0..<values.count).contains(inIndex) {
                ret = values[inIndex]
            }
        
            return ret
        }
        
        set {
            if (0..<values.count).contains(inIndex), let value = newValue {
                values[inIndex] = value
            }
        }
    }
    
    /* ################################################################## */
    /**
     Allows read/write access to a range of the elements in the value list.
     
     This version of subscript is simpler than the single subscript, so range errors will result in a runtime error.
     
     - parameter bounds: The 0-based range of the elements to access. This isn't exactly the same as the Array method. You need to say "bounds:".
     - returns: An ArraySlice Range of Element
     */
    public subscript(bounds inRange: Range<Int>) -> ArraySlice<Element> {
        get {
            return values[inRange]
        }
        
        set {
            values[inRange] = newValue
        }
    }
    
    /* ################################################################## */
    /**
     Appends one element to the end of the list.
     
     - parameter inElement: One value to be added to the end of the value list.
     */
    public func append(_ inElement: Element) {
        insert(inElement, at: values.count)
    }
    
    /* ################################################################## */
    /**
     Appends an Array of Element to the end of the list.
     
     - parameter inElement: An Array of values to be added to the end of the value list.
     */
    public func append(contentsOf inElementArray: [Element]) {
        insert(contentsOf: inElementArray, at: values.count)
    }
    
    /* ################################################################## */
    /**
     Inserts one element into the given position in the list.
     
     - parameter inElement: One value to be inserted into the value list.
     - parameter at: The index of the Element that will be AFTER the new Element. If 0, then the insertion is the first. If count, then the Element is appended.
     */
    public func insert(_ inElement: Element, at inIndexAfter: Int) {
        if 0 <= inIndexAfter && inIndexAfter < values.count {
            values.insert(inElement, at: inIndexAfter)
        } else if inIndexAfter == values.count {
            values.append(inElement)
        }
        
        // We will want to update our layout.
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.sendActions(for: .valueChanged)
        }
    }
    
    /* ################################################################## */
    /**
     Inserts an Array of Element into the given position in the list.
     
     - parameter contentsOf: An Array of Element to be inserted into the value list.
     - parameter at: The index of the Element that will be AFTER the new Elements. If 0, then the insertion is the first. If count, then the Elements are appended.
     */
    public func insert(contentsOf inElementArray: [Element], at inIndexAfter: Int) {
        if 0 <= inIndexAfter && inIndexAfter < values.count {
            values.insert(contentsOf: inElementArray, at: inIndexAfter)
        } else if inIndexAfter == values.count {
            values.append(contentsOf: inElementArray)
        }
        
        // We will want to update our layout. Do it in the main thread, just in case.
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.sendActions(for: .valueChanged)
        }
    }

    /* ################################################################## */
    /**
     Remove a single indexed Element from the values list.
     
     - parameter inIndex: The 0-based index of the Element to remove.
     - returns: The removed Element
     */
    public func remove(at inIndex: Int) -> Element {
        let ret = values.remove(at: inIndex)
        ret.owner = nil // This is now an orphan.
        
        // We will want to update our layout.
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.sendActions(for: .valueChanged)
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Remove a single provided Element from the values list.
     
     - parameter inElement: The Element to remove.
     
     - returns: true, if the removal was successful.
     */
    public func remove(_ inElement: Element) -> Bool {
        var ret = false
        
        if 0 <= indexOf(inElement) {
            values.remove(at: indexOf(inElement))
            ret = true
            
            // We will want to update our layout.
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.sendActions(for: .valueChanged)
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Remove a number of provided Elements from the values list.
     
     - parameter inElements: An Array of Elements to remove.
     
     - returns: true, if the removal was successful. If there was a problem, the removal is halted immediately. It may be incomplete.
     */
    public func remove(_ inElements: [Element]) -> Bool {
        var ret = false
        for element in inElements {
            ret = true
            
            if !remove(element) {
                ret = false
                break
            }
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Remove every Element from the values list.
     */
    public func removeAll() {
        values = []
    }
    
    /* ################################################################## */
    /**
     Remove the first Element from the values list.
     
     - returns: The removed Element. Nil, if no elements left.
     */
    public func removeFirst() -> Element? {
        let ret = values.removeFirst()
        ret.owner = nil // This is now an orphan.

        // We will want to update our layout.
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.sendActions(for: .valueChanged)
        }
        
        return ret
    }

    /* ################################################################## */
    /**
     Remove a number of Elements from the beginning of the values list.
     
     - parameter inNumberOfElements: The 1-based count of elements to remove.
     */
    public func removeFirst(_ inNumberOfElements: Int) {
        values.removeFirst(inNumberOfElements)
        
        // We will want to update our layout.
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.sendActions(for: .valueChanged)
        }
    }

    /* ################################################################## */
    /**
     Remove the last Element from the values list.
     
     - returns: The removed Element. Nil, if no elements left.
     */
    public func removeLast() -> Element? {
        let ret = values.removeLast()
        ret.owner = nil // This is now an orphan.

        // We will want to update our layout.
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.sendActions(for: .valueChanged)
        }
        
        return ret
    }
    
    /* ################################################################## */
    /**
     Remove a number of Elements from the end of the values list.
     
     - parameter inNumberOfElements: The 1-based count of elements to remove (going backwards from -and including- the last Element).
     */
    public func removeLast(_ inNumberOfElements: Int) {
        values.removeLast(inNumberOfElements)
        
        // We will want to update our layout.
        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.sendActions(for: .valueChanged)
        }
    }
    
    /* ################################################################## */
    /**
     This will find the index, within our values Array, of the item.
     
     - parameter inItem: An Element to find in our values list
     
     - returns: -1 if not found, 0..<count for an item that was found.
     */
    public func indexOf(_ inItem: Element) -> Int {
        if self == inItem.owner {
            return inItem.myIndex
        }
        
        return -1
    }

    /* ################################################################################################################################## */
    // MARK: - Public Sequence Protocol Methods
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     - returns: a new iterator for the instance.
     */
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
    
    /* ################################################################## */
    /**
     This is the Sequence Iterator Struct.
     */
    public struct Iterator: IteratorProtocol {
        /** We actually reference the object it */
        private let _iteratedObject: RVS_Spinner!
        /** This is the current item in that list. */
        private var _index: Int
        
        /* ############################################################## */
        /**
         The default initializer.
         
         - parameter inIteratorTarget: The actual object instance to iterate. We don't iterate a captured Array.
         */
        init(_ inIteratorTarget: RVS_Spinner) {
            _iteratedObject = inIteratorTarget
            _index = 0
        }
        
        /* ############################################################## */
        /**
         Simple "next" iterator method.
         */
        mutating public func next() -> Element? {
            if _index < _iteratedObject.count {
                let ret = _iteratedObject[_index]
                
                _index += 1
                
                return ret
            } else {
                return nil
            }
        }
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
     
     - returns the number of rows (the number of values in our Array).
     */
    public func pickerView(_ inPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return count
    }
    
    /* ################################################################## */
    /**
     - parameter inPickerView: The pickerview doing the querying.
     - parameter rowHeightForComponent: The component (always 0, and ignored).
     
     - returns: float, with the row height for that component.
     */
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return type(of: self)._kMaxOpenImageSizeInDisplayUnits
    }
    
    /* ################################################################## */
    /**
     This builds one row view, including the icon and the text.
     It will center them over the center of the Spinner.
     
     - parameter inPickerView: The pickerview doing the querying.
     - parameter viewForRow: the 0-based index of the row (used to index our values).
     - parameter forComponent: The component (always 0, and ignored).
     - parameter reusing: The view object to reuse.
     
     - returns: a new (or refurbed) view object.
     */
    public func pickerView(_ inPickerView: UIPickerView, viewForRow inRow: Int, forComponent inComponent: Int, reusing inView: UIView?) -> UIView {
        if nil != inView { // Since the values don't change in this. It's safe to do this.
            return inView!
        }
        
        let size = inPickerView.rowSize(forComponent: 0)
        var myFrame = inPickerView.bounds
        myFrame.size.height = size.height
        myFrame.origin = CGPoint.zero
        // We create a frame for the image and the label, giving them a bit of "breathing room."
        let imageFrame = CGRect(origin: CGPoint(x: type(of: self)._kOpenPaddingInDisplayUnits / 2,
                                                y: type(of: self)._kOpenPaddingInDisplayUnits / 2),
                                size: CGSize(width: myFrame.size.height - type(of: self)._kOpenPaddingInDisplayUnits,
                                             height: myFrame.size.height - type(of: self)._kOpenPaddingInDisplayUnits))
        let labelFrame = CGRect(origin: CGPoint(x: myFrame.size.height + type(of: self)._kOpenPaddingInDisplayUnits,
                                                y: type(of: self)._kOpenPaddingInDisplayUnits / 2),
                                size: CGSize(width: myFrame.size.width - (type(of: self)._kOpenPaddingInDisplayUnits + myFrame.size.height),
                                             height: myFrame.size.height - type(of: self)._kOpenPaddingInDisplayUnits))

        let ret: UIView = UIView(frame: myFrame)
        
        ret.backgroundColor = openBackgroundColor
        
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = values[inRow].icon
        imageView.backgroundColor = UIColor.clear
        var enclosingRect = CGRect.zero

        let containerView = UIView()
        
        if !values[inRow].title.isEmpty {   // If we have title text, then that goes in the label. If we don't have any, we won't even create a label.
            let label = UILabel(frame: labelFrame)
            label.textColor = tintColor?.isClear ?? true ? UIColor.black : tintColor    // This prevents us from drawing transparent text.
            label.backgroundColor = UIColor.clear
            label.font = displayFont
            label.text = values[inRow].title
            containerView.addSubview(label)
            // This is how we center the combination of the icon and the text. This calculates the size necessary for the text.
            enclosingRect = label.text!.boundingRect(with: ret.bounds.size, context: nil)
        }
        
        let containerRect = CGRect(x: ret.bounds.midX - (enclosingRect.size.width + myFrame.size.height + type(of: self)._kOpenPaddingInDisplayUnits) / 2,
                                   y: 0,
                                   width: (enclosingRect.size.width + myFrame.size.height + type(of: self)._kOpenPaddingInDisplayUnits),
                                   height: myFrame.size.height)
        
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
     - parameter inComponent: The component (always 0, and ignored).
     */
    public func pickerView(_ inPickerView: UIPickerView, didSelectRow inRow: Int, inComponent: Int) {
        selectedIndex = inRow
        setNeedsDisplay()
    }
}
