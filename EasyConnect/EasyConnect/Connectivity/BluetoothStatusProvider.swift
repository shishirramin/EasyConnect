//
//  BluetoothStatusProvider.swift
//  Connect
//
//  Created by Shishir Amin on 16/01/24.
//

import CoreBluetooth
import Combine

///Class which provides update on bluetooth state changes and Autorization
internal class BluetoothStatusProvider : NSObject, BluetoothStatusProviderType {
    internal var central: CBCentralAutorizationProviderType
    var status = BluetoothStatus() {
        didSet {
            statusChangeEvents.send(status)
        }
    }
    var statusPublisher: AnyPublisher<BluetoothStatus, Never>
    private var statusChangeEvents: PassthroughSubject <BluetoothStatus, Never>

    override init() {
        central = CBCentralProvider.shared
        statusChangeEvents = PassthroughSubject<BluetoothStatus, Never>()
        statusPublisher = statusChangeEvents.eraseToAnyPublisher()
        super.init()
        central.delegate = self
    }

    func startNotifying() {
        central.startNotifying()
    }

}

extension BluetoothStatusProvider: AutorizationProtocol {
    func didUpdate(central: CBCentralManagerProtocol) {
        status = BluetoothStatus(powerOn: isPoweredOn(central),
                                           authorization: autorizationFor(central))
    }
}

extension BluetoothStatusProvider {
    func isPoweredOn(_ central: CBCentralManagerProtocol) -> Bool {
        central.state == .poweredOn
    }

    func autorizationFor(_ central: CBCentralManagerProtocol) -> BleAuthorization {
            return central.authorization.autorization()
    }
}

public struct CentralManagerStatus: Equatable {
    public var state: Bool = false
    public var authorization: BleAuthorization = .notDetermined
    public var isScanning: Bool = false
}

