//
//  Location.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Argo
import Curry
import Foundation
import Runes

public struct Location {
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

extension Location: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Location> {
        return curry(self.init)
            <^> json <| "lat"
            <*> json <| "lng"
    }
}
