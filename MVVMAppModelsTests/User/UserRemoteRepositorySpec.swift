//
//  UserRemoteRepositorySpec.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation
import Nimble
import Quick
import Result
import ReactiveSwift
@testable import MVVMAppModels

public class UserRemoteRepositorySpec: QuickSpec {
    
    override public func spec() {
        super.spec()
        let repo = UserRemoteRepository()
        
        describe("fetchUser(id:_)") {
            it("should fetch a user") {
                var user: User? = nil
                
                repo.fetchUser(id: 1)
                    .startWithResult({ (result: Result<User, RemoteProviderError>) in
                        switch result {
                        case.success(let value):
                            user = value
                        default:
                            user = nil
                        }
                    })
                
                expect(user).toEventuallyNot(beNil(), timeout: 20)
            }
        }
    }
    
}
