//
//  PostLocalRepository.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol PostLocalProvider {
    func fetchPost(id: Int) -> SignalProducer<Post, ProviderError>
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError>
    
    func save(post: Post) -> SignalProducer<Post, ProviderError>
}

public class PostLocalRepository: PostLocalProvider {
    public init() {
        
    }
    
    public func fetchPost(id: Int) -> SignalProducer<Post, ProviderError> {
        return SignalProducer.init(error: ProviderError.local(.notFound))
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError> {
        return SignalProducer.init(error: ProviderError.local(.notFound))
    }
    
    public func save(post: Post) -> SignalProducer<Post, ProviderError> {
        return SignalProducer.init(value: Post(id: 0, userId: 0, title: nil, body: nil))
    }
}
