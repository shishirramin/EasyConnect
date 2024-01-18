//
//  UIApplicationType.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import UIKit

public protocol UIApplicationType: AnyObject {
    var applicationState: UIApplication.State { get }
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any],
              completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: UIApplicationType {}
