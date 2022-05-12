//
//  ViewCode.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 15/04/22.
//

import UIKit

public protocol iOSViewCode {
    func setupView()
    func setupHierarchy()
    func setupConstraints()
    func additionalSetup()
}

public extension iOSViewCode {
    func setupView() {
        setupHierarchy()
        setupConstraints()
        additionalSetup()
    }
    func additionalSetup() {}
}
