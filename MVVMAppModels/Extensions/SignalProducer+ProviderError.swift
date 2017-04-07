//
//  SignalProducer+ProviderError.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
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

public extension SignalProducer where Value == DataResponse<Any>, Error == RemoteProviderError {
    func attemptRemoteMap() -> SignalProducer<Any, RemoteProviderError> {
        return self
            .attemptMap { (response: DataResponse<Any>) -> Result<Any, RemoteProviderError> in
                
                switch response.result {
                case .success(let value):
                    return Result.success(value)
                case .failure(_):
                    return Result.failure(RemoteProviderError.request(response.response!.statusCode))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<Post>, Error == RemoteProviderError {
    func attempDecodeMap() -> SignalProducer<Post, RemoteProviderError> {
        return self
            .attemptMap { (decoded: Decoded<Post>) -> Result<Post, RemoteProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error{
                    return Result.failure(RemoteProviderError.decode(error as! DecodeError))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<User>, Error == RemoteProviderError {
    func attempDecodeMap() -> SignalProducer<User, RemoteProviderError> {
        return self
            .attemptMap { (decoded: Decoded<User>) -> Result<User, RemoteProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error {
                    return Result.failure(RemoteProviderError.decode(error as! DecodeError))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<Comment>, Error == RemoteProviderError {
    func attempDecodeMap() -> SignalProducer<Comment, RemoteProviderError> {
        return self
            .attemptMap { (decoded: Decoded<Comment>) -> Result<Comment, RemoteProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error {
                    return Result.failure(RemoteProviderError.decode(error as! DecodeError))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<[Post]>, Error == RemoteProviderError {
    func attempDecodeMap() -> SignalProducer<[Post], RemoteProviderError> {
        return self
            .attemptMap { (decoded: Decoded<[Post]>) -> Result<[Post], RemoteProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error {
                    return Result.failure(RemoteProviderError.decode(error as! DecodeError))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<[Comment]>, Error == RemoteProviderError {
    func attempDecodeMap() -> SignalProducer<[Comment], RemoteProviderError> {
        return self
            .attemptMap { (decoded: Decoded<[Comment]>) -> Result<[Comment], RemoteProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error {
                    return Result.failure(RemoteProviderError.decode(error as! DecodeError))
                }
        }
    }
}

