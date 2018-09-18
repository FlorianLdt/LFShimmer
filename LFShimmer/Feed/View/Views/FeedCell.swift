//
//  FeedCell.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/19/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell: UITableViewCell {
    
    let avatar: LoadingImageView = {
        let avatar = LoadingImageView()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 36/2
        avatar.translatesAutoresizingMaskIntoConstraints = false
        return avatar
    }()
    
    let title: LoadingLabel = {
        let title = LoadingLabel(withTextStyle: Font.TextStyle.title!)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let subtitle: LoadingLabel = {
        let subtitle = LoadingLabel(withTextStyle: Font.TextStyle.subtitle!)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        return subtitle
    }()
    
    let postImage: LoadingImageView = {
        let postImage = LoadingImageView()
        postImage.layer.masksToBounds = true
        postImage.translatesAutoresizingMaskIntoConstraints = false
        return postImage
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.backgroundColor = .white
        contentView.addSubview(avatar)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        contentView.addSubview(postImage)
        contentView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 36),
            avatar.widthAnchor.constraint(equalToConstant: 36),
            
            title.topAnchor.constraint(equalTo: avatar.topAnchor),
            title.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -40),
            title.heightAnchor.constraint(equalToConstant: 20),
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            subtitle.leftAnchor.constraint(equalTo: title.leftAnchor),
            subtitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -70),
            subtitle.heightAnchor.constraint(equalToConstant: 12),
            
            postImage.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 10),
            postImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            postImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            postImage.heightAnchor.constraint(equalToConstant: 200),
            postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            separator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            separator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(_ animate: Bool) {
        avatar.animate(animate)
        title.animate(animate)
        subtitle.animate(animate)
        postImage.animate(animate)
    }
    
    func configure( with viewModel: FeedPostViewModel) {
        
        title.label.text = viewModel.title
        subtitle.label.text = viewModel.subtitle
        
        avatar.avatar.kf.setImage(with: URL(string: viewModel.avatar!))
        postImage.avatar.kf.setImage(with: URL(string: viewModel.content!))
        
        
    }
    
}
