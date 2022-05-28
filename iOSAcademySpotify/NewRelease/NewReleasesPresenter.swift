//
//  NewReleasesPresenter.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/05/22.
//

import UIKit

protocol NewReleasesPresentationLogic {
    func presentNewReleases(newAlbums: [Album])
    func presentNewReleasesError(response: NewReleases.Releases.ResponseError)
}

class NewReleasesPresenter: NewReleasesPresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentNewReleases(newAlbums: [Album]) {
        let viewModels = newAlbums.compactMap {
            return NewReleases.Releases.ViewModel(
                name: $0.name,
                artworkURL: URL(string: $0.images.first?.url ?? ""),
                numberOfTracks: $0.total_tracks,
                artistName: $0.artists.first?.name ?? "-"
            )
        }
        viewController?.displayNewReleases(viewModels: viewModels)
    }
    
    func presentNewReleasesError(response: NewReleases.Releases.ResponseError) {
        let viewModel = NewReleases.Releases.ViewModelError(status: response.status, message: response.message)
        viewController?.displayNewReleasesError(viewModel: viewModel)
    }
}
