//
//  Post.swift
//  MVVMApp
//
//  Created by George Kaimakas on 30/03/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Argo
import Curry
import Foundation
import Runes

public struct Post {
    public let id: Int
    public let userId: Int
    public let title: String?
    public let body: String?
    
    public init(id: Int,
                userId: Int,
                title: String?,
                body: String?) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
    
    public init(_ mo: PostMO) {
        self.id = Int(mo.id)
        self.userId = Int(mo.userId)
        self.title = mo.title
        self.body = mo.body
    }
}

extension Post: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Post> {
        return curry(self.init)
        <^> json <| "id"
        <*> json <| "userId"
        <*> json <|? "title"
        <*> json <|? "body"
    }
}
