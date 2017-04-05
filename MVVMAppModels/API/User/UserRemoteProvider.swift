//
//  UserRemoteProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import AlamofireReactiveExtensions
import Argo
import Curry
import Foundation
import ReactiveSwift
import Runes
import enum Result.Result
import struct Result.AnyError

public protocol UserRemoteProvider {
    func fetchUser(id: Int) -> SignalProducer<User, ProviderError>
}

public class UserRemoteRepository: UserRemoteProvider {
    public init() {}
    
    public func fetchUser(id: Int) -> SignalProducer<User, ProviderError> {
        return Alamofire.request(UserRouter.fetchUser(id))
            .reactive
            .responseJSON()
            .promoteErrors(ProviderError.self)
            .attemptRemoteMap()
            .map { JSON($0) }
            .map { User.decode($0) }
            .attempDecodeMap()
    }
}
