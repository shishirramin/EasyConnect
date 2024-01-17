//
//  ConnectivityHub.swift
//  Connect
//
//  Created by Shishir Amin on 16/01/24.
//

import Foundation

import Foundation
import Combine
import CoreBluetooth

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
    public var pheripheralList: [CBPeripheral] = []
    public static let shared = ConnectivityHub()
    public var bleStatus: CentralManagerStatus
    lazy var bleStatusProvider: BluetoothStatusProviderType = BluetoothStatusProvider()
    lazy var deviceStatusProvider: DevicePublisherType = DeviceStatusProvider()
    private var centralManagerStatusEvents: PassthroughSubject <CentralManagerStatus, Never>
    public var centralManagerStatusPublisher: AnyPublisher <CentralManagerStatus, Never>
    private var cancellableSet: Set<AnyCancellable> = []
    public var centralDiscoveryPublisher: AnyPublisher <(CentralDiscoveryEventType, [CBPeripheral]), Never>
    private var centralDiscoveryEvents: PassthroughSubject <(CentralDiscoveryEventType, [CBPeripheral]), Never>

    init(bleStatus:CentralManagerStatus = CentralManagerStatus(),
         configuration: ConnectivityConfigurations = ConnectivityConfigurations()) {
        self.bleStatus = bleStatus
        self.configuration = configuration
        centralManagerStatusEvents = PassthroughSubject<CentralManagerStatus, Never>()
        centralManagerStatusPublisher = centralManagerStatusEvents.eraseToAnyPublisher()
        centralDiscoveryEvents = PassthroughSubject<(CentralDiscoveryEventType, [CBPeripheral]), Never>()
        centralDiscoveryPublisher = centralDiscoveryEvents.eraseToAnyPublisher()
        subscribeCentralManager()
    }

    func subscribeCentralManager() {
        deviceStatusProvider.centralDiscoveryPublisher.sink { [weak self] eventType, appliances  in
            self?.handleDiscoveryEvent(eventType, appliances)
            self?.centralDiscoveryEvents.send((eventType, appliances))
        }
        .store(in: &cancellableSet)
    
        bleStatusProvider.statusPublisher.sink { [weak self] in
            self?.bleStatus.state = $0.powerOn
            self?.bleStatus.authorization = $0.authorization
            self?.updateBleStatus()
        }
        .store(in: &cancellableSet)
    }

    private func handleDiscoveryEvent(_ eventType: CentralDiscoveryEventType, _ appliances: [CBPeripheral]) {
        if eventType == .didAdd {
            pheripheralList.append(contentsOf: appliances)
        } else {
            pheripheralList.removeAll { appliance in
                pheripheralList.contains { $0.identifier == appliance.identifier }
            }
        }
    }

    private func updateBleStatus() {
        centralManagerStatusEvents.send(bleStatus)
    }
    
    public func stopScan() {
        //implement actual method here
    }
    
    public func pair() {
        
    }
    
    public func cancelPairingRequest() {
        //implement actual method here
    }
    
    public func startScan(config: ConnectivityConfigurations) {
        bleStatusProvider.startNotifying()
    }
}
