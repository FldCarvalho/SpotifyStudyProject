//
//  FeaturedPlaylistsPresenter.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 15/05/22.
//

import UIKit

protocol FeaturedPlaylistsPresentationLogic {
    func presentFeaturedPlaylists(with playlists: [Playlist])
}

class FeaturedPlaylistsPresenter: FeaturedPlaylistsPresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentFeaturedPlaylists(with playlists: [Playlist]) {
        //print("PLAYLISTS SUCCESS PLAYLISTS SUCCESS PLAYLISTS SUCCESS PLAYLISTS SUCCESS PLAYLISTS SUCCESS PLAYLISTS SUCCESS PLAYLISTS SUCCESS PLAYLISTS SUCCESS \(playlists)")
    }
}
