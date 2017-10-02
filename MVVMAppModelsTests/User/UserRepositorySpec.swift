
//
//  UserRepository.swift
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

public class UserRepositorySpec: QuickSpec {
    override public func spec() {
        super.spec()
        
        let local = UserLocalRepository(container: DataContainer(name: "UserRepositorySpec"))
        let remote = UserRemoteRepository()
        let provider = UserRepository(localProvider: local, remoteProvider: remote)
        
        describe("fetchUser(id:_)") {
            it("should fetch a user") {
                var user: User? = nil
                
                provider.fetchUser(id: 1)
                    .startWithResult({ (result: Result<User, ProviderError>) in
                        switch result {
                        case .success(let value):
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
