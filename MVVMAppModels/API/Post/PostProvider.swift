//
//  PostRepository.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol PostProvider {
    var localProvider: PostLocalProvider { get }
    var remoteProvider: PostRemoteProvider { get }
    
    init(localProvider: PostLocalProvider, remoteProvider: PostRemoteProvider)
    
    func fetchPost(id: Int) -> SignalProducer<Post, ProviderError>
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError>
}

public class PostRepository: PostProvider {
    
    public var localProvider: PostLocalProvider
    public var remoteProvider: PostRemoteProvider
    
    public required init(localProvider: PostLocalProvider, remoteProvider: PostRemoteProvider) {
        self.localProvider = localProvider
        self.remoteProvider = remoteProvider
    }
    
    public func fetchPost(id: Int) -> SignalProducer<Post, ProviderError> {
        return localProvider
            .fetchPost(id: id)
            .flatMapError { (error: ProviderError) -> SignalProducer<Post, ProviderError> in
                return self.remoteProvider
                    .fetchPost(id: id)
                    .flatMap(.latest) { self.localProvider.save(post: $0) }
            }
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError> {
        return localProvider
            .fetchPosts(page: page, limit: limit)
            .flatMapError { (error: ProviderError) -> SignalProducer<[Post], ProviderError> in
                return self.remoteProvider
                    .fetchPosts(page: page, limit: limit)
                    .flatten()
                    .map() { self.localProvider.save(post: $0) }
                    .collect()
                    .flatMap(.latest) { SignalProducer.zip($0) }
            }
    }
    
}
