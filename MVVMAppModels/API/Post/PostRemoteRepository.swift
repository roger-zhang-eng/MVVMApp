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
    func fetchPost(id: Int) -> SignalProducer<Post, ProviderError>
    func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError>
}

public class PostRemoteRepository {
    public func fetchPost(id: Int) -> SignalProducer<Post, ProviderError> {
        return Alamofire.request(PostRouter.fetchPost(id))
            .reactive
            .responseJSON()
            .promoteErrors(ProviderError.self)
            .attemptMap { (response: DataResponse<Any>) -> Result<Any, ProviderError> in
                switch response.result {
                case .success(let value):
                    return Result.success(value)
                case .failure(let error):
                    return Result.failure(ProviderError.remote(error))
                }
            }
            .map { JSON($0) }
            .map { Post.decode($0) }
            .attemptMap { (decoded: Decoded<Post>) -> Result<Post, ProviderError> in
                do {
                    let post = try decoded.dematerialize()
                    return Result<Post, ProviderError>.success(post)
                } catch let error {
                    return Result<Post, ProviderError>.failure(ProviderError.decode(error as! DecodeError))
                }
            }
    }
    
    public func fetchPosts(page: Int, limit: Int) -> SignalProducer<[Post], ProviderError> {
//        return Alamofire.request(PostRouter.fetchPosts(page, limit))
//            .reactive
//            .responseJSON()
//            .map { $0.result.value }
//            .skipNil()
//            .map { JSON($0) }
//            .map { decodeArray($0) }
//            .attemptMap { (decoded: Decoded<[Post]>) -> [Post] in
//                try decoded.dematerialize()
//        }
        return SignalProducer.empty
    }
}

extension PostRemoteRepository: PostRemoteProvider {}
