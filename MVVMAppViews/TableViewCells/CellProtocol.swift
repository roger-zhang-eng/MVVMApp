//
//  TableViewCellProtocol.swift
//  MVVMApp
//
//  Created by George Kaimakas on 11/05/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import UIKit

public protocol CellProtocol: class {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension UITableViewCell: CellProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: self))
    }
}
