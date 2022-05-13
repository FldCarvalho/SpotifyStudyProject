//
//  APICaller.swift
//  iOSAcademySpotify
//
//  Created by Felipe Lima de Carvalho (P) on 11/04/22.
//

import UIKit

class APICaller {
    
    // MARK: - Properties
    static let shared = APICaller()
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
        case failedToRefreshToken
    }
    
    // MARK: - Functions
    public func getAPI<T: Codable>(recall: Int = 0, request: GenericGetModel.Model.Request<T>) {
        createRequest(with: URL(string: Constants.baseAPIURL + request.endpoint), type: HTTPMethod.get) { finalRequest in
            URLSession.shared.dataTask(with: finalRequest) { data, _ , error in
                guard let data = data, error == nil else {
                    request.completion(.failure(APIError.failedToGetData))
                    return
                }
                
                guard recall > 0  else {
                    self.checkForRefreshedToken(data: data) { result in
                        guard result else {
                            do {
                                let result = try JSONDecoder().decode(T.self, from: data)
                                request.completion(.success(result))
                            } catch {
                                request.completion(.failure(error))
                            }
                            return
                        }
                        APICaller.shared.getAPI(recall: recall + 1, request: request)
                    }
                    return
                }
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    request.completion(.success(result))
                } catch {
                    request.completion(.failure(error))
                }
                
            }.resume()
        }
    }
    
    // MARK: - Private Functions
    private func checkForRefreshedToken(data: Data, completion: @escaping (Bool) -> Void) {
        do {
            let errorModel = try JSONDecoder().decode(ErrorAPIReturn.self, from: data)
            if errorModel.error.status == 401 {
                AuthManager.shared.refreshIfNeeded { result in
                    completion(result)
                }
            }
        } catch {
            completion(false)
        }
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.toString()
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
