//
//  UserDefaultsHelper.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation
/// A protocol to work with UserDefaults.
public protocol UserDefaultsHelper {
    /// A method to get the object for specified key.
    /// - Parameter defaultName: name of for the key.
    /// - Returns : Any value.
    func object(forKey defaultName: String) -> Any?
    /// A method to set the value for specified key.
    /// - Parameter defaultName: name of for the key.
    /// value: any value.
    func set(_ value: Any?, forKey defaultName: String)
    /// A method to remove the object for specified key.
    /// - Parameter defaultName: name of for the key.
    func removeObject(forKey defaultName: String)
    /// A method to synchronize the UserDefault values.
    /// - Returns: A boolean value specifieng its succes or not?.
    func synchronize() -> Bool
    /// A method to check bool for key.
    /// - Returns: A boolean value for the the key,
    /// if no value present or stored value is not bool returns Default value
    func bool(forKey: String, defaultValue: Bool) -> Bool
}
extension UserDefaults: UserDefaultsHelper {}
