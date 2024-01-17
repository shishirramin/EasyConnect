//
//  NavigationBarConfigurable.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

/// Protocol which defines the custom navigation bar elements. Use this protocol to have customised navigation bar with titleview, right bar button items.
public protocol NavigationBarConfigurable {
    var rightBarButtonItems: [UIBarButtonItem] { get }
    /// method which set right bar button items for navigation bar like [excel, pdf, whatsapp etc]
    func setRightBarButtonItems()
    /// method which set custom title view with title and subtitle support for the navigation bar based on shouldUseDefaultTitle.
    func setTitleView(with title: String?, subtitle: String?, shouldUseDefaultTitle: Bool)
}

// MARK: Protocol default implimentation which can be used only by UIViewController type.
public extension NavigationBarConfigurable where Self: UIViewController {
    var rightBarButtonItems: [UIBarButtonItem] { return [] }

    func setRightBarButtonItems() {
        self.navigationItem.setRightBarButtonItems(self.rightBarButtonItems, animated: true)
    }

    func setTitleView(with title: String?, subtitle: String? = nil, shouldUseDefaultTitle: Bool) {
        guard !shouldUseDefaultTitle else {
            self.title = title
            return
        }
        guard let titleView = CustomNavigationTitleView.instanceFromNib() else {
            return
        }
        titleView.setUp(with: title, subTitle: subtitle)
        self.navigationItem.titleView = titleView
    }
}
