//
//  Address.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Argo
import Curry
import Foundation
import Runes

public struct Address {
    public struct Geo {
        public let lat: Double?
        public let lng: Double?
        
        public init(lat: String,
                    lng: String) {
            
            self.lat = Double(lat)
            self.lng = Double(lng)
        }
        
    }
    
    public let street: String?
    public let suite: String?
    public let city: String?
    public let zipCode: String?
    public let geo: Geo?
    
    public init(street: String?,
                suite: String?,
                city: String?,
                zipCode: String?,
                geo: Geo?) {
        
        self.street = street
        self.suite = suite
        self.city = city
        self.zipCode = zipCode
        self.geo = geo
    }
}

extension Address.Geo: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Address.Geo> {
        return curry(self.init)
            <^> json <| "lat"
            <*> json <| "lng"
    }
}

extension Address: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Address> {
        return curry(self.init)
            <^> json <|? "street"
            <*> json <|? "suite"
            <*> json <|? "city"
            <*> json <|? "zipcode"
            <*> json <|? "geo"
    }
}
