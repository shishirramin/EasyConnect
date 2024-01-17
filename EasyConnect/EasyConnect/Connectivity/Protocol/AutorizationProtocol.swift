//
//  AutorizationProtocol.swift
//  EasyConnect
//
//  Created by Shishir Amin on 17/01/24.
//

import Foundation

protocol AutorizationProtocol: AnyObject {
    func didUpdate(central:CBCentralManagerProtocol)
}
