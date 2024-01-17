//
//  Notifier.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth

protocol Notifier {
    func startNotifying()
}

protocol CBCentralAutorizationProviderType: Notifier {
    var delegate: AutorizationProtocol? { get set }
}

protocol CBCentralConnectionProviderType: Notifier {
    var connectionDelegate: DeviceConnectionProtocol? { get set }
    func scan()
    func connect(pheriperal:CBPeripheral)
    func unpair(pheriperal:CBPeripheral)
    func stopScan()
}

typealias CBCentralProviderType = CBCentralConnectionProviderType & CBCentralAutorizationProviderType
