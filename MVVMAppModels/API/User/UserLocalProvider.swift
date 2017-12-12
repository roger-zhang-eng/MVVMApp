//
//  UserLocalProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation
import MVVMAppCommon
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
		return SignalProducer<UserMO?, NSError> { () -> Result<UserMO?, NSError> in
            return Result<UserMO?, NSError>(attempt: { () -> UserMO? in
                return try self.container.fetchObjects(type: UserMO.self, request: UserMO.requestFetchUser(id: id)).first
            })
            }
            .mapError { .persistenceFailure($0) }
            .flatMap(.latest) { value -> SignalProducer<UserMO, LocalProviderError> in
                guard let value = value else {
                    return SignalProducer<UserMO, LocalProviderError>(error: .notFound)
                }
                
                return SignalProducer<UserMO, LocalProviderError>(value: value)
            }
            .map { User($0) }
    }
    
    public func save(user: User) -> SignalProducer<User, LocalProviderError> {
		let saveProducer = SignalProducer<UserMO, NSError> { () -> Result<UserMO, NSError> in
                return Result<UserMO, NSError>(attempt: { () -> UserMO in
                    let mo = self.container.newObject(type: UserMO.self)
                    mo.inflate(user: user)
                    try self.container.viewContext.save()
                    return mo
                })
            }
            .map { User($0) }
            .mapError { LocalProviderError.persistenceFailure($0) }
        
        return fetchUser(id: user.id)
            .flatMap(.latest) { _ in return SignalProducer<User, LocalProviderError>(error: .alreadyExists) }
            .flatMapError { error -> SignalProducer<User, LocalProviderError> in
                switch error {
                case .notFound:
                    return saveProducer
                default:
                    return SignalProducer<User, LocalProviderError>(error: error)
                }
        }
    }
}
