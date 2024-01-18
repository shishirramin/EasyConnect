//
//  DeviceDetailConfigurable.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Foundation
import CoreBluetooth

protocol DeviceDetailConfigurable {
    var title: String? { get }
    var subTitle: String? { get }
}

extension CBPeripheral: DeviceDetailConfigurable {
    var title: String? {
        name
    }
    
    var subTitle: String? {
        // get the sub details from CMS
        return "Bluetooth device"
    }
    
    
}
