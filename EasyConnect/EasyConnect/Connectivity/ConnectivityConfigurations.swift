//
//  ConnectivityConfigurations.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation

public struct ConnectivityConfigurations {
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
