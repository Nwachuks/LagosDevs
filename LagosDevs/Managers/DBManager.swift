//
//  DBManager.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 26/09/2022.
//

import Foundation
import RealmSwift

class DBManager {
    static let shared = DBManager()
    
    private var database: Realm
    
    private init() {
        database = try! Realm()
    }
    
    func saveDevListing(results: [[String: Any]]) {
        for result in results {
            guard let id = result["id"] as? Int,
                  let username = result["login"] as? String,
                  let url = result["url"] as? String,
                  let htmlUrl = result["html_url"] as? String else { return }
            
            let githubUser = GithubUser(id: id, username: username, url: url, htmlUrl: htmlUrl)
            try! database.write {
                database.create(GithubUser.self, value: githubUser, update: .modified)
            }
        }
    }
    
    func updateSingleDev(result: [String: Any]) {
        
    }
    
    func getDevListing() -> Results<GithubUser> {
        let devsList = database.objects(GithubUser.self)
        return devsList
    }
}
