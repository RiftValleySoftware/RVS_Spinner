# ``RVS_SPinner_HUD_Test_Harness``

Exercise HUD rendering, large template icons, tint presets, and custom center images.

## Overview

The storyboard's oversized container places the center at its bottom edge so that
only part of the expanded ring is visible over a background image. The controller
loads available SF Symbols and renders their source images at a width of 320 points.
Changing a tint preserves the spinner's current selection.

### Compare center-image behavior

- The default segment uses the selected item's icon.
- BlueMarble supplies a custom center that is replaced by the selected icon while open.
- Globe and the question-mark symbol remain fixed while open.

HUD mode forces template rendering, so BlueMarble is tinted too. The helper's
dimensions are in points, with a screen-scale bitmap; supplying one dimension preserves
aspect ratio, while supplying both can stretch the image.

Open the ring, change tints while open, and compare center images. This harness has
no launch-argument assertion suite. See `Tests/Verification.md` for manual checks.
It defines its own scene delegate and image helper; neither is part of the library API.

## Topics

### HUD controls

- ``RVS_SPinner_HUD_Test_Harness_ViewController``

### Scene lifecycle

- ``RVS_SPinner_HUD_Test_Harness_AppDelegate``
- ``HarnessSceneDelegate``
