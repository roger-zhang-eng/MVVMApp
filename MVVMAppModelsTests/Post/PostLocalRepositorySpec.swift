//
//  PostLocalRepositorySpec.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
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

public class PostLocalRepositorySpec: QuickSpec {
    override public func spec() {
        super.spec()
        
        let container = DataContainer(name: "PostLocalRepositorySpec")
        let repo = PostLocalRepository(container: container)
        
        describe("save(post:_)") {
            it("should save a post") {
                let newPost = Post(id: Int(arc4random_uniform(10000) + 1),
                                   userId: Int(arc4random_uniform(100) + 1),
                                   title: "abcdef",
                                   body: "\(arc4random_uniform(1000000))")
                var post: Post? = nil
                
                repo.save(post: newPost)
                    .startWithResult({ (result: Result<Post, ProviderError>) in
                        switch result {
                        case .success(let value):
                            post = value
                        default:
                            post = nil
                        }
                    })
                
                expect(post).toEventuallyNot(beNil())
                if let post = post {
                    expect(post.id).to(equal(newPost.id))
                    expect(post.userId).to(equal(newPost.userId))
                    expect(post.body).to(equal(newPost.body))
                    expect(post.title).to(equal(newPost.title))
                }
            }
        }
    }
}
