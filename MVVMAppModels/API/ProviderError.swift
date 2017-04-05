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
    case remote(Error)
    case decode(DecodeError)
    case local(LocalProviderError)
}

public enum LocalProviderError: Swift.Error {
    case notFound
    case alreadyExists
    case persistenceFailure(NSError)
}
