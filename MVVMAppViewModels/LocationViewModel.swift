//
//  LocationViewModel.swift
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

public class LocationViewModel {
    public let latitude: Property<Double?>
    public let longitude: Property<Double?>
    
    public init(location: Location) {
        latitude = Property(value: location.latitude)
        longitude = Property(value: location.longitude)
    }
    public convenience init?(location: Location?) {
        guard let location = location else {
            return nil
        }
        
        self.init(location: location)
    }
}
