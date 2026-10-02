# ``RVS_Spinner_Basic_Test_Harness``

Exercise spinner configuration, callback ordering, and repeatable regression checks.

## Overview

The storyboard supplies a spinner and selectors for item count, dimming, colors,
presentation mode, the automatic-mode threshold, HUD rendering, sounds, and haptics.
The controller demonstrates both target/action and delegate callbacks. Selected
String payloads appear in white; transient activation and popup messages appear in black.
Dimmed items remain selectable.

### Run the regression checks

In the Basic scheme's Run arguments, add `--verify-spinner` and run a Debug build
on an iPhone or iPad simulator. Keep Reduce Motion off and wait for both
`SPINNER VERIFICATION PASSED` and `SPINNER FLYWHEEL VERIFICATION PASSED` before
interacting. Assertions stop the app on a failed check. Remove the argument for
ordinary interactive use. Release builds do not execute these assertions.

The synchronous probe checks clamping, callbacks, reentrancy, close vetoes, cleanup,
picker rows, accessibility, rendering (including UIKit highlighting and restoration
without selection events), and object release. The asynchronous probe
feeds known gesture samples to the production pan action and allows real display-link
updates between samples. It checks drag direction, low-velocity stopping, fast spinning,
data replacement, and release during a spin. It relies on a private selector and does
not measure the feel of a physical flick.

There is no unit-test target or coverage instrumentation. See `Tests/Verification.md`
in the repository for the full interactive checklist and earlier recorded results.

## Topics

### Configuration and callbacks

- ``RVS_Spinner_Basic_Test_Harness_ViewController``

### Scene lifecycle

- ``RVS_Spinner_Basic_Test_Harness_AppDelegate``
- ``HarnessSceneDelegate``
