![Spinner Icon](https://riftvalleysoftware.com/RVS_Spinner/icon.png)

RVS_Spinner Control
=
This is a special control class that implements a "pop-up spinner" control.

You can associate an array of values with a Spinner, and they will be presented to the user when they tap the center of the control.

The control will pop up either a "fan" of values that can be scrolled like a knob, or a UIPickerView.

It is completely self-contained. You only need to instantiate the control, give it a place in the view (just like any other control), and associate a set of values with it.

The values should be accompanied by images.

The operation and appearance of the Spinner are highly customizable, either at runtime, or through IB Inspectable properties.

WHAT PROBLEM DOES THIS SOLVE?
=
Mobile devices present difficulties for things like shuttles and pickers. Apple's [UIPickerView](https://developer.apple.com/documentation/uikit/uipickerview) is an excellent approach to the problem of dynamic selection, but there are issues.

For one thing, UIPickerViews are BIG. They hog up a lot of precious screen real estate. This is necessary.

Also, they use the DataSource pattern, in which you supply the data at runtime, in a JIT manner. This is an excellent method, but it is rather complex. You sacrifice simplicity for power.

RVS_Spinner is a small icon, until it is touched and expanded. It is also designed to be operated by a thumb.

It also uses a fairly simple Array data provider. Simply associate an Array of structs to the control, and it's sorted.

WHERE TO GET
=
[This is available here, on CocoaPods.](https://cocoapods.org/pods/RVS_Spinner)

Just put:

    pod 'RVS_Spinner'
    
In your podfile.
    
[Here is the GitHub Repo for This Project.](https://github.com/RiftValleySoftware/RVS_Spinner)

[Here is the online documentation page for this project.](https://riftvalleysoftware.com/work/open-source-projects/#RVS_Spinner)

REQUIREMENTS
=
The Spinner is presented as a Swift-only shared dynamic framework, supporting iOS 11.0 and above.

This is meant for iOS (UIKit) only.

OPERATION
=
RADIAL SPINNER
-
The way it works, is that the "quiescent" control is small. By default, it is an oval or circle; possibly with an image or text in it, or just an image.

Tapping on the circle "pops up" a surrounding ring of images, which can be rotated about the center, like a prize wheel or a knob.

![Prize Wheel Display](https://riftvalleysoftware.com/RVS_Spinner/img/SpinnerPopup.gif)

This popup is a UIView that is opened in the superview of the center, so the superview must be able to support having a larger view added.

You can prescribe the radius of the popup or UIPickerView at runtime, or in the Interface Builder/Storyboard Editor. The sizes of the images will adjust to fit the circle.

You can control the open Spinner with gestures. It was designed to be thumb-controlled; including a "prize wheel" spinner, where you can send the control spinning in a decelerating rotation. The top (most visible) value is the one that will be selected. Tapping in a spinning control will stop it. You can also single-tap on either side of the open control to advance (decrement) the control by one.

PICKER VIEW VARIANT
-
You can also have a standard UIPickerView come up, which may be better for larger numbers of values, or for developers that prefer a more standard Apple User Experience.

![UIPickerView Wheel Display](https://riftvalleysoftware.com/RVS_Spinner/img/PickerPopup.gif)

IMPLEMENTATION
=
To use RVS_Spinner in your project, import the framework into your Swift 4.0 or above project. The main Spinner class is called "RVS_Spinner," and you can use this class in storyboards.

Unlike the UIPickerView, the Spinner is self-contained. You supply it an Array of RVS_SpinnerDataItem instances, which contain, at minimum, and icon (a UIImage), and a title (a String). These are displayed by the Spinner when it is opened.

The Spinner has a  RVS_Spinner.selectedIndex property that denotes which Array element is the selected value.

In order to use this in Interface Builder/Storyboard Editor, you need to drag in a UIView, then make it an instance of RVS_Spinner. The module will be RVS_Spinner.

INTERFACE BUILDER/STORYBOARD EDITOR OPTIONS
-
Once you assign the RVS_Spinner class to the UIView, a number of options will appear in the Attributes Inspector for the Spinner:

![The Spinner Attributes Inspector Options](https://riftvalleysoftware.com/RVS_Spinner/img/SpinnerOptions.png)

1. **Open Background Color**
This is a color to display behind the open radial spinner or picker. By default, it is clear.

2. **Rotation In Radians**
This is a radians (-π...π) value that rotates the open spinner (does not affect the picker)

3. **Spinner Mode**
This is an integer, with 3 values:
    - **-1** Use only the radial spinner (ignore the **Spinner Threshold** value).
    - **0**  Switch between radial spinner and the picker (based on the **Spinner Threshold** value).
    - **1**  Use only the picker (ignore the **Spinner Threshold** value).

4. **Spinner Threshold**
This is an integer, from 0 to whatever value you wish, that represents the point at which an Array of values switches from the radial spinner to the picker. This only applies when the **Spinner Mode** option is set o 0 (*both*).

5. **Is Sound On**
This specifies whether or not to use audible feedback. Sound will be disabled when the Alerts (ringer) setting is off.

6. **Is Haptics On**
This specifies whether or not to use haptic feedback (on devices that can play haptics).

Additionally, the View **Background** color is used to establish the color surrounding icons, and the **Tint** color is used to set the color of the borders around icons, and displayed text in the picker.

![How the Options Affect the Spinner](https://riftvalleysoftware.com/RVS_Spinner/img/OpenSpinner.png) ![How the Options Affect the Picker](https://riftvalleysoftware.com/RVS_Spinner/img/OpenPicker.png)

If the UIView Background Color is clear, and the UIView Tint is clear, the icons will be displayed slightly larger, with no surrounding ring (BTW: You can change the shape of the ring programattically. Circle/Oval is default).

If the Tint is clear, then the UIPickerView text will be black.

PROGRAMMATIC OPTIONS
-
One important part of the usage of RVS_Spinner is applying an Array of `RVS_SpinnerDataItem` instances.

This is a struct that contains an icon for display (a [UIImage](https://developer.apple.com/documentation/uikit/uiimage)) and a String (the title of the image). You can also optionally attach a more detailed description String to the data item.

In the spinner popup, only the image is shown, but in the PickerView variant, the text is also shown. Setting the text to "" will show only the image in the picker.

You can also attach any arbitrary data item to an instance of `RVS_SpinnerDataItem`. There is a property called `value`, which is an `Any?` property. You can associate any data that you want with an RVS_Spinner data item. Selecting the `value` calculated property of the RVS_Spinner instance will return the entire selected data item. These are copy items (structs), not reference items.

You need to provide this array programmatically. You assign it to the `values` property, and the data will be immediately available to use.

DELEGATE
-
The spinner uses a "delegate" pattern to interact with the implementation. You can choose to use the control without assigning a delegate, but having the delegate allows greater interaction and reactiveness.

TEST HARNESS APP
=
The test harness target uses the compiled framework, so it does provide a real-world application of RVS_Spinner.

It is a simple 1-view app, with a single window:

![The Test Harness Screen](https://riftvalleysoftware.com/RVS_Spinner/img/TestHarnessScreen.gif)

The controls operate in real time on the instance of RVS_Spinner, displayed above the control panel:

The red "Associated Text" is a label that displays test data that was associated with each of 20 data items used for testing. The `value` property of each item was set to a String, which is displayed as that item is selected.

The "Spinner/Picker Threshold" Segmented Switch will affect the "Spinner Threshold" property, described above. It is only enabled for the "Both" Spinner Mode (discussed below)

The "Haptics" and "Sound" switches control whether or not each of those properties is on.

The "Rotation" slider controls a +- rotation of the spinner control, and affects the "Rotation In Radians" value, discussed above.

Below that, is the Spinner Mode Segmented Switch. If "Spinner-Only" is selected, then the control will ONLY pop up with a spinner; regardless of how many values are provided in the `values` array property. The "Spinner/Picker Threshold" Segmented Switch is disabled if this is selected.

If "Picker-Only" is selected, then only the Picker will be displayed. The "Spinner/Picker Threshold" Segmented Switch is also disabled.

If "Both" is selected, the "Spinner/Picker Threshold" Segmented Switch is enabled, and describes a number of values that change the behavior of the RVS_Spinner instance from a spinner popup to a picker popup.

The "Border and Text Color" Segmented Switch has some presets that are applied to the `UIView.tint` property.

The "Open Control Background Color" Segmented Switch affects the "Open Background Color" property, discussed above.

The "Center Background Color" Segmented Switch affects the `UIView.backgroundColor` property.

The "Number of Values" Segmented Switch applies a subset of up to 20 available values to the control.

The test harness app is deliberately simple, and should provide an excellent "starting point" for using the RVS_Spinner.
