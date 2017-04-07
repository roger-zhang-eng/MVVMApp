//
//  PostRemoteRepository.swift
//  MVVMApp
//
//  Created by George Kaimakas on 30/03/2017.
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

public protocol PostRemoteProvider {
    func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError>
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError>
}

public class PostRemoteRepository {
    public func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError> {
        return Alamofire.request(PostRouter.fetchPost(id))
            .reactive
            .responseJSON()
            .promoteErrors(RemoteProviderError.self)
            .attemptRemoteMap()
            .map { JSON($0) }
            .map { Post.decode($0) }
            .attempDecodeMap()
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError> {
        return Alamofire.request(PostRouter.fetchPosts(page, limit))
            .reactive
            .responseJSON()
            .promoteErrors(RemoteProviderError.self)
            .attemptRemoteMap()
            .map { JSON($0) }
            .map { decodeArray($0) }
            .attempDecodeMap()
    }
}

extension PostRemoteRepository: PostRemoteProvider {}
