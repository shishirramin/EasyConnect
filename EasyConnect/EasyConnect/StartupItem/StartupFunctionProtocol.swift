//
//  StartupFunctionProtocol.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

protocol StartupFunctionProtocol {
    func configureAndStart(_ app: UIApplicationType)
    func onApplicationDidEnterBackground()
    func onApplicationWillEnterForeground()
}

extension  StartupFunctionProtocol  {
    func onApplicationDidEnterBackground() {
        //Default implementation keeping empty
    }
    func onApplicationWillEnterForeground() {
        //Default implementation keeping empty
    }

    func configureAndStart(_ app: UIApplicationType ,items:[StartupFunctionProtocol]) {
        items.forEach { item in
            item.configureAndStart(app)
        }
    }

    func onApplicationWillEnterForeground(_ items:[StartupFunctionProtocol]) {
        items.forEach { item in
            item.onApplicationWillEnterForeground()
        }
    }

    func onApplicationDidEnterBackground(_ items:[StartupFunctionProtocol]) {
        items.forEach { item in
            item.onApplicationDidEnterBackground()
        }
    }
}
