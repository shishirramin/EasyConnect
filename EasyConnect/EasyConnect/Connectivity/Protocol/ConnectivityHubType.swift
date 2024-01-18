//
//  ConnectivityHubType.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import CoreBluetooth

public protocol ConnectivityHubType: SubscribeOperator {
    func stopScan()
    func cancelPairingRequest(peripheral: CBPeripheral)
    func startScan(config: ConnectivityConfigurations)
    func pair(peripheral: CBPeripheral)
    func autoConnect()
    func removeUnPairedDevice()
    var  bleStatus: CentralManagerStatus { get }
    var  configuration: ConnectivityConfigurations { get set }
}
