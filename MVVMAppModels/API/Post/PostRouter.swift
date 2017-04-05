//
//  PostRouter.swift
//  MVVMApp
//
//  Created by George Kaimakas on 30/03/2017.
//  Copyright © 2017 George Kaimakas. All rights reserved.
//

import Alamofire
import Foundation

enum PostRouter: URLRequestConvertible {
    case fetchPosts(Int, Int)
    case fetchPost(Int)
    
    var httpMethod: Alamofire.HTTPMethod {
        return .get
    }
    
    var encoding: Alamofire.ParameterEncoding {
        switch self {
        case .fetchPosts(_, _):
            return URLEncoding.default
        case .fetchPost(_):
            return URLEncoding.default
        }
    }
    
    var requestConfiguration: (path: String, parameters: [String: AnyObject]?) {
        switch self {
        case .fetchPosts(let page, let limit):
            return (
                path: "http://jsonplaceholder.typicode.com/posts",
                parameters: [
                    "_page": page as AnyObject,
                    "_limit": limit as AnyObject
                ]
            )
            
        case .fetchPost(let id):
            return (
                path: "http://jsonplaceholder.typicode.com/posts/\(id)",
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
