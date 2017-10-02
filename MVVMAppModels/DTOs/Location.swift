//
//  Location.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation

public struct Location: Codable {
    public let latitude: Double?
    public let longitude: Double?
    
    public init(latitude: String,
                longitude: String) {
        
        self.latitude = Double(latitude)
        self.longitude = Double(longitude)
    }
    
    public init(latitude: Double?,
                longitude: Double?) {
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
