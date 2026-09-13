# RVS_Spinner harness verification

Use the existing Xcode schemes with an iPhone or iPad destination. All four apps use
window scenes and the local `RVS_Spinner` library target. There is no coverage or
unit-test target. The minimum supported OS is iOS 15.

## Repeatable checks

In **Edit Scheme → Run → Arguments**, add the indicated launch argument and run a
Debug build. A failed assertion stops the app; successful groups print a `PASSED`
line. Remove the argument for ordinary interactive use.

| Scheme | Launch argument | What it checks |
| --- | --- | --- |
| `RVS_Spinner_Basic_Test_Harness` | `--verify-spinner` | Index clamping, empty and one-item states, selection notifications, reentrancy, vetoes, configuration changes, rapid reopening, picker row refresh/selection, transparent colors, accessibility, empty-image rendering, view removal, and object lifetime |
| `RVS_Spinner_Basic_Test_Harness` | Same argument | Deterministic pan samples exercise drag direction, low-velocity stopping without a whole-item change, fast spinning, replacing data during a spin, and release during a spin |
| `RVS_Spinner_Leak_Test` | `--verify-spinner-leaks` | 100 open/close/reopen/removal cycles, sibling-view cleanup, and weak-reference release after recreation |

The Basic harness prints `SPINNER VERIFICATION PASSED` and then
`SPINNER FLYWHEEL VERIFICATION PASSED`. Allow the asynchronous flywheel checks to
finish before touching controls. Run these checks with Reduce Motion **off**, because
they deliberately expect inertial motion. With the argument present, later manual
center activations log each `.touchUpInside` and `.primaryActionTriggered`, and pan
start/end logs include velocity.

The gesture probe is confined to the Debug harness. It feeds known samples to the
production pan action, including real display-link updates between samples. Its
selector assertion must be updated if that private action is renamed. Device Hub's
automated drag reported zero velocity during this review, so deterministic samples
were used for flywheel validation; they do not assess how a physical flick feels.

In the Leak harness, **Remove & Recreate** can be used at any time, including during a
spin. It verifies the old control is released after UIKit's transaction and autorelease
pool drain. For allocation trends, run **Product → Profile → Allocations / Leaks** and
repeat opening, spinning, changing modes, and recreating. The weak-reference checks
complement Instruments; they are not a complete heap-leak analysis.

## Interactive checklist

### Basic

- Switch among ring, automatic, and picker modes, including equality at the threshold.
- Open, step left/right, close, and reopen rapidly. Release a center touch outside to cancel.
- Change the item count and mode while open. Check empty and one-item behavior in code.
- Scroll the picker and confirm the center, label, and selected item agree.
- Exercise dimmed items. They remain selectable; disabling the whole control is different.
- Change background, open background, tint, and HUD mode. Check light and dark appearance.
- Enable Reduce Motion and repeat opening/closing/stepping; scaling and inertia should stop.
- Check accessible labels, direct adjustment, activation, and spoken announcements with VoiceOver.

### HUD

- Open the large ring over the background image and change tint while open.
- Exercise no custom center, the original image, the template globe, and the SF Symbol.
- Check `replaceCenterImage`: the selected icon appears while open and the custom center returns when closed.
- The oversized container intentionally places the center at the bottom edge and shows only part of its ring.

### Tabbed

- Open the ring in Simple Center, switch tabs while open, and confirm the old popup disappears.
- Test the Bottom Right and Quadrants containers, including small available areas.
- In Rotator, move the slider with the popup open and toggle center-image compensation.
- Switch among the image collections and picker mode, including long titles and full-color emoji.
- Rotate or resize an iPad window and check popup alignment and clipping.

### Leak

- Spin, then use Remove & Recreate. Confirm the release message and absence of stray popups.
- Switch modes while open and repeat recreation. Run Instruments for a longer profiling session.

## Recorded results — September 13, 2026

- All four simulator harness targets built with Xcode 27 using the local library and iOS 15 deployment settings.
- Basic synchronous regression and asynchronous flywheel checks passed on iPhone 16 / iOS 18.6 and iPhone 18 Pro / iOS 27.
- Physical center taps on both runtimes emitted one touch-up and one primary-action event. Accessibility activation on iOS 18.6 did the same.
- Basic ring stepping, picker presentation, dynamic picker-text colors in light/dark appearance, and Reduce Motion presentation were checked interactively on iOS 27.
- HUD launch, expanded presentation, live tint changes, and a fixed template center were checked on iOS 27.
- Tabbed launch, original-color icons, radial presentation, switching away from an open popup, and the Rotator tab were checked on iOS 27.
- Leak lifecycle stress and recreation checks passed on iOS 27 and iOS 18.6.
- SwiftPM simulator build and resource packaging passed. Each harness app contains its privacy manifest.
- Device Release library build, Release Basic harness build, and DocC build with warnings treated as errors passed. All 81 generated symbol pages have summaries.

Still requires hands-on device assessment: physical flick feel, haptics/audio, spoken
VoiceOver, rotated/resized iPad layouts, and longer Instruments sessions. iOS 15 was a
build deployment target; the installed simulator runtimes used here were 18.6 and 27.
