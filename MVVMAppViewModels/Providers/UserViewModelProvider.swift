//
//  UserProvider.swift
//  MVVMAppViewModels
//
//  Created by George Kaimakas on 02/10/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol UserViewModelProvider {
	var user: Property<UserViewModel> { get }
}
