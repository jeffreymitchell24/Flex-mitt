//
//  AppDelegate.swift
//  flex-mitt
//
//  Created by Admin on 4/7/17.
//  Copyright © 2017 Flex-Sports. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var bgTask: UIBackgroundTaskIdentifier = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.isIdleTimerDisabled = true // turn off screen sleep
        
        Fabric.with([Crashlytics.self])
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        bgTask = 0
        bgTask = application.beginBackgroundTask(withName: "BackgroundTask") { [weak self] () -> Void in
            // Time is up.
            self?.bgTask = UIBackgroundTaskInvalid
//            if self?.bgTask != UIBackgroundTaskInvalid {
//                // Do something to stop our background task or the app will be killed
//                finished = true
//            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.endBackgroundTask(bgTask)
    }
}
