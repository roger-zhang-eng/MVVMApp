//
//  UserProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol UserProvider {
    var localProvider: UserLocalProvider { get }
    var remoteProvider: UserRemoteProvider { get }
    
    init(localProvider: UserLocalProvider, remoteProvider: UserRemoteProvider)
    
    func fetchUser(id: Int) -> SignalProducer<User, ProviderError>
}

public class UserRepository: UserProvider {
    public let localProvider: UserLocalProvider
    public let remoteProvider: UserRemoteProvider
    
    public required init(localProvider: UserLocalProvider, remoteProvider: UserRemoteProvider) {
        self.localProvider = localProvider
        self.remoteProvider = remoteProvider
    }
    
    public func fetchUser(id: Int) -> SignalProducer<User, ProviderError> {
        return localProvider
            .fetchUser(id: id)
            .mapError { ProviderError.local($0) }
            .flatMapError { (error: ProviderError) -> SignalProducer<User, ProviderError> in
                return self.remoteProvider
                    .fetchUser(id: id)
                    .mapError { ProviderError.remote($0) }
                    .flatMap(.latest) { self.localProvider
                        .save(user: $0)
                        .mapError { ProviderError.local($0) }
                    }
            }
    }
}
