//
//  User.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Argo
import Curry
import Foundation
import Runes

public struct User {
    public let id: Int
    public let name: String?
    public let username: String?
    public let email: String?
    public let phone: String?
    public let website: String?
    public let address: Address?
    public let company: Company?
    
    public init(id: Int,
                name: String?,
                username: String?,
                email: String?,
                phone: String?,
                website: String?,
                address: Address?,
                company: Company?) {
        
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.address = address
        self.company = company
    }
    
    public init(_ mo: UserMO) {
        self.id = Int(mo.id)
        self.name = mo.name
        self.username = mo.username
        self.email = mo.email
        self.phone = mo.phone
        self.website = mo.website
        
        self.address = Address(street: mo.address_street,
                               suite: mo.address_suite,
                               city: mo.address_city,
                               zipCode: mo.address_zipCode,
                               geo: Address.Geo(lat: mo.address_geo_lat as? Double,
                                                lng: mo.address_geo_lng as? Double)
            )
        
        self.company = Company(name: mo.company_name,
                               catchPhrase: mo.company_catchPhrase,
                               bs: mo.company_catchPhrase)
    }
}

extension User: Decodable {
    public static func decode(_ json: JSON) -> Decoded<User> {
        return curry(self.init)
            <^> json <| "id"
            <*> json <|? "name"
            <*> json <|? "username"
            <*> json <|? "email"
            <*> json <|? "phone"
            <*> json <|? "website"
            <*> json <|? "address"
            <*> json <|? "company"
    }
}
