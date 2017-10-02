//
//  CommentRemoteProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import AlamofireReactiveExtensions
import Foundation
import ReactiveSwift
import enum Result.Result
import struct Result.AnyError

public protocol CommentRemoteProvider {
    func fetchComment(id: Int) -> SignalProducer<Comment, RemoteProviderError>
    func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError>
}

public class CommentRemoteRepository: CommentRemoteProvider {
    public init() {}
    
    public func fetchComment(id: Int) -> SignalProducer<Comment, RemoteProviderError> {
        return Alamofire.request(CommentRouter.fetchComment(id))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .attemptRemoteMap()
			.attemptJsonDecode(Comment.self)

    }
    
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError> {
        return Alamofire.request(CommentRouter.fetchComments(postId))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .attemptRemoteMap()
			.attemptJsonDecode(Array<Comment>.self)
            
    }
}
