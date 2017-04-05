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
