//
//  ConnectivityConfigurator.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation

class ConnectivityConfigurator: StartupFunctionProtocol {
    private var connectivtyHub: ConnectivityHubType

     internal init(_ connectivtyHub: ConnectivityHubType = ConnectivityHub.shared) {
        self.connectivtyHub = connectivtyHub
    }

    func configureAndStart(_ app: UIApplicationType) {
        connectivtyHub.configuration = ConnectivityConfigurations(scanTimeOut: false) 
    }

    func onApplicationWillEnterForeground() {
        connectivtyHub.autoConnect()
    }
}
