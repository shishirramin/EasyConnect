//
//  UILabel+App.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

// MARK: UILable helper methods
public extension UILabel {
    func hideIfNoText() {
        guard let text = self.text else {
            self.isHidden = true
            return
        }
        self.isHidden = text.isEmpty
    }
}
