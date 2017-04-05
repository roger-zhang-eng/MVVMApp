//
//  PostMO.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation

public class PostMO: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    
    public func inflate(post: Post) {
        self.id = Int64(post.id)
        self.userId = Int64(post.userId)
        self.title = post.title
        self.body = post.body
    }
}
