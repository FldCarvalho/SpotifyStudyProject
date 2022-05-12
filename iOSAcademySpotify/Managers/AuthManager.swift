//
//  AuthManager.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit

final class AuthManager {
    
    // MARK: - Properties
    static let shared = AuthManager()
    struct Constants {
        static let clientID = "324236d372554a86853f89e17baeebb3"
        static let clientSecret = "4f0985bbcc8f404e8ce16b96675d26bb"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.iosacademy.io"
        static let scopes: String =  [
            "user-read-private",
            "playlist-modify-public",
            "playlist-read-private",
            "playlist-modify-private",
            "user-follow-read",
            "user-library-modify",
            "user-library-read",
            "user-read-email"
        ].joined(separator: "%20")
    }
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    // MARK: - Private Properties
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    // MARK: - Functions
    public func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        // Get Token
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        let result = setURLHeadersRequest(with: url)
        
        switch result {
        case .success(var request):
            request.httpMethod = "POST"
            request.httpBody = components.query?.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _ , error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self?.cacheToken(result: result)
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            task.resume()
        case.failure(let error):
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    // Supplies valid token to be used with API Calls
    public func withValidToken(completion: @escaping (String) -> Void) {
        if let token = accessToken {
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = refreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        let result = setURLHeadersRequest(with: url)
        
        switch result {
        case .success(var request):
            request.httpMethod = "POST"
            request.httpBody = components.query?.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _ , error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                    self?.cacheToken(result: result)
                    completion(true)
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            task.resume()
        case.failure(let error):
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    // MARK: - Private Functions
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token,
                                       forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken,
                                           forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
    
    private func setURLHeadersRequest(with url: URL) -> Result<URLRequest, Error> {
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Failure to get base64")
            return .failure(urlRequestGeneratorError.failureToSetAuthorizationHeader)
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        return .success(request)
    }
}

// MARK: - Request Errors
enum urlRequestGeneratorError: Error {
    case failureToSetAuthorizationHeader
}
