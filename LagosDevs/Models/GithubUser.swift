//
//  GithubUser.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 26/09/2022.
//

import Foundation
import RealmSwift

class GithubUser: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var username = ""
    @Persisted var url = ""
    @Persisted var htmlUrl = ""
    @Persisted var avatarUrl = ""
    @Persisted var name: String?
    @Persisted var bio = ""
    @Persisted var publicRepos = 0
    @Persisted var followers = 0
    @Persisted var following = 0
    @Persisted var isFavorited = false
    
    convenience init(id: Int, username: String, url: String, htmlUrl: String, avatar: String) {
        self.init()
        self.id = id
        self.username = username
        self.url = url
        self.htmlUrl = htmlUrl
        self.avatarUrl = avatar
    }
}
