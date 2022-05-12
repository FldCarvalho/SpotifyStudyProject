//
//  NewReleasesResponse.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 22/04/22.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

