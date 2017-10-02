//
//  Company.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Foundation

public struct Company: Codable {
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
