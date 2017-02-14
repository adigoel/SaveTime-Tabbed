//
//  AppDelegate.swift
//  Save Time Tabbed
//
//  Created by Aditya Goel on 13/01/2017.
//  Copyright © 2017 Aditya Goel. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate:UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("BACKGROUND")
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) {
            (granted,error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        print("Registered")
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Not available in simulator")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("RESIGN")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("ACTIVE")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("ACTIVE")

    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("TERMINATING")
        
        }
}
}

