//
//  CentralDiscoveryEventType.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Foundation
/// Enum for device Discovery Event Type
public enum CentralDiscoveryEventType {
    ///didAdd event
    case didAdd
    ///didRemove event
    case didRemove
}

/// Enum for device Discovery Event Type
public enum DeviceStatusEventType {
    ///connect event
    case connected
    ///disconnect event
    case disconnected
}
