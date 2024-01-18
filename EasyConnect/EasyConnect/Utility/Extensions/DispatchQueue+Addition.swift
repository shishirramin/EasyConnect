//
//  DispatchQueue+Addition.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation

extension DispatchQueue {
    public static func executeOnMainThread(_ execute: @escaping (() -> Void)) {
        if Thread.isMainThread {
            execute()
        } else {
            DispatchQueue.main.async(execute: execute)
        }
    }
}
