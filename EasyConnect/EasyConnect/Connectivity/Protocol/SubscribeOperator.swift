//
//  SubscribeOperator.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import CoreBluetooth
import Combine

public protocol SubscribeOperator {
    var centralDiscoveryPublisher: AnyPublisher <(CentralDiscoveryEventType, [CBPeripheral]), Never> { get set}
    var centralManagerStatusPublisher: AnyPublisher <CentralManagerStatus, Never> { get set}
    var pheripheralList: [CBPeripheral] {get set}
    func pheripheralWith(_ identifier: String) -> CBPeripheral?
}
