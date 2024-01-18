//
//  UIViewController+Alert.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import UIKit

public extension UIViewController {
    /// An instance method to create an alert.
    /// - Parameters:
    ///   - title: string value for title.
    ///   - message: string value for message.
    ///   - options: string value for options.
    ///   - completion: a closure which takes Int as argument and returns void :( (Int) -> Void)
    /// - Returns: An instance of UIAlertController.
    func createAlert(title: String, message: String?,
                     options: [String],
                     completion: @escaping (Int) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option, style: .default) { _ in
                completion(index)
            })
        }
        return alertController
    }
}
