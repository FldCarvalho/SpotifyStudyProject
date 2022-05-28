//
//  FeaturedPlaylistsInteractor.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 15/05/22.
//

import UIKit

protocol FeaturedPlaylistsBusinessLogic {
    func doFeaturedPlaylists()
}

protocol FeaturedPlaylistsDataStore {
    
}

class FeaturedPlaylistsInteractor: FeaturedPlaylistsBusinessLogic {
    
    var presenter: FeaturedPlaylistsPresentationLogic?
    var worker = FeaturedPlaylistsWorker()
    var playlists: FeaturedPlaylists.Playlists.Response?
    
    func doFeaturedPlaylists() {
        worker.getAPI(request: GenericGetModel.Model.Request<FeaturedPlaylists.Playlists.Response>.init(endpoint: FeaturedPlaylists.Playlists.Request().endpoint, completion: { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.presenter?.presentFeaturedPlaylists(with: model.playlists.items)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }))
    }
}
