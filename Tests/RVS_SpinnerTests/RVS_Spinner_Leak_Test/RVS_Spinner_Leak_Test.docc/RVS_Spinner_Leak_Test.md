# ``RVS_Spinner_Leak_Test``

Exercise control release, popup cleanup, and removal during flywheel animation.

## Overview

The controller loads up to ten numbered image assets and provides a Remove & Recreate
button. The replacement keeps the items, frame, mode, colors, and selection, starts
closed, and uses default sound and haptic settings. Delegate hooks remain empty to
keep additional UI work out of the profiling exercise.

### Run repeatable lifetime checks

Add `--verify-spinner-leaks` to the Leak scheme's Run arguments and run a Debug build.
Once the view is in a window, the harness performs 100 temporary-control open, close,
reopen, and removal cycles. Each checks that no sibling popup remains. It then recreates
the displayed control and checks a weak reference after half a second, allowing UIKit's
transaction and autorelease pool to drain. A successful release prints
`SPINNER LEAK CHECK PASSED`; a failed assertion stops a Debug build.

Remove & Recreate is also available during ordinary use, including while spinning.
Run Product → Profile with Allocations or Leaks and repeat spinning, mode changes,
and recreation for longer sessions. Weak-reference checks complement Instruments;
they do not provide a complete heap-leak analysis. See `Tests/Verification.md` for
the full checklist and earlier recorded results.

## Topics

### Lifetime exercise

- ``RVS_Spinner_Leak_Test_ViewController``

### Scene lifecycle

- ``RVS_Spinner_Leak_Test_AppDelegate``
- ``HarnessSceneDelegate``
