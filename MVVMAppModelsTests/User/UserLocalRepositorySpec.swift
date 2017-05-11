//
//  UserLocalRepositorySpec.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Argo
import Curry
import Foundation
import Nimble
import Quick
import Runes
import Result
import ReactiveSwift
@testable import MVVMAppModels

public class UserLocalRepositorySpec: QuickSpec {
    override public func spec() {
        super.spec()
        
        let container = DataContainer(name: "UserLocalRepositorySpec")
        let repo = UserLocalRepository(container: container)
        
        describe("save(user:_)"){
            it("should save a user") {
                var user: User! = nil
                let location = Location(latitude: 20,
                    longitude: 23)
                let newUser = User(id: Int(arc4random_uniform(10_000)),
                                   name: "\(arc4random_uniform(1000))",
                                   username: "\(arc4random_uniform(1000))",
                                   email: "\(arc4random_uniform(1000))",
                                   phone: "\(arc4random_uniform(1000))",
                                   website: "\(arc4random_uniform(1000))",
                                   address: Address(street: "\(arc4random_uniform(1000))",
                                        suite: "\(arc4random_uniform(1000))",
                                        city: "\(arc4random_uniform(1000))",
                                        zipCode: "\(arc4random_uniform(1000))",
                                        location: location),
                                   company: Company(name: "\(arc4random_uniform(1000))",
                                        catchPhrase: "\(arc4random_uniform(1000))",
                                        bs: "\(arc4random_uniform(1000))"))
                
                repo.save(user: newUser)
                    .startWithResult({ (result: Result<User, LocalProviderError>) in
                        switch result {
                        case .success(let value):
                            user = value
                        case .failure(_):
                            user = nil
                        }
                    })
                
                expect(user).toEventuallyNot(beNil())
            }
            
            it("should fail if the user exists"){
                
                let location = Location(latitude: 20,
                                        longitude: 23)
                let newUser = User(id: 0,
                                   name: "\(arc4random_uniform(1000))",
                    username: "\(arc4random_uniform(1000))",
                    email: "\(arc4random_uniform(1000))",
                    phone: "\(arc4random_uniform(1000))",
                    website: "\(arc4random_uniform(1000))",
                    address: Address(street: "\(arc4random_uniform(1000))",
                        suite: "\(arc4random_uniform(1000))",
                        city: "\(arc4random_uniform(1000))",
                        zipCode: "\(arc4random_uniform(1000))",
                        location: location),
                    company: Company(name: "\(arc4random_uniform(1000))",
                        catchPhrase: "\(arc4random_uniform(1000))",
                        bs: "\(arc4random_uniform(1000))"))
                
                var error: LocalProviderError? = nil
                
                repo.save(user: newUser)
                    .flatMap(.latest) { repo.save(user: $0)}
                    .startWithFailed({ (err: LocalProviderError) in
                        error = err
                    })
                
                expect(error).toEventuallyNot(beNil())
            }
        }
    }
}
