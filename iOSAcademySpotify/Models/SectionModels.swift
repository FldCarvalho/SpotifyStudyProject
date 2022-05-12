//
//  SectionModels.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 17/04/22.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
