//
//  AppDelegate.swift
//  EasyConnect
//
//  Created by Shishir Amin on 16/01/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    lazy var startupConfigurator = StartupConfigurator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        startupConfigurator.configureAndStart(application)
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        startupConfigurator.onApplicationWillEnterForeground()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        startupConfigurator.onApplicationDidEnterBackground()
    }
}

