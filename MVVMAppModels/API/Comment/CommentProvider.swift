//
//  CommentProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppCommon
import ReactiveSwift
import Result

public protocol CommentProvider {
    var localProvider: CommentLocalProvider { get }
    var remoteProvider: CommentRemoteProvider { get }
    
    init(localProvider: CommentLocalProvider, remoteProvider: CommentRemoteProvider)
    
    func fetchComment(id: Int) -> SignalProducer<Comment, ProviderError>
    func fetchComments(postId: Int) -> SignalProducer<[Comment], ProviderError>
}

public class CommentRepository: CommentProvider {
    public let localProvider: CommentLocalProvider
    public let remoteProvider: CommentRemoteProvider
    
    public required init(localProvider: CommentLocalProvider, remoteProvider: CommentRemoteProvider) {
        self.localProvider = localProvider
        self.remoteProvider = remoteProvider
    }
    
    public func fetchComment(id: Int) -> SignalProducer<Comment, ProviderError> {
        return localProvider
            .fetchComment(id: id)
            .mapError { ProviderError.local($0) }
            .flatMapError { (error: ProviderError) -> SignalProducer<Comment, ProviderError> in
                return self.remoteProvider
                    .fetchComment(id: id)
                    .mapError { ProviderError.remote($0) }
                    .flatMap(.latest) { comment -> SignalProducer<Comment, ProviderError> in
                        return self
                            .localProvider
                            .save(comment: comment)
                            .mapError { ProviderError.local($0) }
                            .flatMapError{ error -> SignalProducer<Comment, ProviderError> in
                                switch error {
                                case .local(let error) where error == .alreadyExists:
                                    return SignalProducer<Comment, ProviderError>(value: comment)
                                default:
                                    return SignalProducer<Comment, ProviderError>(error: error)
                                }
                            }
                }
        }
    }
    
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], ProviderError> {
        let remoteProducer = self.remoteProvider
            .fetchComments(postId: postId)
            .mapError { ProviderError.remote($0) }
            .flatten()
            .map() { comment -> SignalProducer<Comment, ProviderError> in
                return self.localProvider
                    .save(comment: comment)
                    .mapError { ProviderError.local($0) }
                    .flatMapError{ error -> SignalProducer<Comment, ProviderError> in
                        switch error {
                        case .local(let error) where error == .alreadyExists:
                            return SignalProducer<Comment, ProviderError>(value: comment)
                        default:
                            return SignalProducer<Comment, ProviderError>(error: error)
                        }
                }
            }
            .collect()
            .flatMap(.latest) { SignalProducer.zip($0) }
        
        return localProvider
            .fetchComments(postId: postId)
            .mapError { ProviderError.local($0) }
            .flatMap(.latest) { values -> SignalProducer<[Comment], ProviderError> in
                if values.count == 0 {
                    return remoteProducer
                } else {
                    return SignalProducer<[Comment], ProviderError>(value: values)
                }
            }
            .flatMapError { (error: ProviderError) -> SignalProducer<[Comment], ProviderError> in
                return remoteProducer
            }
    }
}
