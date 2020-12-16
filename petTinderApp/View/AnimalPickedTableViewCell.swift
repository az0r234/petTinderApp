//
//  AnimalPickedTableViewCell.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/29/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class AnimalPickedTableViewCell: UITableViewCell {
    
    let pickedAnimalView = UIView()
    let profileImageView = UIImageView()
    let nameLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.textColor = .black
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupCell()
    }
    
    fileprivate func setupView(){
        addSubview(pickedAnimalView)
        pickedAnimalView.fillSuperview(padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
    }
    
    
    fileprivate func setupCell(){
        let profileImageWidth: CGFloat = 100
        backgroundColor = .white
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = profileImageWidth / 2
        pickedAnimalView.addSubview(profileImageView)
        profileImageView.anchor(top: pickedAnimalView.topAnchor, leading: pickedAnimalView.leadingAnchor, bottom: pickedAnimalView.bottomAnchor, trailing: nil, padding: .init(top: 10, left: 10, bottom: 10, right: 0), size: .init(width: profileImageWidth, height: profileImageWidth))
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: pickedAnimalView.bottomAnchor, trailing: pickedAnimalView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        pickedAnimalView.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
        pickedAnimalView.layer.cornerRadius = 20
        pickedAnimalView.setupShadow(opacity: 0.5, radius: 8, offset: .init(width: 4, height: 5), color: .black)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
