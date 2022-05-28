//
//  RecommendedTracksModels.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 12/05/22.
//

import UIKit

enum RecommendedTracks {
    enum Genres {
        struct Response: Codable {
            let genres: [String]
        }
    }
    enum Tracks {
        struct Request {
            var genresEndpoint: String {
                return APIEndpoints.recommendedGenres.rawValue + "?limit=50"
            }
            var recommendationsEndpoint: String {
                return APIEndpoints.recommendations.rawValue + "?limit=50"
            }
        }
        struct Response: Codable {
            let tracks: [AudioTrack]
        }
        struct ViewModel {
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

