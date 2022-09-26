//
//  NetworkManager.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 26/09/2022.
//

import Foundation

struct Constants {
    static let BASE_URL = "https://api.github.com"
    static let SEARCH_URL = "/search/users"
    static let LOCATION = "lagos"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func getListOfLagosDevs(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)\(Constants.SEARCH_URL)?q=lagos") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                if let results = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let listing = results["items"] as? [[String: Any]] {
                        DBManager.shared.saveDevListing(results: listing)
                    }
                    completion(.success(results))
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getDevDetails(urlString: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                if let results = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let listing = results["items"] as? [[String: Any]] {
                        DBManager.shared.saveDevListing(results: listing)
                    }
                    completion(.success(results))
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
