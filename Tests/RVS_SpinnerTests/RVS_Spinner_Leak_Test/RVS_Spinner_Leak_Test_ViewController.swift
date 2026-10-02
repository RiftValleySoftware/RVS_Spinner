//
//  ViewController.swift
//  RVS_Spinner_Leak_Test
//
//  Created by Chris Marshall on 4/5/19.
//  Copyright © 2019 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit
import RVS_Spinner

/* ###################################################################################################################################### */
// MARK: - The Lifetime Test Controller -

/* ###################################################################################################################################### */
/**
 Exercises popup cleanup and control lifetime interactively and under Instruments.

 Use Remove & Recreate while the wheel is spinning, or launch a Debug build with
 `--verify-spinner-leaks` for 100 temporary-control cycles followed by a release check.
 Weak-reference checks complement profiling; they do not inspect every heap allocation.
 */
class RVS_Spinner_Leak_Test_ViewController: UIViewController, RVS_SpinnerDelegate {

    /* ################################################################################################################################## */
    /**
     The currently displayed control, initially supplied by the storyboard and later replaced in code.
     */
    @IBOutlet var spinner: RVS_Spinner!

    /* ################################################################################################################################## */
    /**
     The decoded numeric image assets reused when creating a replacement control.
     */
    var spinnerValueItems: [RVS_SpinnerDataItem] = []

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Loads up to ten image assets, selects the middle item, and adds the Remove & Recreate button.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.delegate = self
        for index in 0..<10 {
            let imageName = "0" + String(index)
            if let image = UIImage(named: imageName) {
                let dataItem = RVS_SpinnerDataItem(title: imageName, icon: image)
                spinnerValueItems.append(dataItem)
            }
        }

        spinner.values = spinnerValueItems
        spinner.selectedIndex = spinnerValueItems.count / 2
        spinner.accessibilityLabel = "Leak test spinner"
        let recreate = UIButton(type: .system)
        recreate.setTitle("Remove & Recreate", for: .normal)
        recreate.setTitleColor(.label, for: .normal)
        recreate.addTarget(self, action: #selector(recreateSpinner), for: .touchUpInside)
        recreate.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recreate)
        NSLayoutConstraint.activate([
            recreate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recreate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }

    /* ################################################################## */
    /**
     Prevents the optional lifecycle stress loop from running more than once.
     */
    private var didVerify = false

    /* ################################################################## */
    /**
     Runs the requested Debug lifecycle stress loop after the view is in a window.

     Each cycle checks that removing an open temporary control also removes its sibling
     popup. The final recreation checks the displayed control's release asynchronously.

     - parameter animated: Whether UIKit animated the appearance.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if DEBUG
        guard !didVerify, ProcessInfo.processInfo.arguments.contains("--verify-spinner-leaks") else { return }
        didVerify = true
        let expectedSiblings = view.subviews.count
        for _ in 0..<100 {
            autoreleasepool {
                let candidate = RVS_Spinner(values: spinnerValueItems, frame: spinner.frame)
                candidate.isSoundOn = false
                candidate.isHapticsOn = false
                view.addSubview(candidate)
                candidate.isOpen = true
                candidate.isOpen = false
                candidate.isOpen = true
                candidate.removeFromSuperview()
                assert(view.subviews.count == expectedSiblings)
            }
        }
        recreateSpinner()
        #endif
    }

    /* ################################################################## */
    /**
     Removes the current control and recreates it with its items, frame, mode, colors, and selection.

     A weak capture checks release after half a second, allowing UIKit transactions and
     autorelease pools to drain. Use this during a spin to exercise display-link cleanup.
     The replacement starts closed and uses default sound and haptic settings.
     */
    @objc private func recreateSpinner() {
        let verifyRelease = { [weak previous = spinner] in
            if previous == nil {
                print("SPINNER LEAK CHECK PASSED: removed control released")
            } else {
                print("SPINNER LEAK CHECK FAILED: removed control is still retained")
                assertionFailure("The removed spinner is still retained")
            }
        }
        let rectangle = spinner.frame
        let mode = spinner.spinnerMode
        let tint = spinner.tintColor
        let background = spinner.backgroundColor
        let openBackground = spinner.openBackgroundColor
        let index = spinner.selectedIndex
        spinner.removeFromSuperview()
        spinner = nil
        let replacement = RVS_Spinner(values: spinnerValueItems, frame: rectangle)
        replacement.spinnerMode = mode
        replacement.tintColor = tint
        replacement.backgroundColor = background
        replacement.openBackgroundColor = openBackground
        replacement.selectedIndex = index
        replacement.delegate = self
        replacement.accessibilityLabel = "Leak test spinner"
        view.addSubview(replacement)
        spinner = replacement
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: verifyRelease)
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     Maps the selected segment to ring (-1), automatic (0), or picker (1) presentation.

     - parameter inSwitch: The presentation-mode selector.
     */
    @IBAction func switchHit(_ inSwitch: UISegmentedControl) {
        spinner.spinnerMode = inSwitch.selectedSegmentIndex - 1
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     An intentionally empty storyboard target/action hook for observing spinner events while profiling.
     */
    @IBAction func spinnerEvent(_: RVS_Spinner) {
    }

    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     An intentionally empty one-item activation callback; profiling adds no label updates.
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
    }

    /* ################################################################## */
    /**
     An intentionally empty selection callback; profiling adds no label updates.
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
    }

    /* ################################################################## */
    /**
     An intentionally empty opening callback used as a breakpoint location during profiling.
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
    }

    /* ################################################################## */
    /**
     An intentionally empty closing callback used as a breakpoint location during profiling.
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
    }
}
