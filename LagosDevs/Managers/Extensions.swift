//
//  Extensions.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 26/09/2022.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}

extension UIImageView {
    func download(from urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            task.resume()
        }
    }
}
