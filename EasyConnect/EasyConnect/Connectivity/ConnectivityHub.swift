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
    func cancelPairingRequest(peripheral: CBPeripheral)
    func startScan(config: ConnectivityConfigurations)
    func pair(peripheral: CBPeripheral)
    var  bleStatus: CentralManagerStatus { get }
    var  configuration: ConnectivityConfigurations { get set }
}

public class ConnectivityHub: ConnectivityHubType {
    public var configuration: ConnectivityConfigurations
    public var pheripheralList: [CBPeripheral] = []
    public static let shared = ConnectivityHub()
    public var bleStatus: CentralManagerStatus
    
    private var centralManagerStatusEvents: PassthroughSubject <CentralManagerStatus, Never>
    public var centralManagerStatusPublisher: AnyPublisher <CentralManagerStatus, Never>
    public var centralDiscoveryPublisher: AnyPublisher <(CentralDiscoveryEventType, [CBPeripheral]), Never>
    private var centralDiscoveryEvents: PassthroughSubject <(CentralDiscoveryEventType, [CBPeripheral]), Never>
    private var scanTimer: Timer?
    private var cancellableSet: Set<AnyCancellable> = []

    lazy var bleStatusProvider: BluetoothStatusProviderType = BluetoothStatusProvider()
    lazy var deviceStatusProvider: DeviceStatusProviderType = DeviceStatusProvider()

    init(bleStatus:CentralManagerStatus = CentralManagerStatus(),
         configuration: ConnectivityConfigurations = ConnectivityConfigurations()) {
        self.bleStatus = bleStatus
        self.configuration = configuration
        centralManagerStatusEvents = PassthroughSubject<CentralManagerStatus, Never>()
        centralManagerStatusPublisher = centralManagerStatusEvents.eraseToAnyPublisher()
        centralDiscoveryEvents = PassthroughSubject<(CentralDiscoveryEventType, [CBPeripheral]), Never>()
        centralDiscoveryPublisher = centralDiscoveryEvents.eraseToAnyPublisher()
        bleStatusProvider.startNotifying()
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
        guard bleStatus.isScanning  else {
            return
        }
        bleStatus.isScanning = false
        deviceStatusProvider.stopScan()
    }
    
    public func pair(peripheral: CBPeripheral) {
        deviceStatusProvider.connect(peripheral)
    }
    
    public func cancelPairingRequest(peripheral: CBPeripheral) {
        deviceStatusProvider.cancelPeripheralConnection(peripheral)
    }
    
    public func startScan(config: ConnectivityConfigurations) {
        bleStatus.isScanning = true
        bleStatusProvider.startNotifying()
        resetTimer()
        deviceStatusProvider.scanForPeripherals()
    }
    
    // start a timer and stop scan on scan timeout
    private func resetTimer() {
        scanTimer?.invalidate()
        guard configuration.scanTimeOut else {
            return
        }
        let timeoutInterval = configuration.scanDuration
        scanTimer = Timer.scheduledTimer(withTimeInterval: timeoutInterval, repeats: false) { [weak self] _ in
            self?.stopScan()
        }
    }
}
