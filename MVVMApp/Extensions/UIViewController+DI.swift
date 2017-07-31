//
//  UIViewController+DI.swift
//  MVVMApp
//
//  Created by George Kaimakas on 31/07/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import Swinject
import UIKit

extension UIViewController {
    func inject<T>(_ type: T.Type) -> T {
        guard let object = (UIApplication.shared.delegate as? AppDelegate)?.container.resolve(type) else {
            fatalError("Could not inject \(type)")
        }
        
        return object
    }
}
