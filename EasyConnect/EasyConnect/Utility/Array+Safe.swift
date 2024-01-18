//
//  Array+Safe.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
