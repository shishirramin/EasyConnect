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

public class ConnectivityHub: ConnectivityHubType {
    public var configuration: ConnectivityConfigurations
    public var pheripheralList: [CBPeripheral] = []
    public static let shared = ConnectivityHub()
    public var bleStatus: CentralManagerStatus
    
    private var centralManagerStatusEvents: PassthroughSubject <CentralManagerStatus, Never>
    public var centralManagerStatusPublisher: AnyPublisher <CentralManagerStatus, Never>
    public var centralDiscoveryPublisher: AnyPublisher <(CentralDiscoveryEventType, [CBPeripheral]), Never>
    private var centralDiscoveryEvents: PassthroughSubject <(CentralDiscoveryEventType, [CBPeripheral]), Never>
    private var deviceStatusEvents: PassthroughSubject <(DeviceStatusEventType,CBPeripheral), Never>
    public var deviceStatusPublisher: AnyPublisher <(DeviceStatusEventType, CBPeripheral), Never>
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
        deviceStatusEvents = PassthroughSubject<(DeviceStatusEventType, CBPeripheral), Never>()
        deviceStatusPublisher = deviceStatusEvents.eraseToAnyPublisher()
        subscribeCentralManager()
        
        //start notify only if device is present in the list, to auto connect
        if !pheripheralList.isEmpty{
            bleStatusProvider.startNotifying()
        }
    }

    func subscribeCentralManager() {
        deviceStatusProvider.centralDiscoveryPublisher.sink { [weak self] eventType, appliances  in
            self?.handleDiscoveryEvent(eventType, appliances)
            self?.centralDiscoveryEvents.send((eventType, appliances))
        }
        .store(in: &cancellableSet)
    
        deviceStatusProvider.devicePublisher.sink { [weak self] eventType, appliance  in
            self?.handleDeviceEvent(eventType, appliance)
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
                appliances.contains { $0.identifier == appliance.identifier }
            }
        }
    }

    private func handleDeviceEvent(_ eventType: DeviceStatusEventType,
                                      _ appliance: CBPeripheral) {
        if eventType == .disconnected {
            pheripheralList.removeAll { $0.identifier == appliance.identifier }
        }
        self.deviceStatusEvents.send((eventType, appliance))
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
    
    public func autoConnect() {
        guard bleStatus.state,
              !bleStatus.isScanning else {
            return
        }
        pheripheralList.forEach { device in
            deviceStatusProvider.connect(device)
        }
    }
    
    public func removeUnPairedDevice() {
        deviceStatusProvider.removeUnPairedDevice()
    }
    
    public func pheripheralWith(_ identifier: String) -> CBPeripheral? {
        return pheripheralList.first(where: { $0.identifier.uuidString == identifier })
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
