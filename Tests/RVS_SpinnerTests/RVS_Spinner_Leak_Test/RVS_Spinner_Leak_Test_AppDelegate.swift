//
//  AppDelegate.swift
//  RVS_Spinner_Leak_Test
//
//  Created by Chris Marshall on 4/5/19.
//  Copyright © 2019 Little Green Viper Software Development LLC. All rights reserved.
//

import UIKit

/* ###################################################################################################################################### */
/**
 The application entry point for the lifetime harness.

 UIKit creates the storyboard interface through the window scene configured in the app's Info.plist.
 */
@main
class RVS_Spinner_Leak_Test_AppDelegate: UIResponder, UIApplicationDelegate {
}

/* ###################################################################################################################################### */
/**
 Owns the storyboard window for one harness scene.

 Each harness defines this class in its own module; these are separate app types.
 */
class HarnessSceneDelegate: UIResponder, UIWindowSceneDelegate {

    /* ################################################################## */
    /**
     The window supplied by UIKit when it connects the storyboard scene.
     */
    var window: UIWindow?
}
