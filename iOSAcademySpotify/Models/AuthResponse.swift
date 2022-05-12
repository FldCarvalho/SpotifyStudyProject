//
//  AuthResponse.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 15/04/22.
//

import UIKit

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
