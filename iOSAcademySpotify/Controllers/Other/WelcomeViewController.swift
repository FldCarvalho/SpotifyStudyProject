//
//  WelcomeViewController.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController, SignInProtocol {
    
    // MARK: - Views
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Actions
    @objc func didTapSignInButton() {
        let vc = AuthViewController()
        vc.delegate = self
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Functions
    func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}

// MARK: - ViewCode
extension WelcomeViewController: iOSViewCode {
    func setupHierarchy() {
        view.addSubview(signInButton)
    }
    
    func setupConstraints() {
        signInButton.snp.makeConstraints { make in
            make.bottom.equalTo(additionalSafeAreaInsets.bottom).inset(30)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
    }
    
    func additionalSetup() {
        title = "Spotify"
        view.backgroundColor = .systemGreen
    }
}
