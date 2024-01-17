//
//  CBCentralProvider.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth

class CBCentralProvider: NSObject, CBCentralProviderType {
    public static let shared = CBCentralProvider()
    internal var central: CBCentralManagerProtocol?
    weak var delegate: AutorizationProtocol?
    weak var connectionDelegate: DeviceConnectionProtocol?

    func startNotifying() {
        guard central == nil else {
            return
        }
        let btQueue = DispatchQueue(label: "BT_queue")
        central = CBCentralManager(delegate: self, queue: btQueue, options: nil)
    }

}

extension CBCentralProvider: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.didUpdate(central: central)
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        connectionDelegate?.didDiscover(peripheral: peripheral)
    }
}
