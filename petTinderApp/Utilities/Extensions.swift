//
//  Extensions.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/6/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


