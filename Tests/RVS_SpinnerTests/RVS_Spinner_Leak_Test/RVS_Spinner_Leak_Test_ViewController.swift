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
// This is a completely simple app that is only meant to be used in "Profile" mode, for testing fundamental characteristics, like memory leaks.
/* ###################################################################################################################################### */
class RVS_Spinner_Leak_Test_ViewController: UIViewController, RVS_SpinnerDelegate {
    /* ################################################################################################################################## */
    @IBOutlet var spinner: RVS_Spinner!

    /* ################################################################################################################################## */
    var spinnerValueItems: [RVS_SpinnerDataItem] = []
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
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

    private var didVerify = false
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

    /// Use while the wheel is spinning to verify that removal stops work and releases the old control.
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
     */
    @IBAction func switchHit(_ inSwitch: UISegmentedControl) {
        spinner.spinnerMode = inSwitch.selectedSegmentIndex - 1
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    @IBAction func spinnerEvent(_: RVS_Spinner) {
    }
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, singleValueSelected: RVS_SpinnerDataItem?) {
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_: RVS_Spinner, hasSelectedTheValue: RVS_SpinnerDataItem?) {
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasOpenedWithTheValue: RVS_SpinnerDataItem?) {
    }
    
    /* ################################################################## */
    /**
     */
    func spinner(_ inSpinnerObject: RVS_Spinner, hasClosedWithTheValue: RVS_SpinnerDataItem?) {
    }
}
