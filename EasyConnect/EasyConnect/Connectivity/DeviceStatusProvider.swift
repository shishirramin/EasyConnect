//
//  DeviceStatusProvider.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth
import Combine

internal class DeviceStatusProvider : NSObject, DevicePublisherType {
    var centralDiscoveryPublisher: AnyPublisher<(CentralDiscoveryEventType, [CBPeripheral]), Never>
    internal var centralDiscoveryEvents: PassthroughSubject <(CentralDiscoveryEventType, [CBPeripheral]), Never>
    internal var central: CBCentralConnectionProviderType
    var applianceList: [CBPeripheral] = []
    lazy var deviceStorage: PheriperalStorageType = PheriperalStorage()

    override init() {
        central = CBCentralProvider.shared
        centralDiscoveryEvents = PassthroughSubject<(CentralDiscoveryEventType, [CBPeripheral]), Never>()
        centralDiscoveryPublisher = centralDiscoveryEvents.eraseToAnyPublisher()
        super.init()
        central.connectionDelegate = self

    }
}

extension DeviceStatusProvider: DeviceConnectionProtocol {
    func didDiscover(peripheral: CBPeripheral) {
        centralDiscoveryEvents.send((.didAdd,applianceList))
    }
}
