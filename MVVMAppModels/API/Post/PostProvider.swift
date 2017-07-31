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
            .mapError { ProviderError.local($0) }
            .flatMapError { (error: ProviderError) -> SignalProducer<Post, ProviderError> in
                return self.remoteProvider
                    .fetchPost(id: id)
                    .mapError { ProviderError.remote($0) }
                    .flatMap(.latest) { post -> SignalProducer<Post, ProviderError> in
                        return self.localProvider
                        .save(post: post)
                        .mapError { ProviderError.local($0) }
                        .flatMapError{ error -> SignalProducer<Post, ProviderError> in
                            switch error {
                            case .local(let error) where error == .alreadyExists:
                                return SignalProducer<Post, ProviderError>(value: post)
                            default:
                                return SignalProducer<Post, ProviderError>(error: error)
                            }
                        }
                }
            }
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError> {
        let remoteProducer = self.remoteProvider
            .fetchPosts(page: page, limit: limit)
            .mapError { ProviderError.remote($0) }
            .flatten()
            .map() { post -> SignalProducer<Post, ProviderError> in
                return self.localProvider
                    .save(post: post)
                    .mapError { ProviderError.local($0) }
                    .flatMapError{ error -> SignalProducer<Post, ProviderError> in
                        switch error {
                        case .local(let error) where error == .alreadyExists:
                            return SignalProducer<Post, ProviderError>(value: post)
                        default:
                            return SignalProducer<Post, ProviderError>(error: error)
                        }
                }
            }
            .collect()
            .flatMap(.latest) { SignalProducer.zip($0) }
        
        return localProvider
            .fetchPosts(page: page-1, limit: limit)
            .mapError { ProviderError.local($0) }
            .flatMap(.latest) { values -> SignalProducer<[Post], ProviderError> in
                if values.count == 0 {
                    return remoteProducer
                } else {
                    return SignalProducer<[Post], ProviderError>(value: values)
                }
            }
            .flatMapError { (error: ProviderError) -> SignalProducer<[Post], ProviderError> in
                return remoteProducer
            }
    }
    
}
