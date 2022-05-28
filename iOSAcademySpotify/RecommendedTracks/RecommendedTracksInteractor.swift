//
//  RecommendedTracksInteractor.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 12/05/22.
//

import UIKit

protocol RecommendedTracksBusinessLogic {
    func doRecommendedGenres()
}

protocol RecommendedTracksDataStore {
    
}

class RecommendedTracksInteractor: RecommendedTracksBusinessLogic, RecommendedTracksDataStore {
    
    var presenter: RecommendedTracksPresentationLogic?
    var worker = RecommendedTracksWorker()
    var response: RecommendedTracks.Tracks.Response?
    
    func doRecommendedGenres() {
        worker.getAPI(request: GenericGetModel.Model.Request<RecommendedTracks.Genres.Response>.init(endpoint: RecommendedTracks.Tracks.Request().genresEndpoint, completion: { [weak self] result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                self?.doRecommendedTracks(with: seeds.joined(separator: ","))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }))
    }
    
    private func doRecommendedTracks(with genres: String) {
        worker.getAPI(request: GenericGetModel.Model.Request<RecommendedTracks.Tracks.Response>.init(endpoint: RecommendedTracks.Tracks.Request().recommendationsEndpoint + genres, completion: { [weak self] result in
            switch result {
            case .success(let model):
                self?.presenter?.presentRecommendedTracks(tracks: model.tracks)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }))
    }
}
