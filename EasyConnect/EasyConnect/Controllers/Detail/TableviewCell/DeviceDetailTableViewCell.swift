//
//  DeviceDetailTableViewCell.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

protocol DeviceDetailTableViewCellDelegate: AnyObject {
    func didTapConnect(from cell: DeviceDetailTableViewCell)
}

final class DeviceDetailTableViewCell: UITableViewCell, NibLoadableView {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var connectButton: UIButton!
    @IBOutlet private weak var bgView: UIView!
    
    private weak var delegate: DeviceDetailTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyTheme()
    }
    
    private func applyTheme() {
        self.titleLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        self.descriptionLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        self.connectButton.setTitleColor(.white, for: .normal)
        self.connectButton.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .bold)
        self.connectButton.backgroundColor = UIColor(hex: "#0390fc")
        self.connectButton.setTitle("Connect", for: .normal)
        self.connectButton.layer.cornerRadius = 4.0
        self.bgView.applyCardViewEffect()
    }
    
    func setUp(viewModel: DeviceDetailConfigurable?,
               delegate: DeviceDetailTableViewCellDelegate?) {
        self.titleLabel.text = viewModel?.title
        self.descriptionLabel.text = viewModel?.subTitle
        self.delegate = delegate
    }
    
    //MARK: Button actions
    @IBAction private func onTappingConnectCta(_ sender: Any) {
        self.delegate?.didTapConnect(from: self)
    }
}
