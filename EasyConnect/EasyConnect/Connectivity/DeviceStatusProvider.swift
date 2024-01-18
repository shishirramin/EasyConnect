//
//  DeviceStatusProvider.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth
import Combine

internal class DeviceStatusProvider : NSObject, DeviceStatusProviderType {
    
    var devicePublisher: AnyPublisher<(DeviceStatusEventType, CBPeripheral), Never>
    internal var deviceEvents: PassthroughSubject <(DeviceStatusEventType, CBPeripheral), Never>
    var centralDiscoveryPublisher: AnyPublisher<(CentralDiscoveryEventType, [CBPeripheral]), Never>
    internal var centralDiscoveryEvents: PassthroughSubject <(CentralDiscoveryEventType, [CBPeripheral]), Never>
    internal var central: CBCentralConnectionProviderType
    var applianceList: [CBPeripheral] = []
    lazy var deviceStorage: PheriperalStorageType = PheriperalStorage()

    override init() {
        central = CBCentralProvider.shared
        centralDiscoveryEvents = PassthroughSubject<(CentralDiscoveryEventType, [CBPeripheral]), Never>()
        centralDiscoveryPublisher = centralDiscoveryEvents.eraseToAnyPublisher()
        deviceEvents = PassthroughSubject<(DeviceStatusEventType, CBPeripheral), Never>()
        devicePublisher = deviceEvents.eraseToAnyPublisher()
        super.init()
        central.connectionDelegate = self
        loadSavedDevices()
    }
    
    private func loadSavedDevices() {
        applianceList = deviceStorage.storedPeripherals().compactMap { $0 }
        centralDiscoveryEvents.send((.didAdd,applianceList))
    }
    
    func stopScan()  {
        central.stopScan()
    }
    
    func connect(
        _ peripheral: CBPeripheral
    ) {
        central.connect(pheriperal: peripheral)
    }
    
    func scanForPeripherals() {
        central.scan()
    }

    func cancelPeripheralConnection(_ peripheral: CBPeripheral) {
        central.unpair(pheriperal: peripheral)
    }
    
    func removeUnPairedDevice() {
        applianceList.removeAll(where: {  ($0.state != .connected || $0.state != .connecting) })
        centralDiscoveryEvents.send((.didRemove,applianceList))
    }
}

extension DeviceStatusProvider: DeviceConnectionProtocol {
    //Save the peripheral when the device is paired
    func didConnect(peripheral: CBPeripheral) {
//        deviceStorage.save(peripheral)
        deviceEvents.send((.connected,peripheral))
    }
    
    func didFailToConnect(peripheral: CBPeripheral) {
        //Handle error
    }
    
    //delete the peripheral when the device is unpaired
    func didDisconnect(peripheral: CBPeripheral) {
        deviceStorage.delete(peripheral)
        deviceEvents.send((.disconnected,peripheral))
    }

    func didDiscover(peripheral: CBPeripheral) {
        applianceList.append(peripheral)
        centralDiscoveryEvents.send((.didAdd,applianceList))
    }
    
}
