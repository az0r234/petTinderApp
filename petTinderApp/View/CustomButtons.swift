//
//  CustomButtons.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/25/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    let centerLabel : String
    let label = UILabel()
    
    init(centerLabel: String) {
        self.centerLabel = centerLabel
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        layer.cornerRadius = 20
        
        setupButton()
    }
    
    fileprivate func setupButton(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = centerLabel
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        addSubview(label)
        label.centerInSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
