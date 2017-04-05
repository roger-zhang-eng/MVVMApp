//
//  Post+ArgoSpec.swift
//  MVVMApp
//
//  Created by George Kaimakas on 30/03/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Argo
import Curry
import Foundation
import Nimble
import Quick
import Runes
import Result
import ReactiveSwift
@testable import MVVMAppModels
public class PostArgoSpec: QuickSpec {
    override public func spec() {
        super.spec()
        
        
        describe("decode"){
            it("should decode a json object to a Post") {
                let remoteRepo = PostRemoteRepository()
                var post: Post? = nil
                
                remoteRepo
                    .fetchPost(id: -1)
                    .startWithResult({ (result: Result<Post, ProviderError>) in
                        switch result {
                        case .success(let value):
//                            post = value
                            break
                        case .failure(let error):
//                            post = nil
                            break
                        }
                    })
                
                expect(post).toEventuallyNot(beNil(), timeout: 20)
            }
        }
    }
}
