//
//  NibLoadingView.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

protocol NibDesignableProtocol: NSObjectProtocol {
    /**
     Identifies the view that will be the superview of the contents loaded from
     the Nib. Referenced in setupNib().
     - returns: Superview for Nib contents.
     */
    var nibContainerView: UIView { get }
    // MARK: - Nib loading
    /**
     Called to load the nib in setupNib().
     - returns: UIView instance loaded from a nib file.
     */
    func loadNib() -> UIView
    /**
     Called in the default implementation of loadNib(). Default is class name.
     - returns: Name of a single view nib file.
     */
    func nibName() -> String
}

extension NibDesignableProtocol {
    // MARK: - Nib loading
    /**
     Called to load the nib in setupNib().
     - returns: UIView instance loaded from a nib file.
     */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName(), bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    }

    // MARK: - Nib loading
    /**
     Called in init(frame:) and init(aDecoder:) to load the nib and add it as a subview.
     */
    fileprivate func setupNib() {
        let view = self.loadNib()
        self.nibContainerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: bindings))
        self.nibContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: bindings))
    }
}

extension UIView {
    var nibContainerView: UIView {
        return self
    }
    /**
     Called in the default implementation of loadNib(). Default is class name.
     - returns: Name of a single view nib file.
     */
    public func nibName() -> String {
        return type(of: self).description().components(separatedBy: ".").last!
    }
}

open class NibLoadingView: UIView, NibDesignableProtocol {

    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib()
    }

    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib()
    }
}
