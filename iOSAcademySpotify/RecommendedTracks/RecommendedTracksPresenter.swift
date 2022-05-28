//
//  RecommendedTracksPresenter.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 12/05/22.
//

import UIKit

protocol RecommendedTracksPresentationLogic {
    func presentRecommendedTracks(tracks: [AudioTrack])
}

class RecommendedTracksPresenter: RecommendedTracksPresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    func presentRecommendedTracks(tracks: [AudioTrack]) {
        
    }
}
