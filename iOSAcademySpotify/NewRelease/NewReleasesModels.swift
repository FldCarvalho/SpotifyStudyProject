//
//  NewReleasesModels.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/05/22.
//

import UIKit

enum NewReleases {
    enum Releases {
        struct Request {
            var endpoint: String {
                return APIEndpoints.newReleases.rawValue + "?limit=50"
            }
        }
        struct Response {
        }
        struct ViewModel {
            let name: String
            let artworkURL: URL?
            let numberOfTracks: Int
            let artistName: String
        }
        struct ResponseError {
        }
        struct ViewModelError {
        }
    }
}
