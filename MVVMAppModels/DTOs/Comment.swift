//
//  Comment.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation

public struct Comment: Codable {
    public let postId: Int
    public let id: Int
    public let name: String?
    public let email: String?
    public let body: String?
    
    public init(postId: Int,
                id: Int,
                name: String?,
                email: String?,
                body: String?) {
        
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
    public init(_ mo: CommentMO) {
        postId = Int(mo.postId)
        id = Int(mo.id)
        name = mo.name
        email = mo.email
        body = mo.body
    }
}

