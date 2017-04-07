//
//  AddressViewModel.swift
//  MVVMApp
//
//  Created by George Kaimakas on 07/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import MVVMAppModels
import ReactiveCocoa
import ReactiveSwift
import Result

public class AddressViewModel {
    
    public let street: Property<String?>
    public let suite: Property<String?>
    public let city: Property<String?>
    public let zipCode: Property<String?>
    public let location: Property<LocationViewModel?>
    
    public init(address: Address) {
        street = Property(value: address.street)
        suite = Property(value: address.suite)
        city = Property(value: address.city)
        zipCode = Property(value: address.zipCode)
        location = Property(value: LocationViewModel(location: address.location))
    }
    
    public convenience init?(address: Address?) {
        guard let address = address else {
            return nil
        }
        
        self.init(address: address)
    }
    
}
