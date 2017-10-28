//
//  ASViewController+DI.swift
//  MVVMApp
//
//  Created by George Kaimakas on 28/10/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import Swinject
import UIKit

extension UIApplication {
	static func inject<T>(_ type: T.Type) -> T {
		guard let object = (self.shared.delegate as? AppDelegate)?.container.resolve(type) else {
			fatalError("Could not inject \(type)")
		}

		return object
	}
}
