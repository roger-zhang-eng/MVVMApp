//
//  UserRemoteProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import AlamofireReactiveExtensions
import Foundation
import ReactiveSwift
import enum Result.Result
import struct Result.AnyError

public protocol UserRemoteProvider {
    func fetchUser(id: Int) -> SignalProducer<User, RemoteProviderError>
}

public class UserRemoteRepository: UserRemoteProvider {
    public init() {}
    
    public func fetchUser(id: Int) -> SignalProducer<User, RemoteProviderError> {
        return Alamofire.request(UserRouter.fetchUser(id))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .attemptRemoteMap()
			.attemptJsonDecode(User.self)
    }
}
