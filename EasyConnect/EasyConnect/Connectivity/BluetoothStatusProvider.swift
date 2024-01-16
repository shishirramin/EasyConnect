//
//  BluetoothStatusProvider.swift
//  Connect
//
//  Created by Shishir Amin on 16/01/24.
//

import CoreBluetooth
import Combine

internal protocol BluetoothStatusProviderType {
    var statusPublisher: AnyPublisher <BluetoothStatus, Never> { get }
    func startNotifying()
}

struct BluetoothStatus {
    public var powerOn: Bool = false
    public var authorization: BleAuthorization = .notDetermined
}

public enum BleAuthorization : Int {
    case notDetermined
    case denied
    case allowedAlways
}

internal class BluetoothStatusProvider : NSObject, BluetoothStatusProviderType {
    internal var central: CBCentralManagerProtocol?
    var status = BluetoothStatus() {
        didSet {
            statusChangeEvents.send(status)
        }
    }
    var statusPublisher: AnyPublisher<BluetoothStatus, Never>
    private var statusChangeEvents: PassthroughSubject <BluetoothStatus, Never>

    override init() {
        statusChangeEvents = PassthroughSubject<BluetoothStatus, Never>()
        statusPublisher = statusChangeEvents.eraseToAnyPublisher()
        super.init()
    }

    func startNotifying() {
        guard central == nil else {
            return
        }
        let btQueue = DispatchQueue(label: "BT_queue")
        central = CBCentralManager(delegate: self, queue: btQueue, options: nil)
    }

}

extension BluetoothStatusProvider: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
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

protocol CBCentralManagerProtocol {
    var authorization: CBManagerAuthorization { get }
    var state: CBManagerState { get }
}

extension CBCentralManager: CBCentralManagerProtocol {}

extension CBManagerAuthorization {
    func autorization() -> BleAuthorization{
        let authorization : BleAuthorization
        switch self {
        case .allowedAlways:
            authorization = .allowedAlways
        case .notDetermined:
            authorization = .notDetermined
        default:
            authorization = .denied
        }
        return authorization
    }
}

public struct CentralManagerStatus: Equatable {
    public var state: Bool = false
    public var authorization: BleAuthorization = .notDetermined
    public var isScanning: Bool = false
}
