//
//  CBManagerAuthorization+enum.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import CoreBluetooth

extension CBManagerAuthorization {
    func autorization() -> BleAuthorization{
        let authorization : BleAuthorization
        switch self {
        case .allowedAlways:
            authorization = .allowedAlways
        case .notDetermined:
            authorization = .notDetermined
        default:
            authorization = .denied
        }
        return authorization
    }
}
