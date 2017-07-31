//
//  CommentViewModel.swift
//  MVVMApp
//
//  Created by George Kaimakas on 31/07/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppModels
import ReactiveCocoa
import ReactiveSwift
import Result

public class CommentViewModel {
    public let postId: Property<Int>
    public let id: Property<Int>
    public let name: Property<String?>
    public let email: Property<String?>
    public let body: Property<String?>
    
    public init(comment: Comment) {
        self.postId = Property(value: comment.postId)
        self.id = Property(value: comment.id)
        self.name = Property(value: comment.name)
        self.email = Property(value: comment.email)
        self.body = Property(value: comment.body)
    }
    
    public convenience init?(comment: Comment?) {
        guard let comment = comment else {
            return nil
        }
        
        self.init(comment: comment)
    }
}
