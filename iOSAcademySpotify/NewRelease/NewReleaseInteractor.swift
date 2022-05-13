//
//  NewReleasesInteractor.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/05/22.
//

import UIKit

protocol NewReleasesBusinessLogic {
    func doNewReleases()
}

protocol NewReleasesDataStore {
    
}

class NewReleasesInteractor: NewReleasesBusinessLogic, NewReleasesDataStore {
    
    var presenter: NewReleasesPresentationLogic?
    let worker = NewReleasesWorker()
    var newReleases: NewReleasesResponse?
    
    func doNewReleases() {
        worker.getAPI(request: GenericGetModel.Model.Request<NewReleasesResponse>.init(endpoint: APIEndpoints.newReleases.rawValue + "?limit=50", completion: { result in
            
            switch result {
            case .success(let model):
                self.caseNewReleasesSuccess(model)
            case .failure(let error):
                self.caseNewReleasesFailure(error)
            }
        }))
    }
    
    private func caseNewReleasesSuccess(_ model: NewReleasesResponse) {
        self.newReleases = model
        presenter?.presentNewReleases(newAlbums: model.albums.items)
    }
    
    private func caseNewReleasesFailure(_ error: Error) {
    }
}
