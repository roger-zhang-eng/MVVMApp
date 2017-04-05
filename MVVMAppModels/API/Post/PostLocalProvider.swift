//
//  PostLocalRepository.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation
import ReactiveSwift
import Result

public protocol PostLocalProvider {
    func fetchPost(id: Int) -> SignalProducer<Post, ProviderError>
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError>
    
    func save(post: Post) -> SignalProducer<Post, ProviderError>
}

public class PostLocalRepository: PostLocalProvider {
    private let container: DataContainer
    
    public init(container: DataContainer) {
        
        self.container = container
    }
    
    public func fetchPost(id: Int) -> SignalProducer<Post, ProviderError> {
        return SignalProducer.init(error: ProviderError.local(.notFound))
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError> {
        return SignalProducer.init(error: ProviderError.local(.notFound))
    }
    
    public func save(post: Post) -> SignalProducer<Post, ProviderError> {
        return SignalProducer<PostMO, NSError>.attempt { () -> Result<PostMO, NSError> in
                return Result<PostMO, NSError>(attempt: { () -> PostMO in
                    let postMO: PostMO = self.container.newObject(type: PostMO.self)
                    postMO.inflate(post: post)
                    try self.container.viewContext.save()
                    return postMO
                })
            }
            .map { Post($0) }
            .mapError { ProviderError.local(.persistenceFailure($0)) }
    }
}
