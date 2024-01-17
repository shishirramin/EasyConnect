//
//  UIViewController+App.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

extension UIViewController {
    
    func activityStartAnimating() {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        
        self.view.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = self.view.viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.view.isUserInteractionEnabled = true
    }
}
