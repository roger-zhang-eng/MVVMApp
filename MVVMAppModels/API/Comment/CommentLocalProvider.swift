//
//  CommentLocalProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation
import MVVMAppCommon
import ReactiveCocoa
import ReactiveSwift
import Result

public protocol CommentLocalProvider {
    func fetchComment(id: Int) -> SignalProducer<Comment, LocalProviderError>
    func fetchComments(postId: Int) -> SignalProducer<[Comment], LocalProviderError>
    func save(comment: Comment) -> SignalProducer<Comment, LocalProviderError>
    func clearAll() -> SignalProducer<Void, LocalProviderError>
}

public class CommentLocalRepository: CommentLocalProvider {
    let container: DataContainer
    
    public init(container: DataContainer) {
        self.container = container
    }
    
    public func fetchComment(id: Int) -> SignalProducer<Comment, LocalProviderError> {
		return SignalProducer<CommentMO?, NSError> { () -> Result<CommentMO?, NSError> in
                return Result<CommentMO?, NSError>(attempt: { () -> CommentMO? in
                    return try self.container
                        .fetchObjects(type: CommentMO.self,
                                  request: CommentMO.requestFetchComment(id: id))
                        .first
                })
            }
            .mapError { .persistenceFailure($0) }
            .flatMap(.latest) { value -> SignalProducer<CommentMO, LocalProviderError> in
                guard let value = value else {
                    return SignalProducer<CommentMO, LocalProviderError>(error: .notFound)
                }
                
                return SignalProducer<CommentMO, LocalProviderError>(value: value)
            }
            .map { Comment($0) }
    }
    
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], LocalProviderError> {
		return SignalProducer<[CommentMO], NSError> { () -> Result<[CommentMO], NSError> in
            return Result<[CommentMO], NSError>(attempt: { () -> [CommentMO] in
                return try self.container
                            .fetchObjects(type: CommentMO.self,
                                          request: CommentMO.requestFetchComments(postId: postId))
                    })
                }
                .mapError { LocalProviderError.persistenceFailure($0) }
                .flatten()
                .map { Comment($0) }
                .collect()
    }
    
    
    
    public func save(comment: Comment) -> SignalProducer<Comment, LocalProviderError> {
		let saveProducer = SignalProducer<CommentMO, NSError> { () -> Result<CommentMO, NSError> in
            return Result<CommentMO, NSError>(attempt: { () -> CommentMO in
                let mo: CommentMO = self.container.newObject(type: CommentMO.self)
                mo.inflate(comment: comment)
                try self.container.viewContext.save()
                return mo
            })
            }
            .map { Comment($0) }
            .mapError { LocalProviderError.persistenceFailure($0) }
        
        return fetchComment(id: comment.id)
            .flatMap(.latest) { _ in return SignalProducer<Comment, LocalProviderError>(error: .alreadyExists) }
            .flatMapError { error -> SignalProducer<Comment, LocalProviderError> in
                switch error {
                case .notFound:
                    return saveProducer
                default:
                    return SignalProducer<Comment, LocalProviderError>(error: error)
                }
        }
    }

    public func clearAll() -> SignalProducer<Void, LocalProviderError> {
        return SignalProducer<Void, LocalProviderError> { () -> Result<Void, LocalProviderError> in
            return Result<Void, NSError>.init(attempt: {
                try self.container
                    .deleteObjects(type: CommentMO.self, request: CommentMO.requestFetchAllComments())
            })
                .mapError { LocalProviderError.persistenceFailure($0) }
        }
    }
}

