//
//  Address.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation

public struct Address: Codable {
    
    public let street: String?
    public let suite: String?
    public let city: String?
    public let zipCode: String?
    public let location: Location?
    
    public init(street: String?,
                suite: String?,
                city: String?,
                zipCode: String?,
                location: Location?) {
        
        self.street = street
        self.suite = suite
        self.city = city
        self.zipCode = zipCode
        self.location = location
    }
}
