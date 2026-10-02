# ``RVS_Spinner_Tabbed_Test_Harness``

Exercise spinner container geometry, rotation, image collections, and tab transitions.

## Overview

The tab bar controller loads the six bundled DisplayImages collections in directory
and filename order. Numeric prefixes control sorting and are removed from display
titles. Images retain their original rendering mode, including full-color emoji.

### Explore the tabs

- Simple Center uses a centered control with collection and mode selectors.
- Bottom Right rotates the storyboard container by -45 degrees.
- Quadrants assigns four collections to independent rotated containers. Its initial
  indices use half the northwest collection's count and are clamped by each control.
- Rotator changes the immediate container's transform in one-item angular steps and
  lets you toggle center-image compensation. Changing collections resets the rotation.

Single-spinner tabs force ring or picker mode; they do not offer automatic mode.
Their shared base controller logs delegate and target/action hooks in Debug builds.
The Quadrants controller uses silent default delegate implementations.

Switch tabs with a popup open, compare image collections and long picker titles,
and rotate or resize an iPad window. See `Tests/Verification.md` for manual checks.
This harness has no launch-argument assertion suite.

## Topics

### Shared data and controllers

- ``RVS_Spinner_Tabbed_Test_Harness_TabBarController``
- ``RVS_Spinner_Tabbed_Test_Harness_DirElement``
- ``RVS_Spinner_Tabbed_Test_Harness_Spinner_ViewController``
- ``RVS_Spinner_Tabbed_Test_Harness_Basic_ViewController``

### Geometry examples

- ``RVS_Spinner_Tabbed_Test_Harness_Basic_Centered_ViewController``
- ``RVS_Spinner_Tabbed_Test_Harness_Bottom_Right_ViewController``
- ``RVS_Spinner_Tabbed_Test_Harness_FourPart_ViewController``
- ``RVS_Spinner_Tabbed_Test_Harness_Rotator_ViewController``

### Scene lifecycle

- ``RVS_Spinner_Tabbed_Test_Harness_AppDelegate``
- ``RVS_Spinner_Tabbed_Test_Harness_NavController``
- ``HarnessSceneDelegate``
