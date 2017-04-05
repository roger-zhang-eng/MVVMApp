//
//  UserLocalProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol UserLocalProvider {
    func fetchUser(id: Int) -> SignalProducer<User, ProviderError>
    func save(user: User) -> SignalProducer<User, ProviderError>
}

public class UserLocalRepository: UserLocalProvider {
    public init() {}
    
    public func fetchUser(id: Int) -> SignalProducer<User, ProviderError> {
        return SignalProducer.init(error: ProviderError.local(.notFound))
    }
    
    public func save(user: User) -> SignalProducer<User, ProviderError> {
        return SignalProducer.init(value: User(id: 0,
                                               name: nil,
                                               username: nil,
                                               email: nil,
                                               phone: nil,
                                               website: nil,
                                               address: nil,
                                               company: nil))
    }
}
