//
//  DevDetailsVC.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 27/09/2022.
//

import UIKit
import RealmSwift
import SafariServices

class DevDetailsVC: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var devImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bioView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bioTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Bio"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewGitHubBtn: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "View on Github"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        button.configuration = config
        button.addTarget(self, action: #selector(showGithubProfile), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var favBtn: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
//        config.title = "Add to Favorites"
        config.baseBackgroundColor = .systemRed
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "heart.fill")
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage
          = UIImage.SymbolConfiguration(scale: .medium)
        button.configuration = config
        button.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            config?.title = self.isFavorited ? "Remove from Favorites" : "Add to Favorites"
//            button.widthAnchor.constraint(equalToConstant: 200)
            let symbolName = self.isFavorited ? "heart.fill" : "heart"
            config?.image = UIImage(systemName: symbolName)
            button.configuration = config
        }
        button.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var dev: GithubUser?
    var isFavorited = false {
        didSet {
            favBtn.setNeedsUpdateConfiguration()
        }
    }
    
    var notificationToken: NotificationToken? = nil
    deinit {
        notificationToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(devImage)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(bioView)
        bioView.addSubview(bioTitleLabel)
        bioView.addSubview(bioLabel)
        stackView.addArrangedSubview(viewGitHubBtn)
        stackView.addArrangedSubview(favBtn)
        // Do any additional setup after loading the view.
        setupConstraints()
        setupView()
        
        if let dev = dev {
            notificationToken = dev.observe { [weak self] change in
                guard let self = self else { return }
                switch change {
                case .change(_, _):
                    self.setupView()
                    break
                case .deleted:
                    break
                case .error(let error):
                    print("An error occurred: \(error)")
                    break
                }
            }
            
            NetworkManager.shared.getDevDetails(urlString: dev.url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.safeAreaLayoutGuide.layoutFrame
    }
    
    private func setupView() {
        if let dev = dev {
            devImage.image = UIImage(named: "default-img")
            if let name = dev.name {
                nameLabel.isHidden = false
                nameLabel.text = name
            } else {
                nameLabel.isHidden = true
            }
            usernameLabel.text = dev.username
            
            if dev.bio.isEmpty {
                bioView.isHidden = true
            } else {
                bioView.isHidden = false
                bioLabel.text = dev.bio
            }
            isFavorited = dev.isFavorited
        }
    }

    private func setupConstraints() {
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ]
        
        let devImageConstraints = [
            devImage.heightAnchor.constraint(equalToConstant: 100),
            devImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ]
        
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            usernameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ]
        
        let bioViewConstraints = [
            bioView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bioView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ]
        
        let bioTitleConstraints = [
            bioTitleLabel.topAnchor.constraint(equalTo: bioView.topAnchor),
            bioTitleLabel.leadingAnchor.constraint(equalTo: bioView.leadingAnchor),
            bioTitleLabel.trailingAnchor.constraint(equalTo: bioView.trailingAnchor)
        ]
        
        let bioLabelConstraints = [
            bioLabel.topAnchor.constraint(equalTo: bioTitleLabel.bottomAnchor, constant: 5),
            bioLabel.leadingAnchor.constraint(equalTo: bioView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: bioView.trailingAnchor),
            bioLabel.bottomAnchor.constraint(equalTo: bioView.bottomAnchor)
        ]
        
        let githubBtnConstraints = [
            viewGitHubBtn.heightAnchor.constraint(equalToConstant: 50),
            viewGitHubBtn.widthAnchor.constraint(equalToConstant: 170)
        ]
        
        let favoriteBtnConstraints = [
            favBtn.heightAnchor.constraint(equalToConstant: 50),
//            favBtn.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
        NSLayoutConstraint.activate(devImageConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(bioViewConstraints)
        NSLayoutConstraint.activate(bioTitleConstraints)
        NSLayoutConstraint.activate(bioLabelConstraints)
        NSLayoutConstraint.activate(githubBtnConstraints)
        NSLayoutConstraint.activate(favoriteBtnConstraints)
    }
    
    @objc func showGithubProfile() {
        guard let urlString = dev?.htmlUrl, let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func addToFavorites() {
        guard let dev = dev else { return }
        isFavorited.toggle()
        DBManager.shared.addDevToFavorites(id: dev.id)
    }
    
}
