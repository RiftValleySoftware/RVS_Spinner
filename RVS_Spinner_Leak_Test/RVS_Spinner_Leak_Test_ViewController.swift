//
//  ViewController.swift
//  RVS_Spinner_Leak_Test
//
//  Created by Chris Marshall on 4/5/19.
//  Copyright © 2019 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit
import RVS_Spinner

class RVS_Spinner_Leak_Test_ViewController: UIViewController, RVS_SpinnerDelegate {
    @IBOutlet var spinner: RVS_Spinner!
    
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
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
