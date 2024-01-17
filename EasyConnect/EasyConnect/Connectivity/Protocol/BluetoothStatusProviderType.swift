//
//  BluetoothStatusProviderType.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Combine

internal protocol BluetoothStatusProviderType: Notifier {
    var statusPublisher: AnyPublisher <BluetoothStatus, Never> { get }
}

