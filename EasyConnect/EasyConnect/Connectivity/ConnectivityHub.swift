//
//  ConnectivityHub.swift
//  Connect
//
//  Created by Shishir Amin on 16/01/24.
//

import Foundation

import Foundation
import Combine

public struct ConnectivityConfigurations: Equatable {
    public let scanTimeOut: Bool
    public let scanDuration: Double
    public init(
        scanTimeOut: Bool = true,
        scanDuration: Double = TimeInterval(120)
    ) {
        self.scanTimeOut = scanTimeOut
        self.scanDuration = scanDuration
    }
}

public protocol ConnectivityHubType {
    func stopScan()
    func cancelPairingRequest()
    func startScan(config: ConnectivityConfigurations)
    var  bleStatus: CentralManagerStatus { get }
    var  configuration: ConnectivityConfigurations { get set }
}

public class ConnectivityHub: ConnectivityHubType {
    public var configuration: ConnectivityConfigurations
    
    public static let shared = ConnectivityHub()
    public var bleStatus: CentralManagerStatus
    lazy var bleStatusProvider:BluetoothStatusProviderType = BluetoothStatusProvider()

    init(bleStatus:CentralManagerStatus = CentralManagerStatus(),
         configuration: ConnectivityConfigurations = ConnectivityConfigurations()) {
        self.bleStatus = bleStatus
        self.configuration = configuration
    }
    
    public func stopScan() {
        //implement actual method here
    }
    
    public func cancelPairingRequest() {
        //implement actual method here
    }
    
    public func startScan(config: ConnectivityConfigurations) {
        //implement actual method here
    }
}
