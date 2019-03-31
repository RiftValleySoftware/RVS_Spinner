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
