//
//  FeaturedPlaylistsResponse.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 22/04/22.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}
