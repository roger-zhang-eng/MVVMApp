//
//  UserLocalProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation
import ReactiveSwift
import Result

public protocol UserLocalProvider {
    func fetchUser(id: Int) -> SignalProducer<User, LocalProviderError>
    func save(user: User) -> SignalProducer<User, LocalProviderError>
}

public class UserLocalRepository: UserLocalProvider {
    let container: DataContainer
    public init(container: DataContainer) {
        self.container = container
    }
    
    public func fetchUser(id: Int) -> SignalProducer<User, LocalProviderError> {
        return SignalProducer.init(error: .notFound)
    }
    
    public func save(user: User) -> SignalProducer<User, LocalProviderError> {
        return SignalProducer<UserMO, NSError>.attempt { () -> Result<UserMO, NSError> in
                return Result<UserMO, NSError>(attempt: { () -> UserMO in
                    let mo = self.container.newObject(type: UserMO.self)
                    mo.inflate(user: user)
                    try self.container.viewContext.save()
                    return mo
                })
            }
            .map { User($0) }
            .mapError { .persistenceFailure($0) }
    }
}
