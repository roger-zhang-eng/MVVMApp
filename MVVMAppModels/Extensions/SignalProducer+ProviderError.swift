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

public extension SignalProducer where Value == DataResponse<Any>, Error == ProviderError {
    func attemptRemoteMap() -> SignalProducer<Any, ProviderError> {
        return self
            .attemptMap { (response: DataResponse<Any>) -> Result<Any, ProviderError> in
                switch response.result {
                case .success(let value):
                    return Result.success(value)
                case .failure(let error):
                    return Result.failure(ProviderError.remote(error))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<Post>, Error == ProviderError {
    func attempDecodeMap() -> SignalProducer<Post, ProviderError> {
        return self
            .attemptMap { (decoded: Decoded<Post>) -> Result<Post, ProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error {
                    return Result.failure(ProviderError.decode(error as! DecodeError))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<User>, Error == ProviderError {
    func attempDecodeMap() -> SignalProducer<User, ProviderError> {
        return self
            .attemptMap { (decoded: Decoded<User>) -> Result<User, ProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error {
                    return Result.failure(ProviderError.decode(error as! DecodeError))
                }
        }
    }
}

public extension SignalProducer where Value == Decoded<[Post]>, Error == ProviderError {
    func attempDecodeMap() -> SignalProducer<[Post], ProviderError> {
        return self
            .attemptMap { (decoded: Decoded<[Post]>) -> Result<[Post], ProviderError> in
                do {
                    let value = try decoded.dematerialize()
                    return Result.success(value)
                } catch let error {
                    return Result.failure(ProviderError.decode(error as! DecodeError))
                }
        }
    }
}

