//
//  DevsListVC.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 26/09/2022.
//

import UIKit

class DevsListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkManager.shared.getListOfLagosDevs { results in
            switch results {
            case .success:
                print(DBManager.shared.getDevListing())
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}

