//
//  TopSlidingBar.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/4/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class TopBarButtons: UIButton{
    var image = UIImage()
    
    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        setupButton()
    }
    
    fileprivate func setupButton(){
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        setImage(image.withRenderingMode(.alwaysTemplate), for: .disabled)
        contentMode = .scaleAspectFit
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TopSlidingBar: UIView {
    
    var settingsButton = TopBarButtons(image: #imageLiteral(resourceName: "info"))
    var profileButton = TopBarButtons(image: #imageLiteral(resourceName: "paw"))
    var pickedAnimalsButton = TopBarButtons(image: #imageLiteral(resourceName: "map"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [settingsButton, UIView(), profileButton, UIView(), pickedAnimalsButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 80))
        
        backgroundColor = .white
    }
    
    func changeTintForButtons(){
        if settingsButton.isEnabled {
            settingsButton.tintColor = .red
            
            profileButton.isEnabled = false
            profileButton.tintColor = .gray
            pickedAnimalsButton.isEnabled = false
            pickedAnimalsButton.tintColor = .gray
        }else if profileButton.isEnabled {
            profileButton.tintColor = .red
            
            settingsButton.isEnabled = false
            settingsButton.tintColor = .gray
            pickedAnimalsButton.isEnabled = false
            pickedAnimalsButton.tintColor = .gray
        }else if pickedAnimalsButton.isEnabled{
            pickedAnimalsButton.tintColor = .red
            
            settingsButton.isEnabled = false
            settingsButton.tintColor = .gray
            profileButton.isEnabled = false
            profileButton.tintColor = .gray
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
