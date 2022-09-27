//
//  DevsListCell.swift
//  LagosDevs
//
//  Created by Nwachukwu Ejiofor on 26/09/2022.
//

import UIKit

class DevsListCell: UITableViewCell {

    static let identifier = String(describing: DevsListCell.self)
    
    private lazy var devImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(devImage)
        contentView.addSubview(usernameLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupConstraints() {
        let devImageConstraints = [
            devImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            devImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            devImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            devImage.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let usernameLabelConstraints = [
            usernameLabel.leadingAnchor.constraint(equalTo: devImage.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(devImageConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
    }
    
    func configure(using user: GithubUser) {
        devImage.image = UIImage(named: "default-img")
        usernameLabel.text = "@\(user.username)"
    }
}
