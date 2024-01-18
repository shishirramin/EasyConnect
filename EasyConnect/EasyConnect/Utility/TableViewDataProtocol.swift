//
//  TableViewDataProtocol.swift
//  EasyConnect
//
//  Created by Shishir Amin on 18/01/24.
//

import UIKit

public protocol TableViewDataProtocol {
    func numberOfSections() -> Int
    func numberOfRows(section: Int) -> Int
    func dataForRowAt<T>(indexPath: IndexPath) -> T?
    func dataForHeaderAt<T>(section: Int) -> T?
    func dataForFooterAt<T>(section: Int) -> T?
    func heightForHeader(at section: Int) -> CGFloat
    func heightForRow(at indexPath: IndexPath) -> CGFloat
    func heightForFooter(at section: Int) -> CGFloat
    func titleForSection(in section: Int) -> String
    func didSelect(at indexPath: IndexPath)
}

extension TableViewDataProtocol {
    func dataForHeaderAt<T>(section: Int) -> T? {
        nil
    }
    
    func dataForFooterAt<T>(section: Int) -> T? {
        nil
    }
    
    func heightForHeader(at section: Int) -> CGFloat {
        return 0
    }
    
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func heightForFooter(at section: Int) -> CGFloat {
        0
    }
    
    func titleForSection(in section: Int) -> String {
        ""
    }
    
    func didSelect(at indexPath: IndexPath) {
        //execute as per need
    }
}
