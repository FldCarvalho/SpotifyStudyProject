//
//  AuthViewController.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit
import WebKit

protocol SignInProtocol {
    func handleSignIn(success: Bool)
}

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Views
    private lazy var webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView =  WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Properties
    var delegate: SignInProtocol?

    // MARK: - ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    // MARK: - Functions
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        // Exchange the code for access token
        guard let code =  URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        webView.isHidden = true
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.delegate?.handleSignIn(success: success)
            }
        }
    }
}

// MARK: - ViewCode
extension AuthViewController: iOSViewCode {
    func setupHierarchy() {
        view.addSubview(webView)
    }
    
    func setupConstraints() {
    }
    
    func additionalSetup() {
        title = "Sign In"
        view.backgroundColor = .systemBackground
    }
}
