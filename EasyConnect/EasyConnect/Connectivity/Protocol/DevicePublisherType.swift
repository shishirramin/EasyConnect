//
//  DevicePublisherType.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Combine
import CoreBluetooth

/// Protocol which defines events for Device status and device discovery
internal protocol DevicePublisherType {
    /**
     centralDiscoveryPublisher: listen to when peripheral is discovered
     */
    var centralDiscoveryPublisher: AnyPublisher <(CentralDiscoveryEventType, [CBPeripheral]), Never> { get }
    /**
     devicePublisher: listen to when appliance is associated or disassociated
     */
    var devicePublisher: AnyPublisher <(DeviceStatusEventType,CBPeripheral), Never> { get }
}

internal protocol DeviceStatusProviderType:  DevicePublisherType {
    func connect(_ peripheral: CBPeripheral)
    func scanForPeripherals()
    func stopScan()
    func removeUnPairedDevice()
    func cancelPeripheralConnection(_ peripheral: CBPeripheral)
}
