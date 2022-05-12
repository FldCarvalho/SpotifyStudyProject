//
//  TabBarViewController.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewControllers()
    }
    
    // MARK: - Functions
    func setupViewControllers() {
        viewControllers = [
            createNavController(for: HomeViewController(), title: "Home", image: UIImage(systemName: "house")),
            createNavController(for: SearchViewController(), title: "Search", image: UIImage(systemName: "magnifyingglass")),
            createNavController(for: LibraryViewController(), title: "Library", image: UIImage(systemName: "music.note.list"))
        ]
    }
    
    // MARK: - Private Functions
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                 title: String,
                                                 image: UIImage?) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem = UITabBarItem(title: title, image: image, tag: 1)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.tintColor = .label
        rootViewController.navigationItem.title = title
        return navController
    }
}

// MARK: - ViewCode
extension TabBarViewController: iOSViewCode {
    func setupHierarchy() {
    }
    
    func setupConstraints() {
    }
    
    func additionalSetup() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
    }
}
