//
//  DataContainer.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//
import CoreData
import Foundation
import ReactiveSwift
import Result

public final class DataContainer: NSPersistentContainer {
    public init(name: String) {
        guard let modelURL =  Bundle(for: type(of: self))
            .url(forResource: "DataModel", withExtension: "momd") else {
                fatalError("Error loading model from bundle")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing managedObjectModel from: \(modelURL)")
        }
        
        super.init(name: name, managedObjectModel: managedObjectModel)
        
        loadPersistentStores { (store: NSPersistentStoreDescription, error:Error?) in
        }
    }
    
    public func newObject<T: NSManagedObject>(type: T.Type) -> T {
        return NSEntityDescription
            .insertNewObject(forEntityName: String(describing: type.self), into: viewContext) as! T
    }
    
    public func fetchObjects<T: NSManagedObject>(type: T.Type, request: NSFetchRequest<NSFetchRequestResult>) throws -> [T] {
        return try viewContext.fetch(request) as! [T]
    }
}
