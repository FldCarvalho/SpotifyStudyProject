//
//  GenericGetModel.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 25/04/22.
//

import UIKit

enum GenericGetModel {
    enum Model {
        struct Request<T: Codable> {
            let endpoint: String
            let completion: (_ result: Result<T, Error>) -> Void
        }
    }
}
