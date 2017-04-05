//
//  UserRouter.swift
//  MVVMApp
//
//  Created by George Kaimakas on 05/04/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import Foundation

enum UserRouter: URLRequestConvertible {
    case fetchUser(Int)
    
    var httpMethod: Alamofire.HTTPMethod {
        return .get
    }
    
    var encoding: Alamofire.ParameterEncoding {
        switch self {
        case .fetchUser(_):
            return URLEncoding.default
        }
    }
    
    var requestConfiguration: (path: String, parameters: [String: AnyObject]?) {
        switch self {
            
        case .fetchUser(let id):
            return (
                path: "http://jsonplaceholder.typicode.com/users/\(id)",
                parameters: nil
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let result = self.requestConfiguration
        
        let url = Foundation.URL(string: result.path)!
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = self.httpMethod.rawValue
        
        let request = try encoding.encode(urlRequest, with: result.parameters)
        return request
    }
}
