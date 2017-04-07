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
                    .startWithResult({ (result: Result<Post, LocalProviderError>) in
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
            
            it("should fail if the post already exists") {
                let newPost = Post(id: Int(arc4random_uniform(10000) + 1),
                                   userId: Int(arc4random_uniform(100) + 1),
                                   title: "abcdef",
                                   body: "\(arc4random_uniform(1000000))")
                var error: LocalProviderError?
                
                repo.save(post: newPost)
                    .flatMap(.latest) { repo.save(post: $0) }
                    .startWithFailed({ (err: LocalProviderError) in
                        error = err
                    })
                
                expect(error).toEventuallyNot(beNil())
            }
        }
        
        describe("fetchPost(id:_)") {
            it("should fail with .notFound if post is not found") {
                var error: LocalProviderError? = nil
                repo.fetchPost(id: Int(arc4random_uniform(10000) + 10000))
                    .startWithFailed({ (err: LocalProviderError) in
                        error = err
                    })
                
                expect(error).toEventuallyNot(beNil())
            }
            
            
            it("should fetch a saved post") {
                let newPost = Post(id: Int(arc4random_uniform(10000) + 1),
                                   userId: Int(arc4random_uniform(100) + 1),
                                   title: "abcdef",
                                   body: "\(arc4random_uniform(1000000))")
                var post: Post? = nil
                
                repo.save(post: newPost)
                    .flatMap(.latest) { repo.fetchPost(id: $0.id) }
                    .startWithResult({ (result: Result<Post, LocalProviderError>) in
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
        
        describe("fetchPosts(page:, limit:)") {
            it("should fetch a list of posts") {
                var posts: [Post] = []
                
                SignalProducer<[Int], LocalProviderError>(value: Array<Int>(repeating: 0, count: 100))
                    .flatten()
                    .map { _ -> Post in
                        return Post(id: Int(arc4random_uniform(50000) + 10000),
                             userId: Int(arc4random_uniform(100) + 1),
                             title: "abcdef",
                             body: "\(arc4random_uniform(1000000))")
                    }
                    .map { post -> SignalProducer<Post, LocalProviderError> in
                        return repo
                            .save(post: post)
                            .flatMapError({ (error: LocalProviderError) -> SignalProducer<Post, LocalProviderError> in
                                switch error {
                                case .alreadyExists:
                                    return SignalProducer<Post, LocalProviderError>(value: post)
                                default:
                                    return SignalProducer<Post, LocalProviderError>(error: error)
                                }
                            })
                    }
                    .collect()
                    .map { SignalProducer.zip($0) }
                    .flatMap(.latest) { $0 }
                    .then( repo.fetchPosts(page: 1, limit: 20) )
                    .startWithResult({ (result: Result<[Post], LocalProviderError>) in
                        switch result {
                        case .success(let value):
                            posts = value
                        default:
                            break
                        }
                    })
                
                expect(posts.count).to(beGreaterThan(0))
                expect(posts.count).toNot(beGreaterThan(20))
            }
        }
    }
}
