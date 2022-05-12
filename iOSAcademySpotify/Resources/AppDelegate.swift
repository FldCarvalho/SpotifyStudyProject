//
//  AppDelegate.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if AuthManager.shared.isSignedIn {
            window.rootViewController = TabBarViewController()
        } else {
            let navVC = UINavigationController(rootViewController: WelcomeViewController())
            navVC.navigationBar.prefersLargeTitles = true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navVC
        }
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

