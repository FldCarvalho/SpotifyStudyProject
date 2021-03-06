//
//  NewReleasesModels.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/05/22.
//

import UIKit

enum NewReleases {
    enum Albums {
        struct Response: Codable {
            let items: [Album]
        }
    }
    enum Releases {
        struct Request {
            var endpoint: String {
                return APIEndpoints.newReleases.rawValue + "?limit=50"
            }
        }
        struct Response: Codable {
            let albums: Albums.Response
        }
        struct ViewModel {
            let name: String
            let artworkURL: URL?
            let numberOfTracks: Int
            let artistName: String
        }
        struct ResponseError {
            let status: Int
            let message: String
        }
        struct ViewModelError {
            let status: Int
            let message: String
        }
    }
}
