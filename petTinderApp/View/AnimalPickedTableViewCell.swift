//
//  AnimalPickedTableViewCell.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/29/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class AnimalPickedTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    
    let nameLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    fileprivate func setupCell(){
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 10, bottom: 10, right: 0))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}