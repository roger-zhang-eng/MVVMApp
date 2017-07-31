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
    public static func requestFetchPost(id: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.predicate = NSPredicate(format: "id == \(id)")
        return request
    }
    
    public static func requestFetchPagedPosts(page: Int, limit: Int) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: self))
        request.fetchLimit = limit
        request.fetchBatchSize = limit
        request.fetchOffset = page * limit
        request.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true)
        ]
        return request
    }
    
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
