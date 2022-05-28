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
    var newReleases: NewReleases.Releases.Response?
    
    func doNewReleases() {
        worker.getAPI(request: GenericGetModel.Model.Request<NewReleases.Releases.Response>.init(endpoint: NewReleases.Releases.Request().endpoint, completion: { result in
            
            switch result {
            case .success(let model):
                self.caseNewReleasesSuccess(model)
            case .failure(let error):
                self.caseNewReleasesFailure(error)
            }
        }))
    }
    
    private func caseNewReleasesSuccess(_ model: NewReleases.Releases.Response) {
        self.newReleases = model
        presenter?.presentNewReleases(newAlbums: model.albums.items)
    }
    
    private func caseNewReleasesFailure(_ error: Error) {
        let error = error as NSError
        let status = error.userInfo["status"] as? Int ?? 0
        let message = error.userInfo["message"] as? String ?? ""
        
        let response = NewReleases.Releases.ResponseError(status: status, message: message)
        presenter?.presentNewReleasesError(response: response)
    }
}
