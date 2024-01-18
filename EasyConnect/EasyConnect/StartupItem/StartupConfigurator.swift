//
//  StartupConfigurator.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation

class StartupConfigurator: StartupFunctionProtocol {
    lazy var items: [StartupFunctionProtocol] = [
        ConnectivityConfigurator()
    ]
}

extension StartupConfigurator {
    func configureAndStart(_ app: UIApplicationType) {
        configureAndStart(app, items: items)
    }
    
    func onApplicationDidEnterBackground() {
        onApplicationDidEnterBackground(items)
    }
    
    func onApplicationWillEnterForeground() {
        onApplicationWillEnterForeground(items)
    }
}
