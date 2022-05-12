//
//  HTTPMethod.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 25/04/22.
//

import Foundation

@objc public enum HTTPMethod: Int {
    case get
    case post
    case put
    case patch
    case delete
    
    public func toString() -> String {
        switch self {
        case .get:     return "GET"
        case .post:    return "POST"
        case .put:     return "PUT"
        case .patch:   return "PATCH"
        case .delete:  return "DELETE"
        }
    }
}
