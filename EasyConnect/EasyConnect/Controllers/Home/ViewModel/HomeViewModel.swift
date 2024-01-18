//
//  HomeViewModel.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import Foundation

class HomeViewModel: TableViewDataProtocol {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(section: Int) -> Int {
        return 10
    }
    
    func dataForRowAt<T>(indexPath: IndexPath) -> T? {
        return Device(title: "Device 1",
                      subTitle: "Description 2") as? T
    }
}

struct Device: DeviceDetailConfigurable {
    var title: String?
    
    var subTitle: String?
    
    init(title: String? = nil,
         subTitle: String? = nil) {
        self.title = title
        self.subTitle = subTitle
    }
}
