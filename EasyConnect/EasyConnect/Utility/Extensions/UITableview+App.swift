//
//  UITableview+App.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

/// Extension method which provides a generic approach to register and dequeue the table view cell and header footerview
extension UITableView {
    func registerCell<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        self.register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    fileprivate func registerCell(_ bundle: Bundle?,
                                  nibName: String,
                                  reuseIdentifier: String) {
        guard let theBundle = bundle else {
            return
        }
        let nib = UINib(nibName: nibName, bundle: theBundle)
        register(nib, forCellReuseIdentifier: reuseIdentifier)
    }

    func registerCell<T: UITableViewCell>(_: T.Type) where T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        registerCell(bundle,
                     nibName: T.nibName,
                     reuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerCellForIdentifier(string: String,
                                   bundle: Bundle? = nil) {
        registerCell(bundle,
                     nibName: string,
                     reuseIdentifier: string)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        return self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
}

