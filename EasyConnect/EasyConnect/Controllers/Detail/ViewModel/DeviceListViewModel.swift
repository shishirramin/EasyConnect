//
//  DeviceListViewModel.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Combine
import CoreBluetooth

protocol DeviceListControllerUpdater: NSObjectProtocol {
    func showController()
    func scanAnimation()
    func reloadData()
}

protocol DeviceListViewModelType: TableViewDataProtocol {
    func cancelSubscriber()
    func removeUnassociatedDevices()
    func refreshCentralStates(_ status: CentralManagerStatus?)
    func initiateScan(_ status:CentralManagerStatus?)
    func pair(periPeral:CBPeripheral)
}

final class DeviceListViewModel: DeviceListViewModelType {
    
    let connectionHub: ConnectivityHubType
    var applianceList: [CBPeripheral] = []
    private var discoveryEvent: AnyCancellable?
    var defaults: UserDefaultsHelper = UserDefaults.ecDefaults
    weak var delegate: DeviceListControllerUpdater?

    init(connectionHub: ConnectivityHubType = ConnectivityHub.shared,
         delegate: DeviceListControllerUpdater? = nil) {
        self.connectionHub = connectionHub
        self.delegate = delegate
        removeUnassociatedDevices()
        subscribe()
    }
    
    func cancelSubscriber() {
        discoveryEvent?.cancel()
    }
    
    func removeUnassociatedDevices() {
        connectionHub.removeUnPairedDevice()
    }
    
    func pair(periPeral:CBPeripheral) {
        connectionHub.pair(peripheral: periPeral)
    }
    
    private func subscribe() {
        discoveryEvent = connectionHub.centralDiscoveryPublisher
            .filter{ $0.0 == .didAdd }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.applianceList = self?.removeDuplicateAppliance(
                    from: $0.1, to: self?.applianceList ?? []
                ) ?? []
                self?.delegate?.reloadData()
            }
        //update UI
        delegate?.reloadData()
    }
    
    private func removeDuplicateAppliance(
        from updatedList: [CBPeripheral],
        to oldList: [CBPeripheral]
    ) -> [CBPeripheral] {
        var newList = oldList
        updatedList.forEach { newAppliance in
            newList = newList.filter { $0.identifier != newAppliance.identifier }
        }
        let newUpdatedList = updatedList.filter { ($0.state != .connected) }
        return newList + newUpdatedList
    }
    
    //MARK: Bluetooth Status
    
    func refreshCentralStates(_ status: CentralManagerStatus?) {
        initiateScan(status)
    }
    
    //MARK: ScanDevice
    func initiateScan(_ status:CentralManagerStatus?) {
        guard let theStatus = status else {
            return
        }
        if theStatus.authorization == .notDetermined ||  theStatus.authorization == .allowedAlways {
            startScan()
            delegate?.scanAnimation()
        } else {
            delegate?.showController()
        }
    }
    
    private func startScan() {
        connectionHub.startScan(config: ConnectivityConfigurations())
    }
}

extension DeviceListViewModel: TableViewDataProtocol {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(section: Int) -> Int {
        return applianceList.count
    }
    
    func dataForRowAt<T>(indexPath: IndexPath) -> T? {
        return applianceList[safe:indexPath.row] as? T
    }
}
