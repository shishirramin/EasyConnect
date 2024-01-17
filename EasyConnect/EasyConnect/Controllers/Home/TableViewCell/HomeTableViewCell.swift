//
//  HomeTableViewCell.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

final class HomeTableViewCell: UITableViewCell, NibLoadableView {
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }
    
    private func applyTheme() {
        self.titleLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        self.descriptionLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        self.bgView.applyCardViewEffect()
    }
    
    func setUp(viewModel: DeviceDetailConfigurable?) {
        self.titleLabel.text = viewModel?.title
        self.descriptionLabel.text = viewModel?.subTitle
    }
}
