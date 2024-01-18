//
//  DetailsViewController.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import UIKit

class DetailsViewController: UIViewController, NavigationBarConfigurable {
    var rightBarButtonItems: [UIBarButtonItem] = []
    
    private func configureUI() {
        self.setTitleView(with: "Devices Detail", shouldUseDefaultTitle: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}
