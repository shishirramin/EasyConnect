//
//  UIView+App.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

extension UIView {
    /// Method which adds card view shadow effect to the view.
    func applyCardViewEffect(cornerRadius: CGFloat = 4.0,
                             color: UIColor = UIColor.black.withAlphaComponent(0.2),
                             shadowRadius: CGFloat = 2.0,
                             shadowOffset: CGSize = CGSize(width: 0.0, height: 1.0),
                             position: CGPoint? = nil) {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.position = position ?? self.center
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
    }
    
}
