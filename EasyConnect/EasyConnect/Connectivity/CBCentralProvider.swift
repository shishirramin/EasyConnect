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

    func scan() {
        central?.scanForPeripherals(withServices: nil,
                                    options: nil)
    }

    func connect(pheriperal: CBPeripheral) {
        central?.connect(pheriperal,
                         options: nil)
    }

    func unpair(pheriperal: CBPeripheral) {
        central?.cancelPeripheralConnection(pheriperal)
    }

    func stopScan() {
        central?.stopScan()
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
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        connectionDelegate?.didConnect(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        connectionDelegate?.didFailToConnect(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        connectionDelegate?.didDisconnect(peripheral: peripheral)
    }
}
