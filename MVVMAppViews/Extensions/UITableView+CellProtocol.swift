//
//  UITableView+CellProtocol.swift
//  MVVMApp
//
//  Created by George Kaimakas on 11/05/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    func register<T: CellProtocol>(cell: T.Type) {
        self.register(cell.nib, forCellReuseIdentifier: cell.identifier)
    }
    
    func deque<T: CellProtocol>(cell: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: cell.identifier)! as! T
    }
    
    func deque<T: CellProtocol>(cell: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! T
    }
}
