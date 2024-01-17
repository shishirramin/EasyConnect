//
//  PheriperalStorage.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth

protocol PheriperalStorageType {
    func storedPeripherals() -> [CBPeripheral]
    func save(_ peripheral: CBPeripheral)
    func delete(_ peripheral: CBPeripheral)
}

class PheriperalStorage: PheriperalStorageType {
    
    private func filePath() -> URL? {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        let archiveURL = documentsDirectory?.appendingPathComponent("PheriperalStorage_cachedDevices")
        return archiveURL
    }

    private func saveDevices(devices: [CBPeripheral]) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: devices, requiringSecureCoding: false)
            do {
                guard let filepath = filePath() else {
                    return
                }
                try data.write(to: filepath)
            } catch {
                print("Couldn't write file. info: \(error)")
            }
        } catch {
            print("Couldn't write file. info: \(error)")
        }
    }

    private func archiveDevices(_ data: Data) -> [CBPeripheral]? {
        do {
            let devices = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [CBPeripheral.self], from: data) as? [CBPeripheral]
            return devices
        } catch {
            print("Couldn't read file. info: \(error)")
        }
        return nil
    }

    func storedPeripherals() -> [CBPeripheral] {
        guard
            let filepath = filePath(),
            let data = try? Data(contentsOf: filepath) else {
            return []
        }
        return archiveDevices(data) ?? []
    }

    func save(_ peripheral: CBPeripheral) {
        var peripherals: [CBPeripheral] = storedPeripherals()
        peripherals.removeAll { $0.identifier == peripheral.identifier }
        peripherals.append(peripheral)
        saveDevices(devices: peripherals)
    }

    func delete(_ peripheral: CBPeripheral) {
        let peripherals: [CBPeripheral] = storedPeripherals().filter { $0.identifier != peripheral.identifier }
        saveDevices(devices: peripherals)
    }

    func doesProfileExists(_ uuid: String) -> Bool {
        storedPeripherals().contains { $0.identifier.uuidString == uuid }
    }
}

