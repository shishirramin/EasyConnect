//
//  AppDelegate.swift
//  EasyConnect
//
//  Created by Shishir Amin on 16/01/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let provider: CBCentralProviderType = CBCentralProvider.shared
        provider.startNotifying()
        return true
    }

}

