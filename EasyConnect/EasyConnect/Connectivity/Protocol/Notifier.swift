//
//  Notifier.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Foundation

protocol Notifier {
    func startNotifying()
}

protocol CBCentralAutorizationProviderType: Notifier {
    var delegate: AutorizationProtocol? { get set }
}

protocol CBCentralConnectionProviderType: Notifier {
    var connectionDelegate: DeviceConnectionProtocol? { get set }
}

typealias CBCentralProviderType = CBCentralConnectionProviderType & CBCentralAutorizationProviderType
