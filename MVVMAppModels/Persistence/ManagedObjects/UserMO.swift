//
//  UserMO.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import CoreData
import Foundation

public class UserMO: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var website: String?
    @NSManaged public var address_street: String?
    @NSManaged public var address_suite: String?
    @NSManaged public var address_city: String?
    @NSManaged public var address_zipCode: String?
    @NSManaged public var address_geo_lat: NSNumber?
    @NSManaged public var address_geo_lng: NSNumber?
    @NSManaged public var company_name: String?
    @NSManaged public var company_catchPhrase: String?
    @NSManaged public var company_bs: String?
    
    public func inflate(user: User) {
        self.id = Int64(user.id)
        self.name = user.name
        self.username = user.username
        self.email = user.email
        self.phone = user.phone
        self.website = user.website
        self.address_street = user.address?.street
        self.address_suite = user.address?.suite
        self.address_city = user.address?.city
        self.address_zipCode = user.address?.zipCode
        self.address_geo_lat = user.address?.geo?.lat != nil ? NSNumber(floatLiteral: user.address!.geo!.lat!) : nil
        self.address_geo_lng = user.address?.geo?.lng != nil ? NSNumber(floatLiteral: user.address!.geo!.lng!) : nil
        self.company_name = user.company?.name
        self.company_catchPhrase = user.company?.catchPhrase
        self.company_bs = user.company?.bs
    }
    
}
