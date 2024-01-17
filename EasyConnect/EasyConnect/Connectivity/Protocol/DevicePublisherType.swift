//
//  DevicePublisherType.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Combine
import CoreBluetooth

internal protocol DevicePublisherType {
    var centralDiscoveryPublisher: AnyPublisher <(CentralDiscoveryEventType, [CBPeripheral]), Never> { get }
}
