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
    
    func saveDevListing(results: [[String: Any]]) {
        for result in results {
            guard let id = result["id"] as? Int,
                  let username = result["login"] as? String,
                  let url = result["url"] as? String,
                  let htmlUrl = result["html_url"] as? String else { return }
            
            // Avatar may be optional, and made empty in this case
            let avatar = result["avatar_url"] as? String ?? ""
            
            let realm = try! Realm()
            try! realm.write {
                let githubUser = GithubUser(id: id, username: username, url: url, htmlUrl: htmlUrl, avatar: avatar)
                realm.add(githubUser, update: .modified)
            }
        }
    }
    
    func updateSingleDev(result: [String: Any]) {
        guard let id = result["id"] as? Int,
              let avatarUrl = result["avatar_url"] as? String,
              let devName = result["name"] as? String
        else { return }
        
        let repos = result["public_repos"] as? Int ?? 0
        let followers = result["followers"] as? Int ?? 0
        let following = result["following"] as? Int ?? 0
        
        // Bio is optional, and made empty in this case
        let bio = result["bio"] as? String ?? ""
        
        let realm = try! Realm()
        guard let dev = realm.objects(GithubUser.self).filter("id=%@", id).first else { return }
        
        try! realm.write {
            dev.avatarUrl = avatarUrl
            dev.name = devName
            dev.bio = bio
            dev.publicRepos = repos
            dev.followers = followers
            dev.following = following
        }
    }
    
    func getDevListing() -> Results<GithubUser> {
        let realm = try! Realm()
        let devsList = realm.objects(GithubUser.self).sorted(byKeyPath: "username", ascending: true)
        return devsList
    }
    
    func toggleDevFavorited(id: Int, isFavorited: Bool) {
        let realm = try! Realm()
        guard let dev = realm.objects(GithubUser.self).filter("id=%@", id).first else { return }
        try! realm.write {
            dev.isFavorited = isFavorited
        }
    }
    
    func clearAllFavorites() {
        let realm = try! Realm()
        let devsList = realm.objects(GithubUser.self)
        try! realm.write {
            devsList.setValue(false, forKey: "isFavorited")
        }
    }
}
