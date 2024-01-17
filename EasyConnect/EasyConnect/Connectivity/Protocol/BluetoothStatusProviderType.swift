//
//  BluetoothStatusProviderType.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Combine

/// Protocol which defines events for Bluetooth status and central discovery.

internal protocol BluetoothStatusProviderType: Notifier {
    /**
     statusPublisher: listen to when the Bluetooth status is updated
     */
    var statusPublisher: AnyPublisher <BluetoothStatus, Never> { get }
}

