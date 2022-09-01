# RVS_Spinner Change Log

## 2.6.0

- **September 1, 2022**

- Updated to the latest tools.
- Removed the `centerShape` property, as it is not used, anymore.
- Changed the implicit optionals into explicit optionals, as I don't like implicit optionals. This should not affect the API.

## 2.5.11

- **March 15, 2022**

- Updated the tools. No functional or API changes.

## 2.5.10

- **January 28, 2022**

- Added support for DocC. No functional or API changes.

## 2.5.9

- **December 14, 2021**

- Updated to the latest toolchains.

## 2.5.8

- **September 23, 2021**

- Updated to the latest toolchains.
- Fixed an issue, where the images needed to be loaded as always template.

## 2.5.7

- **August 21, 2021**

- I rewrote the deprecated callback to be more "future-proof."

## 2.5.6

- **August 15, 2021**

- Fixed a crash in the new animator.

## 2.5.5

- **August 15, 2021**

- Now animate the replacement of the center image.

## 2.5.4

- **August 11, 2021**

- The images were not being correctly resized, if they did not have a 1:1 aspect ratio.

## 2.5.3

- **May 14, 2021**

- Improved the display of the PickerView variant.
- Tweaked the way HUD Mode works, to include the picker variant.
- Added a HUD Mode switch to the basic test harness.

## 2.5.2

- **May 14, 2021**

- Removed CocoaPods support.
- Moved SwiftLint to use the system version.
- Fixed an issue with the HUD demo, where the center image was not being displayed.
- Major improvement to the way that images are drawn.

## 2.5.1

- **April 28, 2021**

- Had to add @available to the protocol defs.

## 2.5.0

- **April 28, 2021**

- Added the "Replace Center Image" option.
- The control now requires iOS 13 and above.
- Removed some redundant code.
- Fixed a bug in the new center image replacement code that prevented dimming during open selection.
- Made the "dimmed" alpha a bit heavier.

## 2.4.1

- **April 8, 2021**

- Internal refactoring.

## 2.4.0

- **April 7, 2021**

- Cleaned up the transparency screen.
- added support for a constant central image.
- Added "HUD Mode."
- Fixed an issue, where the control would not close, if no delegate was supplied.

## 2.3.6

- **February 23, 2021**

- Added some code to try to remove the IB build errors for non-iOS operating systems (when included by SPM).

## 2.3.5

- **September 26, 2020**

- Added the ability to evaluate whether or not to close the spinner.

## 2.3.4

- **September 23, 2020**

- There was a bug, when immediately opening the control, programmatically.

## 2.3.3

- **September 22, 2020**

- Updated the project, and now require iOS 12.0 or above.

## 2.3.2

- **September 18, 2020**

- Added the ability to disable individual items (not just the whole control).

## 2.3.1

- **August 1, 2020**

- Rearranged for GitHub Swift action.

## 2.3.0

- **July 5, 2020**

- Switched SPM output to static.
- Removed one deprecated method call.

## 2.2.3

- **June 26, 2020**

- No operational changes. Mostly documentation changes.

## 2.2.2

- **June 20, 2020**

- Added SPM support.
- Removed the demo projects from the workspace. They should not be there.

## 2.2.0

- **June 14, 2020**

- Fixed a small bug that could cause nasty problems. If the pickerview mode was selected, the picker could overflow the container, vertically.
- Integrated the two demo projects into the workspace.

## 2.1.8

- **May 8, 2020**

- Code refactoring to "modernize" the Swift, and control the scope. No operational changes.

## 2.1.7

- **September 17, 2019**

- Updated the Xcode version. Apple recommends that we use RC2 of Xcode 11. Might not make any difference, as this is a "build it on the spot" project.
- Fixed a minor typo in the README.

## 2.1.6

- **September 3, 2019**

- No operational changes. Simply made some tweaks to the podspec and the CHANGELOG, in the hopes that it will make CocoaPods happier.

## 2.1.5

- **September 3, 2019**

- Fixed a bug, where the spinner gesture recognizers could get deactivated if you opened and closed the control very quickly.

## 2.1.4

- **August 30, 2019**

- No operational change. Merely updated the docs to include Carthage.

## 2.1.3

- **May 27, 2019**

- Corrected errant code comments.
- Tweaked the README to use the new images.

## 2.1.2

- **April 12, 2019**

- Made the String argument to the data item struct optional. It isn't really necessary, so we shouldn't require it.
- Code documentation improvements.
- Some basic improvements to the way some stuff works in the spinner. Should be no visible changes.

## 2.1.1

- **April 5, 2019**

- Added a "Leak Test" test harness app, for testing for memory leaks.
- There was no change to the framework, but I need to increase the version for CocoaPods.

## 2.1.0

- **April 4, 2019**

- Adding the tabbed test harness app (tries the control in multiple scenarios).
- Added a real purdy splash screen.
- Changed the background in the basic test harness app.
- Changed the basic test harness app icon.
- Refactoring to make the project structure a bit more comprehensible.
- Continuing improvements on the documentation.
- Changed the icon source file to PDF -that's a better format.
- Added a "compensate for rotation" property. This allows the center to remain vertical, while the main control os rotated (via the superview).

## 2.0.3

- **April 2, 2019**

- Fixed a bug, in which the transparency overlay was off-kilter for odd-numbered datasets.

## 2.0.2

- **April 1, 2019**

- The data item struct is no longer Equatable. It didn't need to be, and the protocol conformance sucked.
- I'm ruthlessly going through the code, looking for weak spots and unnecessary cruft. There will be blood.

## 2.0.1

- **April 1, 2019**

- The pickerView wasn't reorganizing itself properly after a rotation.
- Raised the max flywheel velocity, and made the speed "cumulative," so it behaves a lot more like a normal flywheel.

## 2.0.0

- **April 1, 2019**

- Fixed an annoying auto-layout bug in the test harness that made the SE unusable.
- Improved the spinning animation.
- Removed the rotation feature. It was a nice idea, but was actually a lot more complicated than initially envisioned, and definitely not worth the agita and quality hit.
- Now make the icon display in the picker a bit more flexible.
- The leaks are gone. I suspect that my gutting the way the layers were set up did it.
- Had to reimplement the darn rotate notification, because of the new way I'm drawing stuff.
- Improved the openinng and closing animations.

## 1.0.7

- **March 31, 2019**

- Almost exclusively documentation changes.
- Added a couple of xcodeproj files for the two demo apps.
- This is the first "official" release of the pod.

## 1.0.6

- **March 31, 2019**

- Made the animations smoother.
- Removed the cache stuff. It is no longer necessary.
- Updated the documentation.
- Added the demo projects.

## 1.0.5

- **March 30, 2019**

- Rearranged the way the CALayers were being done to get rid of a "false positive" leak that happens when you keep a CALayer as an instance property.
- Removed the SwiftLint dependency, as it really isn't one.
- Made some of the code in the test harness app "swiftier," and improved code documentation.
- Added the ability to switch off the cache. This can reduce drawing artifacts, but makes the spinner look less "spinny."

## 1.0.4

- **March 30, 2019**

- Found a place where a notifier could get accidentally created (and not deactivated -bad), and made drastic improvements to the documentation.

## 1.0.3

- **March 30, 2019**

- A few minor display issues covered, and greatly enhanced support documentation.

## 1.0.0

- **March 29, 2019**

- Initial version.
