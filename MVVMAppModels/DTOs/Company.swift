//
//  Company.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Argo
import Curry
import Foundation
import Runes

public struct Company {
    public let name: String?
    public let catchPhrase: String?
    public let bs: String?
    
    public init(name: String?,
                catchPhrase: String?,
                bs: String?) {
        
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}

extension Company: Decodable {
    public static func decode(_ json: JSON) -> Decoded<Company> {
        return curry(self.init)
            <^> json <|? "name"
            <*> json <|? "catchPhrase"
            <*> json <|? "bs"
    }
}
