//
//  CommentRemoteProvider.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import AlamofireReactiveExtensions
import Argo
import Curry
import Foundation
import ReactiveSwift
import Runes
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
            .responseJSON()
            .promoteErrors(RemoteProviderError.self)
            .attemptRemoteMap()
            .map { JSON($0) }
            .map { Comment.decode($0) }
            .attempDecodeMap()
    }
    
    public func fetchComments(postId: Int) -> SignalProducer<[Comment], RemoteProviderError> {
        return Alamofire.request(CommentRouter.fetchComments(postId))
            .reactive
            .responseJSON()
            .promoteErrors(RemoteProviderError.self)
            .attemptRemoteMap()
            .map { JSON($0) }
            .map { decodeArray($0) as Decoded<[Comment]> }
            .attempDecodeMap()
            
    }
}
