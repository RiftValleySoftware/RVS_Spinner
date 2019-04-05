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
