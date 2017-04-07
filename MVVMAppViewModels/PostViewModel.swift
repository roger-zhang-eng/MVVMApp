//
//  PostViewModel.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppModels
import ReactiveCocoa
import ReactiveSwift
import Result

public class PostViewModel {
    private let userProvider: UserProvider
    
    public init(userProvider: UserProvider){
        self.userProvider = userProvider
    }
}
