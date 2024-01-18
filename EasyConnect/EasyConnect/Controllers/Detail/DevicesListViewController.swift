//
//  DevicesListViewController.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import UIKit
import Combine
import CoreBluetooth

final class DevicesListViewController: UIViewController, NavigationBarConfigurable {
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var alertShown = false
    var defaults: UserDefaultsHelper = UserDefaults.ecDefaults
    var uiApplication : UIApplicationType = UIApplication.shared
    private var cancellableSet: Set<AnyCancellable> = []
    private lazy var connectionHub : ConnectivityHub = ConnectivityHub.shared
    let center = NotificationCenter.default
    private lazy var viewModel: DeviceListViewModelType = DeviceListViewModel(delegate: self)

    var status: CentralManagerStatus? {
        didSet {
            refreshCentralStates()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initiateScan(connectionHub.bleStatus)
    }
    
    private func configureUI() {
        self.setTitleView(with: "Devices", shouldUseDefaultTitle: true)
        self.tableView.registerCell(DeviceDetailTableViewCell.self)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    private func refreshCentralStates() {
        guard let status =  status else {
            return
        }
        DispatchQueue.executeOnMainThread {
            self.viewModel.refreshCentralStates(status)
        }
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        viewModel.initiateScan(connectionHub.bleStatus)

    }
    
    private func endRefreshing() {
        self.refreshControl.endRefreshing()
    }
    
    // show permission settings page if access denied
    func showControllers() {
        guard !alertShown else {
            return
        }
        alertShown = true
        // if bluetooth
        if defaults.object(forKey: UserDefaultsConstants.bleStatus) == nil {
            defaults.set(BleAuthorization.denied.rawValue, forKey: UserDefaultsConstants.bleStatus)
            showAlert()
        } else {
            showBlueToothPermissionAlert()
        }
    }
    
    private func showBlueToothPermissionAlert() {
        let alert = createAlert(title:"Bluetooth permission",
                                message:"Turn on Bluetooth in phone settings to enable device pairing.",
                                options: ["Not now",
                                "Go to settings"]) {
            [weak self](index) in
            self?.showUIBasedOn(index)
        }
        navigationController?.present(alert, animated: false,
                                      completion: nil)
    }
    
    func showUIBasedOn(_ index:Int)  {
        if index == 1 {
            alertShown = false
            redirectToOpen(urlString: UIApplication.openSettingsURLString)
        } else {
            showAlert()
        }
    }

    func showAlert() {
        let alert = createAlert(title: "That's Alright",
                    message: "Turn the bluetooth permission when required",
                    options: []) { index in
        }
        navigationController?.present(alert,
                                      animated: false,
                                      completion: nil)

    }
    
    func redirectToOpen(urlString: String) {
        guard let url = URL(string: urlString), uiApplication.canOpenURL(url) else {
            return
        }
        uiApplication.open(url, options: [:], completionHandler: nil)
    }
    
    private func subscribe() {
        
        //observe for central manager changed events
        connectionHub.centralManagerStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.status =  status
            }
            .store(in: &cancellableSet)

        connectionHub.deviceStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink {  [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellableSet)
        //observe for app enter foreground
        center.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.viewModel.refreshCentralStates(strongSelf.status)
            }
            .store(in: &cancellableSet)
    }
}

//MARK: UITableview datasource and delegate methods
extension DevicesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section:section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deviceDetailCell: DeviceDetailTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let cellData: DeviceDetailConfigurable? = viewModel.dataForRowAt(indexPath: indexPath)
        deviceDetailCell.setUp(viewModel: cellData,
                               delegate: self)
        return deviceDetailCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(at: indexPath)
    }
}

//MARK: Device detail cell delegate methods
extension DevicesListViewController: DeviceDetailTableViewCellDelegate {
    func didTapConnect(from cell: DeviceDetailTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        guard let data: CBPeripheral? = viewModel.dataForRowAt(indexPath: indexPath),
        let theDevice = data else {
            return
        }
        viewModel.pair(periPeral: theDevice)
        //TODO: Call connect method here.
        self.activityStartAnimating()
    }
}

//MARK: DeviceListControllerUpdater methods
extension DevicesListViewController : DeviceListControllerUpdater {
    func reloadData() {
        DispatchQueue.executeOnMainThread { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    func showController() {
        DispatchQueue.executeOnMainThread { [weak self] in
            self?.showController()
        }
    }
    
    func scanAnimation() {
        // implement scanner on scanning
    }
    
}
