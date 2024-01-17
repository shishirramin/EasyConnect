//
//  DeviceConnectionProtocol.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth

protocol DeviceConnectionProtocol: AnyObject {
    func didDiscover(peripheral: CBPeripheral)
    func didConnect(peripheral: CBPeripheral)
    func didFailToConnect(peripheral: CBPeripheral)
    func didDisconnect(peripheral: CBPeripheral)
}
