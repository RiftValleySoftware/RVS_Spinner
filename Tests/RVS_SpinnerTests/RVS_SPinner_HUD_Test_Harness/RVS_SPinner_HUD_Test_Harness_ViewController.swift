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
// MARK: - UIImage Extension -
/* ###################################################################################################################################### */
/**
 Adds the HUD harness's offscreen image-resizing helper.
 */
extension UIImage {

    /* ################################################################## */
    /**
     Renders a resized copy using dimensions measured in points and the screen's default scale.

     Supplying one dimension preserves aspect ratio. Supplying both dimensions scales
     each axis independently and can stretch the image. The source and requested sizes
     must be positive; this helper is used with nonempty SF Symbols.

     - parameter inNewWidth: Target width in points; nil derives it from the target height.
     - parameter inNewHeight: Target height in points; nil derives it from the target width.
     - returns: The rendered image, or nil if both dimensions are omitted or rendering fails.
     */
    func resized(toNewWidth inNewWidth: CGFloat? = nil, toNewHeight inNewHeight: CGFloat? = nil) -> UIImage? {
        guard nil == inNewWidth,
              nil == inNewHeight else {
            var scaleX: CGFloat = (inNewWidth ?? size.width) / size.width
            var scaleY: CGFloat = (inNewHeight ?? size.height) / size.height

            scaleX = nil == inNewWidth ? scaleY : scaleX
            scaleY = nil == inNewHeight ? scaleX : scaleY

            let destinationSize = CGSize(width: size.width * scaleX, height: size.height * scaleY)
            let destinationRect = CGRect(origin: .zero, size: destinationSize)

            UIGraphicsBeginImageContextWithOptions(destinationSize, false, 0)
            defer { UIGraphicsEndImageContext() }   // This makes sure that we get rid of the offscreen context.
            draw(in: destinationRect, blendMode: .normal, alpha: 1)
            return UIGraphicsGetImageFromCurrentImageContext()
        }

        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Main View Controller Class -
/* ###################################################################################################################################### */
/**
 Exercises a large HUD ring over a background image with selectable tints and center icons.

 The storyboard supplies an oversized container that places the center at its bottom edge.
 HUD mode forces template rendering, including the otherwise original-color BlueMarble image.
 */
class RVS_SPinner_HUD_Test_Harness_ViewController: UIViewController {

    /* ################################################################## */
    /**
     SF Symbol names used to populate the HUD ring; unavailable symbols are skipped.
     */
    static let imageNames: [String] = ["face.smiling",
                                       "face.smiling.fill",
                                       "face.dashed",
                                       "face.dashed.fill",
                                       "person.circle",
                                       "person.circle.fill",
                                       "person.crop.circle",
                                       "person.crop.circle.fill",
                                       "person",
                                       "person.fill",
                                       "person.2",
                                       "person.2.fill"

    ]

    /* ################################################################## */
    /**
     The BlueMarble asset, used to compare a custom center with selected icons while open.
     */
    static let normalImage = UIImage(named: "BlueMarble")

    /* ################################################################## */
    /**
     The Globe asset explicitly configured for template rendering.
     */
    static let templateImage = UIImage(named: "Globe")?.withRenderingMode(.alwaysTemplate)

    /* ################################################################## */
    /**
     A question-mark SF Symbol used as a fixed template center.
     */
    static let sfSymbolImage = UIImage(systemName: "questionmark.circle.fill")?.withRenderingMode(.alwaysTemplate)

    /* ################################################################## */
    /**
     The target width in points used to render the ring's source images.
     */
    static let imageSize: CGFloat = 320

    /* ################################################################## */
    /**
     The most recently prepared SF Symbol items. They are assigned to the spinner during initial setup.
     */
    var spinnerItems: [RVS_SpinnerDataItem] = []

    /* ################################################################## */
    /**
     Selects the default center, BlueMarble, Globe, or question-mark symbol.
     */
    @IBOutlet weak var centerImageSegmentedSwitch: UISegmentedControl!

    /* ################################################################## */
    /**
     The storyboard spinner configured for HUD presentation.
     */
    @IBOutlet weak var spinnerControl: RVS_Spinner!

    /* ################################################################## */
    /**
     Selects the template-icon tint using color swatches.
     */
    @IBOutlet weak var tintSelectorSegmentedSwitch: UISegmentedControl!
}

/* ###################################################################################################################################### */
// MARK: - Callbacks -
/* ###################################################################################################################################### */
extension RVS_SPinner_HUD_Test_Harness_ViewController {

    /* ################################################################## */
    /**
     Applies the chosen center image and its replacement behavior.

     BlueMarble is replaced by the selected icon while open; Globe and the question-mark
     symbol remain fixed. The default choice uses the selected item with no custom center.

     - parameter inSwitch: The center-image selector.
     */
    @IBAction func centerImageSegmentedSwitchChanged(_ inSwitch: UISegmentedControl) {
        if 1 == inSwitch.selectedSegmentIndex {
            spinnerControl?.centerImage = Self.normalImage
            spinnerControl?.replaceCenterImage = true
        } else if 2 == inSwitch.selectedSegmentIndex {
            spinnerControl?.centerImage = Self.templateImage
            spinnerControl?.replaceCenterImage = false
        } else if 3 == inSwitch.selectedSegmentIndex {
            spinnerControl?.centerImage = Self.sfSymbolImage
            spinnerControl?.replaceCenterImage = false
        } else {
            spinnerControl?.centerImage = nil
            spinnerControl?.replaceCenterImage = false
        }
    }

    /* ################################################################## */
    /**
     An intentionally empty storyboard action for observing `.valueChanged` while debugging.

     - parameter sender: The spinner whose selection or values changed.
     */
    @IBAction func spinnerControlChangedValue(_ sender: RVS_Spinner) {
    }

    /* ################################################################## */
    /**
     Applies the tint selected by the color-swatch control. The sender is ignored.
     */
    @IBAction func tintSelectorSegmentedSwitchChanged(_: Any) {
        setSelectedTint()
    }

    /* ################################################################## */
    /**
     Resolves the selected tint and prepares template SF Symbol items at the configured image size.

     Segment 0 uses AccentColor, segment 1 uses the dynamic label color, and later
     segments use Tint-N assets. Only initial setup assigns the prepared items to the
     spinner; subsequent calls update its tint while preserving its current selection.
     */
    func setSelectedTint() {
        if let index = tintSelectorSegmentedSwitch?.selectedSegmentIndex,
           let color = 0 == index ? UIColor(named: "AccentColor") : 1 == index ? .label : UIColor(named: "Tint-\(index)") {
            spinnerItems = []
            Self.imageNames.forEach {
                if let icon = UIImage(systemName: $0)?.resized(toNewWidth: Self.imageSize)?.withRenderingMode(.alwaysTemplate) {
                    spinnerItems.append(RVS_SpinnerDataItem(title: $0, icon: icon))
                }
            }
            spinnerControl?.tintColor = color
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Base Class Overrides -
/* ###################################################################################################################################### */
extension RVS_SPinner_HUD_Test_Harness_ViewController {

    /* ################################################################## */
    /**
     Builds the tint swatches, selects the initial red preset, and assigns the prepared spinner items.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the little tint squares for the tint selector control.
        if let tintSelectorSegmentedSwitch = tintSelectorSegmentedSwitch {
            if let color = UIColor(named: "AccentColor"),
               let image = UIImage(systemName: "square.fill")?.withTintColor(color) {
                tintSelectorSegmentedSwitch.setImage(image.withRenderingMode(.alwaysOriginal), forSegmentAt: 0)
            }
            if let image = UIImage(systemName: "square.fill")?.withTintColor(.label) {
                tintSelectorSegmentedSwitch.setImage(image.withRenderingMode(.alwaysOriginal), forSegmentAt: 1)
            }
            for index in 2..<tintSelectorSegmentedSwitch.numberOfSegments {
                if let color = UIColor(named: "Tint-\(index)"),
                   let image = UIImage(systemName: "square.fill")?.withTintColor(color) {
                    tintSelectorSegmentedSwitch.setImage(image.withRenderingMode(.alwaysOriginal), forSegmentAt: index)
                }
            }

            // Select red, so it stands out.
            tintSelectorSegmentedSwitch.selectedSegmentIndex = tintSelectorSegmentedSwitch.numberOfSegments - 2
            setSelectedTint()
            spinnerControl?.values = spinnerItems
        }
    }
}
