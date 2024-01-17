//
//  ReusableView.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

/// Protocol which provides the reuse identifiers for the list views
public protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

/// Protocol which provides the nib name for the list views which is loaded from nibs.
public protocol NibLoadableView: ReusableView {
    static var nibName: String { get }
}

public extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
