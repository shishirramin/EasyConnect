//
//  ViewController.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit

class ViewController: UIViewController, NavigationBarConfigurable {
    @IBOutlet private weak var tableView: UITableView!
    lazy private var viewModel = HomeViewModel()
    internal var rightBarButtonItems: [UIBarButtonItem] {
        return [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onTappingAdd))]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    private func configureUI() {
        self.setTitleView(with: "Home", shouldUseDefaultTitle: true)
        self.tableView.registerCell(HomeTableViewCell.self)
        self.setRightBarButtonItems()
    }
    
    //MARK: Bar button items action methods
    @objc func onTappingAdd() {
        let devicesListViewController = DevicesListViewController()
        self.navigationController?.pushViewController(devicesListViewController, animated: true)
    }
}

//MARK: UITableview datasource and delegate methods
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let homeDetailCell: HomeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data: DeviceDetailConfigurable? = viewModel.dataForRowAt(indexPath: indexPath)
        homeDetailCell.setUp(viewModel: data)
        return homeDetailCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(at: indexPath)
    }
}
