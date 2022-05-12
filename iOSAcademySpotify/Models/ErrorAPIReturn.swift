//
//  ErrorAPIReturn.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 20/04/22.
//

import Foundation

struct ErrorAPIReturn: Codable {
    let error: APIError
}

struct APIError: Codable {
    var status: Int
    var message: String
}
