//
//  SettingsCollectionViewCell.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/7/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class SettingsCollectionViewCell: BaseCell {
    
    let preferenceName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.text = "Preference Type"
        return lbl
    }()
    
    var selectionName: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()

    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrowtriangle.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .red
        return imageView
    }()
    
    
    override func setupView() {
        super.setupView()
        
        addSubview(preferenceName)
        addSubview(arrowImageView)
        addSubview(selectionName)
        
        preferenceName.centerYTo(centerYAnchor)
        preferenceName.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0))
        
        arrowImageView.centerYTo(centerYAnchor)
        arrowImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 15))
        
        selectionName.centerYTo(centerYAnchor)
        selectionName.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: arrowImageView.leadingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 10))
    }
    
    override func layoutSubviews() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override var isHighlighted: Bool {
        didSet{
            backgroundColor = isHighlighted ? .gray : .white
            preferenceName.textColor = isHighlighted ? .white : .black
            selectionName.textColor = isHighlighted ? .white : .black
            arrowImageView.image = isHighlighted ? UIImage(systemName: "arrowtriangle.right.fill")?.withRenderingMode(.alwaysTemplate) : UIImage(systemName: "arrowtriangle.right")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
}
