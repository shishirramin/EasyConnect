//
//  CBCentralManagerProtocol.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth

protocol CBCentralManagerProtocol {
    var authorization: CBManagerAuthorization { get }
    var state: CBManagerState { get }
    func connect(
        _ peripheral: CBPeripheral,
        options: [String : Any]?
    )
    func cancelPeripheralConnection(_ peripheral: CBPeripheral)
}

extension CBCentralManager: CBCentralManagerProtocol {}
