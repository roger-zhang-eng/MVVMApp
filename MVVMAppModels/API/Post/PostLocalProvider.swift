//
//  PostLocalRepository.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

public protocol PostLocalProvider {
    func fetchPost(id: Int) -> SignalProducer<Post, LocalProviderError>
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], LocalProviderError>
    
    func save(post: Post) -> SignalProducer<Post, LocalProviderError>
}

public class PostLocalRepository: PostLocalProvider {
    private let container: DataContainer
    
    public init(container: DataContainer) {
        
        self.container = container
    }
    
    public func fetchPost(id: Int) -> SignalProducer<Post, LocalProviderError> {
		return SignalProducer<PostMO?, NSError> { () -> Result<PostMO?, NSError> in
                return Result<PostMO?, NSError>(attempt: { () -> PostMO? in
                    return try self.container.fetchObjects(type: PostMO.self, request: PostMO.requestFetchPost(id: id)).first
                })
            }
            .mapError { .persistenceFailure($0) }
            .flatMap(.latest) { value -> SignalProducer<PostMO, LocalProviderError> in
                guard let value = value else {
                    return SignalProducer<PostMO, LocalProviderError>(error: .notFound)
                }
                
                return SignalProducer<PostMO, LocalProviderError>(value: value)
            }
            .map { Post($0) }
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], LocalProviderError> {
		return SignalProducer<[PostMO], NSError> { () -> Result<[PostMO], NSError> in
                return Result<[PostMO], NSError>(attempt: { () -> [PostMO] in
                    return try self.container
                        .fetchObjects(type: PostMO.self,
                                      request: PostMO.requestFetchPagedPosts(page: page, limit: limit))
                })
            }
            .flatten()
            .map { Post($0) }
            .collect()
            .mapError { .persistenceFailure($0) }
    }
    
    public func save(post: Post) -> SignalProducer<Post, LocalProviderError> {
		let saveProducer = SignalProducer<PostMO, NSError> { () -> Result<PostMO, NSError> in
            return Result<PostMO, NSError>(attempt: { () -> PostMO in
                let postMO: PostMO = self.container.newObject(type: PostMO.self)
                postMO.inflate(post: post)
                try self.container.viewContext.save()
                return postMO
            })
            }
            .map { Post($0) }
            .mapError { LocalProviderError.persistenceFailure($0) }
        
        return fetchPost(id: post.id)
            .flatMap(.latest) { _ in return SignalProducer<Post, LocalProviderError>(error: .alreadyExists) }
            .flatMapError { error -> SignalProducer<Post, LocalProviderError> in
                switch error {
                case .notFound:
                    return saveProducer
                default:
                    return SignalProducer<Post, LocalProviderError>(error: error)
                }
            }
    }
}
