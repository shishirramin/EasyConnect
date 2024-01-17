//
//  CustomNavigationTitleView.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Foundation

import UIKit

/// Custom title view for navigation bar title view so that title and subtitle will be left aligned as per the design.
final class CustomNavigationTitleView: UIView, NibLoadableView {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subTitleLabel: UILabel!

    /// Create an instance of the class from its .xib
    class func instanceFromNib() -> CustomNavigationTitleView? {
        return UINib(nibName: self.nibName, bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as? CustomNavigationTitleView
    }

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }

    private func applyTheme() {
        self.titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        self.titleLabel.textColor = .black
        self.titleLabel.text = ""

        self.subTitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        self.subTitleLabel.textColor = .lightText
        self.subTitleLabel.text = ""
    }

    func setUp(with title: String?, subTitle: String?) {
        self.titleLabel.text = title ?? ""
        self.subTitleLabel.text = subTitle ?? ""
        // hide the labels if there is no text, so that stackiview will rearrange accordingly.
        self.titleLabel.hideIfNoText()
        self.subTitleLabel.hideIfNoText()
    }
}
