//
//  PostListViewModel.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppModels
import ReactiveCocoa
import ReactiveSwift
import Result

public class PostListViewModel {
    private let postProvider: PostProvider
    private let userProvider: UserProvider
    private let commentProvider: CommentProvider
    
    private let page = MutableProperty<Int>(1)
    private let limit = MutableProperty<Int>(20)
    private let hasMoreEntries = MutableProperty<Bool>(true)
    
    private let _posts = MutableProperty<[PostViewModel]>([])
    
    public var fetchPosts: Action<Void, [PostViewModel], ProviderError>!
    public var posts: Property<[PostViewModel]>
    
    public init(postProvider: PostProvider,
                userProvider: UserProvider,
                commentProvider: CommentProvider) {
        
        self.postProvider = postProvider
        self.userProvider = userProvider
        self.commentProvider = commentProvider
        
        self.posts = Property<[PostViewModel]>(capturing: _posts)
        
        
        self.fetchPosts = Action<Void, [PostViewModel], ProviderError>(enabledIf: hasMoreEntries) { _ -> SignalProducer<[PostViewModel], ProviderError> in
            
            let producer = postProvider
                .fetchPosts(page: self.page.value, limit: self.limit.value)
                .on(value: { results in
                    self.hasMoreEntries.value = results.count > 0
                    self.page.value = self.page.value + 1
                })
                .flatten()
                .flatMap(.merge) { (post: Post) in
                    return userProvider.fetchUser(id: post.userId)
                        .map { (post: post, user: $0) }
                }
                .map { PostViewModel(post: $0.post, user: $0.user, commentProvider: commentProvider) }
                .collect()
                .on(value: { results in
                    self._posts.value = self._posts.value + results
                })
            
            
            return producer
        }
    }
}
