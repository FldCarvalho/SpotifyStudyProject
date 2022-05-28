//
//  FeaturedPlaylistsModels.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 15/05/22.
//

import UIKit

enum FeaturedPlaylists {
    enum PlaylistsModel {
        struct Response: Codable {
            let items: [Playlist]
        }
    }
    enum Playlists {
        struct Request {
            var endpoint: String {
                return APIEndpoints.featuredPlaylists.rawValue + "?limit=50"
            }
        }
        struct Response: Codable {
            let playlists: PlaylistsModel.Response
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
