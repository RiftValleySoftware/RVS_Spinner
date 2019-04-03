*Version 2.1.0* **TBD**
- Adding the tabbed test harness app (tries the control in multiple scenarios).
- Added a real purdy splash screen.
- Changed the background in the basic test harness app.
- Changed the basic test harness app icon.
- Changed the icon source file to PDF -that's a better format.
- Added a "compensate for rotation" property. This allows the center to remain vertical, while the main control os rotated (via the superview).

*Version 2.0.3* **April 2, 2019**
- Fixed a bug, in which the transparency overlay was off-kilter for odd-numbered datasets.

*Version 2.0.2* **April 1, 2019**
- The data item struct is no longer Equatable. It didn't need to be, and the protocol conformance sucked.
- I'm ruthlessly going through the code, looking for weak spots and unnecessary cruft. There will be blood.

*Version 2.0.1* **April 1, 2019**
- The pickerView wasn't reorganizing itself properly after a rotation.
- Raised the max flywheel velocity, and made the speed "cumulative," so it behaves a lot more like a normal flywheel.

*Version 2.0.0* **April 1, 2019**
- Fixed an annoying auto-layout bug in the test harness that made the SE unusable.
- Improved the spinning animation.
- Removed the rotation feature. It was a nice idea, but was actually a lot more complicated than initially envisioned, and definitely not worth the agita and quality hit.
- Now make the icon display in the picker a bit more flexible.
- The leaks are gone. I suspect that my gutting the way the layers were set up did it.
- Had to reimplement the darn rotate notification, because of the new way I'm drawing stuff.
- Improved the openinng and closing animations.

*Version 1.0.7* **March 31, 2019**
- Almost exclusively documentation changes.
- Added a couple of xcodeproj files for the two demo apps.
- This is the first "official" release of the pod.

*Version 1.0.6* **March 31, 2019**
- Made the animations smoother.
- Removed the cache stuff. It is no longer necessary.
- Updated the documentation.
- Added the demo projects.

*Version 1.0.5* **March 30, 2019**
- Rearranged the way the CALayers were being done to get rid of a "false positive" leak that happens when you keep a CALayer as an instance property.
- Removed the SwiftLint dependency, as it really isn't one.
- Made some of the code in the test harness app "swiftier," and improved code documentation.
- Added the ability to switch off the cache. This can reduce drawing artifacts, but makes the spinner look less "spinny."

*Version 1.0.4* **March 30, 2019**
- Found a place where a notifier could get accidentally created (and not deactivated -bad), and made drastic improvements to the documentation.

*Version 1.0.3* **March 30, 2019**
- A few minor display issues covered, and greatly enhanced support documentation.

*Version 1.0.0* **March 29, 2019**
- Initial version.
