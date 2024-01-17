//
//  DevicesListViewController.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

final class DevicesListViewController: UIViewController, NavigationBarConfigurable {
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    private func configureUI() {
        self.setTitleView(with: "Devices", shouldUseDefaultTitle: true)
        self.tableView.registerCell(DeviceDetailTableViewCell.self)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        // Code to refresh table view
    }
    
    private func endRefreshing() {
        self.refreshControl.endRefreshing()
    }
}

//MARK: UITableview datasource and delegate methods
extension DevicesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deviceDetailCell: DeviceDetailTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//        deviceDetailCell.setUp(delegate: self)
        return deviceDetailCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
}

//MARK: Device detail cell delegate methods
extension DevicesListViewController: DeviceDetailTableViewCellDelegate {
    func didTapConnect(from cell: DeviceDetailTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        //TODO: Call connect method here.
        self.activityStartAnimating()
    }
}
