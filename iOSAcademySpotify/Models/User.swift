//
//  User.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 24/04/22.
//

import Foundation

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
