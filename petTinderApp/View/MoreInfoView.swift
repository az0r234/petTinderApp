//
//  MoreInfoView.swift
//  petTinderApp
//
//  Created by Alok Acharya on 9/18/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class MoreInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 360).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
