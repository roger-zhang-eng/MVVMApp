//
//  SignalProducer+ProviderError.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import AlamofireReactiveExtensions
import Foundation
import MVVMAppCommon
import ReactiveSwift
import enum Result.Result
import struct Result.AnyError

public extension SignalProducer where Value == DataResponse<Data>, Error == RemoteProviderError {
    func attemptRemoteMap() -> SignalProducer<Data, RemoteProviderError> {
        return self
            .attemptMap { (response: DataResponse<Data>) -> Result<Data, RemoteProviderError> in
                
                switch response.result {
                case .success(let value):
                    return Result.success(value)
                case .failure(_):
                    return Result.failure(RemoteProviderError.request(response.response?.statusCode ?? 400))
                }
        }
    }
}

public extension SignalProducer where Value == Data, Error == RemoteProviderError {
	func attemptJsonDecode<T: Decodable>(_ t: T.Type) -> SignalProducer<T, RemoteProviderError> {
		return self
			.attemptMap({ data -> Result<T, RemoteProviderError> in
				return Result<T, RemoteProviderError>.init(attempt: { () -> T in
					do {
						return try JSONDecoder().decode(t, from: data)
					} catch let error as NSError {
						throw RemoteProviderError.decode(error)
					}
				})
			})
	}
}

