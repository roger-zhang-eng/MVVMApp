//
//  PostRemoteRepository.swift
//  MVVMApp
//
//  Created by George Kaimakas on 30/03/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import AlamofireReactiveExtensions
import Foundation
import MVVMAppCommon
import ReactiveSwift
import enum Result.Result
import struct Result.AnyError

public protocol PostRemoteProvider {
    func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError>
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError>
}

public class PostRemoteRepository {
    public init() {}
    
    public func fetchPost(id: Int) -> SignalProducer<Post, RemoteProviderError> {
        return Alamofire.request(PostRouter.fetchPost(id))
            .reactive
            .responseData()
            .promoteError(RemoteProviderError.self)
            .attemptRemoteMap()
			.attemptJsonDecode(Post.self)
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], RemoteProviderError> {
        return Alamofire.request(PostRouter.fetchPosts(page, limit))
            .reactive
			.responseData()
            .promoteError(RemoteProviderError.self)
            .attemptRemoteMap()
			.attemptJsonDecode(Array<Post>.self)
    }
}

extension PostRemoteRepository: PostRemoteProvider {}
