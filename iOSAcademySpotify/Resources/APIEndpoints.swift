//
//  APIEndpoints.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 26/04/22.
//

import Foundation

public enum APIEndpoints: String {
    case newReleases = "/browse/new-releases"
    case featuredPlaylists = "/browse/featured-playlists"
    case recommendedGenres = "/recommendations/available-genre-seeds"
    case recommendations = "/recommendations?limit=40&seed_genres="
}
