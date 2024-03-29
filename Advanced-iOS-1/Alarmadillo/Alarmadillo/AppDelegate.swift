//
//  AppDelegate.swift
//  Alarmadillo
//
//  Created by Nicholas McGinnis on 7/7/23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        
        if let navController = window?.rootViewController as? UINavigationController {
            if let viewController = navController.viewControllers[0] as? ViewController {
                center.delegate = viewController
            }
        }
        
        // create the three actions we want for uor alert
        let show = UNNotificationAction(identifier: "show", title: "Show Group", options: .foreground)
        let destroy = UNNotificationAction(identifier: "destroy", title: "Destroy Group", options: [.destructive, .authenticationRequired])
        let rename = UNTextInputNotificationAction(identifier: "rename", title: "Rename Group", options: [], textInputButtonTitle: "Rename", textInputPlaceholder: "Type the new name here")
        
        // wrap actions inside a category
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, rename, destroy], intentIdentifiers: [], options: [.customDismissAction])
        
        // register category with system
        center.setNotificationCategories([category])
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

