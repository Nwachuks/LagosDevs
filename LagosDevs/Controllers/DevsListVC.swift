//
//  DevsListVC.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 26/09/2022.
//

import UIKit
import RealmSwift

class DevsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var devsList = [GithubUser]()
    
    private lazy var devsTable: UITableView = {
        let table = UITableView()
        table.register(DevsListCell.self, forCellReuseIdentifier: DevsListCell.identifier)
        return table
    }()
    
    var notificationToken: NotificationToken? = nil
    deinit {
        notificationToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Lagos Devs"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .black
        
        let nextItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clearFavorites))
        self.navigationItem.rightBarButtonItem = nextItem
        self.navigationItem.rightBarButtonItem?.tintColor = .systemRed
        
        // Do any additional setup after loading the view.
        devsTable.delegate = self
        devsTable.dataSource = self
        view.addSubview(devsTable)
        
        let results = DBManager.shared.getDevListing()
        devsList = Array(results)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.devsTable.reloadData()
                break
            case .update(_, _, _, _):
                let results = DBManager.shared.getDevListing()
                self.devsList = Array(results)
                self.devsTable.reloadData()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
        
        if devsList.isEmpty {
            getListOfDevs()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        devsTable.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    func getListOfDevs() {
        NetworkManager.shared.getListOfLagosDevs { results in
            switch results {
            case .success:
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    @objc func clearFavorites() {
        let alert = UIAlertController(title: "Clear Favorites?", message: "This will clear all github profiles that you have added to your favorites. Proceed?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) { action in
            DBManager.shared.clearAllFavorites()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    // MARK: TableViewDelegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DevsListCell.identifier, for: indexPath) as? DevsListCell else { return UITableViewCell() }
        cell.configure(using: devsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dev = devsList[indexPath.row]
        let vc = DevDetailsVC()
        vc.dev = dev
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
