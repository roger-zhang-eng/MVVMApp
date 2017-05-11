//
//  UserViewModel.swift
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

public class UserViewModel {
    public let id: Property<Int>
    public let name: Property<String?>
    public let username: Property<String?>
    public let email: Property<String?>
    public let phone: Property<String?>
    public let website: Property<String?>
    public let address: Property<AddressViewModel?>
    public let company: Property<CompanyViewModel?>

    public init(user: User) {
        id = Property(value: user.id)
        name = Property(value: user.name)
        username = Property(value: user.username)
        email = Property(value: user.email)
        phone = Property(value: user.phone)
        website = Property(value: user.website)
        address = Property(value: AddressViewModel(address: user.address))
        company = Property(value: CompanyViewModel(company: user.company))
        
    }
}
