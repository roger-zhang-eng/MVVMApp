//
//  PostViewModel.swift
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

public class PostViewModel {
    public let id: Property<Int>
    public let title: Property<String?>
    public let body: Property<String?>
    public let user: Property<UserViewModel>
    
    public let comments: Property<[CommentViewModel]>
    public var fetchComments: Action<Void, [CommentViewModel], ProviderError>!
    
    private let _comments: MutableProperty<[CommentViewModel]>
    
    public init(post: Post, user: User, commentProvider: CommentProvider) {
        id = Property(value: post.id)
        title = Property(value: post.title)
        body = Property(value: post.body)
        self.user = Property<UserViewModel>(value: UserViewModel(user: user))
        
        _comments = MutableProperty([])
        comments = Property(_comments)
        
        fetchComments = Action(enabledIf: comments.map({ $0.count == 0 })) { _ -> SignalProducer<[CommentViewModel], ProviderError> in
            
            return commentProvider
                .fetchComments(postId: post.id)
                .flatten()
                .map { CommentViewModel(comment: $0) }
                .collect()
        }
        
        _comments <~ fetchComments.values
    }
}
