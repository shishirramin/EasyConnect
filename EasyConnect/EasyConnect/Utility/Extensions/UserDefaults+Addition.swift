//
//  UserDefaults+Addition.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation

public extension UserDefaults {
    /// A static computed property to hold the UserDefaults shared instance.
    static var ecDefaults: UserDefaults {
        return UserDefaults(suiteName: "connect") ??
            UserDefaults.standard
    }
    /// A boolean value for the the key, if no value present or stored value is not bool returns Default value
    func bool(forKey: String, defaultValue: Bool = false) -> Bool {
        guard let value = object(forKey: forKey) as? Bool else {
            return defaultValue
        }
        return value
    }
}
