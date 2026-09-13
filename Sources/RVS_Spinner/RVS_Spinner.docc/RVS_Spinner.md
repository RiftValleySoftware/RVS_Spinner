# ``RVS_Spinner``

A compact icon control that expands into a radial spinner or a standard picker.

## Overview

Use `RVS_Spinner` to choose among an ordered array of icons. The closed control displays
one icon; activating it expands a ring of items or a `UIPickerView` above the center.
The library requires iOS 15 or later, uses UIKit, and has no third-party dependencies.

The control, its configuration, and delegate callbacks run on the main actor. Dispatch
work that changes it to the main actor before accessing any property.

### Create a spinner

```swift
import RVS_Spinner

let spinner = RVS_Spinner(
    values: [
        RVS_SpinnerDataItem(title: "Favorite", icon: UIImage(systemName: "star")!, value: "favorite"),
        RVS_SpinnerDataItem(title: "Archive", icon: UIImage(systemName: "archivebox")!, value: "archive")
    ],
    frame: CGRect(x: 125, y: 225, width: 50, height: 50)
)
spinner.accessibilityLabel = "Destination"
spinner.addTarget(self, action: #selector(destinationChanged(_:)), for: .valueChanged)
view.addSubview(spinner)
```

The target method can read `spinner.value?.value as? String`. Select a row in code with
`spinner.selectedIndex = 1`. Keep a strong reference to your delegate elsewhere; the
control stores it weakly. The convenience initializer configures the initial state
before assigning its delegate, so construction does not notify that delegate.

### Provide room for the popup

Place the center away from its container's edges. The popup is a sibling inserted
immediately below the control. The ring fits within the closest container edge; the
picker spans the container's width and uses the space above the center. Bounds origins
and later layout changes are accounted for. Other siblings above the popup can cover it
or intercept its touches, and a clipped container clips its contents.

A control with no items has no center image and cannot activate. With one item it acts
as a button and calls `spinner(_:singleValueSelected:)`, without opening a popup.
With two or more items, activation toggles the popup. Removing the control or its
container from a window also removes its popup and stops spinning.

### Choose the presentation

Set `spinnerMode` to a `SpinnerMode.rawValue`, or choose the mode in the convenience
initializer. Interface Builder accepts -1 for ring, 0 for automatic, and 1 for picker.
Invalid raw values become 0. In automatic mode the ring is used only when the item
count is **less than** `spinnerThreshold`. At the default threshold of 15, 14 items use
the ring and 15 use the picker. Thresholds below 2 become 2.

Tap the left side of the ring to select the previous item, or the right side to select
the next, wrapping at the ends. Drag around the center to spin. A quick drag starts a
flywheel that slows to a stop; tapping stops it. A long press steps once. In the picker,
selection changes when scrolling settles. Reduce Motion disables popup scaling,
animated ring rotation, center-image bouncing, and the flywheel.

### Understand selection notifications

| Operation | Notifications |
| --- | --- |
| Change `selectedIndex` to a different clamped index, by gesture or in code | Selection delegate, then one `.valueChanged` |
| Assign the same clamped index | None |
| Replace `values` | One `.valueChanged`; also the closed callback if a popup was open |
| Open or close | Matching delegate callback after `isOpen` changes, before animation finishes |
| Physical center release inside | UIKit's `.touchUpInside`, plus `.primaryActionTriggered` |
| Accessibility or semantic activation | `.touchUpInside` and `.primaryActionTriggered` |

Replacing `values` clamps the index without a separate selection-delegate callback.
With an empty array the index is 0 and `value` is nil. Selection callbacks are
synchronous: if a delegate changes selection or values again, the newer operation
supersedes the outer operation's pending `.valueChanged`. Target/action handlers
always read the control's current state. Avoid assigning the same value repeatedly
from a callback that is itself caused by replacing `values`.

An explicit `isOpen = false` asks `spinner(_:willCloseWithTheValue:)` for permission.
Return false to leave it open. Recursive close requests during that decision are
ignored, and changing selection or configuration cancels the pending decision.
Replacing values, changing mode/threshold, disabling, hiding, turning off interaction,
or detaching the control forces cleanup without asking for a veto.

### Dimmed items and accessibility

`RVS_SpinnerDataItem.isEnabled = false` dims an item **without removing it from the
selection sequence**. This permits selecting an unavailable choice to explain it.
Validate the payload before acting on it. To reject confirmation, implement the close
decision and return `willCloseWithTheValue?.isEnabled ?? false`. This flag is distinct
from `spinner.isEnabled`, which disables the entire control and closes its popup.

Set an accessible label such as "Destination" on the control. The selected item's
`title` supplies its default accessibility value and `description` supplies its hint;
custom accessibility values and hints override these until set back to nil. VoiceOver
can activate the center and adjust values directly, even with the popup closed. Give
items meaningful titles even when primarily using the radial presentation.

### Customize images and colors

Template images follow `tintColor`; original images keep their colors. HUD mode
forces template rendering and removes icon frames and sector backgrounds. Empty
images are omitted safely, and non-square images keep their aspect ratio.

`backgroundColor` fills the circular icon frames, while the view's rectangular
background remains transparent. `openBackgroundColor` fills the expanded sectors or
picker rows. Dynamic colors refresh with appearance changes. The control's alpha is
applied once to its center and sibling popup. Transparent tint uses the system label
color for picker text so titles remain readable.

Set `centerImage` to show a fixed center icon. With `replaceCenterImage = true`, the
selected item's icon replaces it while open, then the fixed image returns on closing.
`isCompensatingForContainerRotation` counter-rotates the center against its immediate
container. Sounds and haptics can be disabled independently. Haptic output depends on
hardware; verify it on a physical device.

### Integrate and verify

The Swift package includes its privacy manifest as a resource. For direct source or
static-library integration, include `PrivacyInfo.xcprivacy` in the consuming app's
resources; a static archive cannot carry app resources. The library does not collect,
transmit, or persist the supplied values, and its default delegate methods do not log.
An item's `Any` payload is retained as long as the item remains in the control's array.
Avoid a payload that strongly owns the spinner, as that would create an application
reference cycle.

The repository has four scene-based apps: Basic for configuration and callbacks, HUD
for image/tint combinations, Tabbed for container geometry and rotation, and Leak for
lifetime checks and Instruments. See `Tests/Verification.md` for repeatable checks.
There is no unit-test or coverage target.

## Topics

### Control and items

- ``RVS_Spinner``
- ``RVS_SpinnerDataItem``
- ``RVS_SpinnerDelegate``
