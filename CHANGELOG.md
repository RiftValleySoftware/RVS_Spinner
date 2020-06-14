# RVS_Spinner Change Log

## 2.2.0

- **June 14, 2020**

- Fixed a small bug that could cause nasty problems. If the pickerview mode was selected, the picker could overflow the container, vertically.

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
