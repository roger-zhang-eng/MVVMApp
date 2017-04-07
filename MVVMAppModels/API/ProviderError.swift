//
//  ProviderError.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import Argo

public enum ProviderError: Swift.Error {
    case unknown
    case remote(RemoteProviderError)
    case local(LocalProviderError)
}

public enum RemoteProviderError: Swift.Error, Equatable {
    public static func ==(lhs: RemoteProviderError, rhs: RemoteProviderError) -> Bool {
        switch (lhs, rhs) {
        case (.request(let statusA), .request(let statusB)): return statusA == statusB
        case (.decode(let errorA), .decode(let errorB)): return errorA == errorB
        default: return false
        }
    }
    
    case request(Int)
    case decode(DecodeError)
}

public enum LocalProviderError: Swift.Error, Equatable {
    public static func ==(lhs: LocalProviderError, rhs: LocalProviderError) -> Bool {
        switch (lhs, rhs) {
        case (.notFound, .notFound): return true
        case (.alreadyExists, .alreadyExists):  return true
        case (.persistenceFailure(let errorA), .persistenceFailure(let errorB)): return errorA == errorB
        default: return false
        }
    }

    case notFound
    case alreadyExists
    case persistenceFailure(NSError)
}
