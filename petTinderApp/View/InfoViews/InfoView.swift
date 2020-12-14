//
//  UserProfileView.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/8/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class InfoButtons: UIButton {
    
    let iconImage : UIImage
    
    init(iconImage: UIImage) {
        self.iconImage = iconImage
        super.init(frame: .zero)
        setupButton()
    }
    
    private func setupButton(){
        let btnHeight : CGFloat = 80
        let btnImagePadding: CGFloat = 20
        translatesAutoresizingMaskIntoConstraints = false
        withSize(.init(width: btnHeight, height: btnHeight))
        setImage(iconImage.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = .darkGray
        layer.cornerRadius = btnHeight / 2
        backgroundColor = .white
        imageView?.fillSuperview(padding: .init(top: btnImagePadding, left: btnImagePadding, bottom: btnImagePadding, right: btnImagePadding))
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InfoView: UIView {
    
    let githubImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "github-logo").withRenderingMode(.alwaysOriginal)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let petFinderPageButton = InfoButtons(iconImage: #imageLiteral(resourceName: "paw"))
    let infoButton = InfoButtons(iconImage: #imageLiteral(resourceName: "info"))
    let buttonSpacing: CGFloat = 150

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 35
        backgroundColor = .clear
        
        setupUserImageView()
        setupButtons()
    }
    
    fileprivate func setupUserImageView(){
        addSubview(githubImageView)
        githubImageView.centerXTo(centerXAnchor)
        githubImageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: buttonSpacing, height: buttonSpacing))
        githubImageView.layer.cornerRadius = buttonSpacing / 2
        githubImageView.backgroundColor = .white
    }
    
    fileprivate func setupButtons(){
        let buttonStackView = UIStackView(arrangedSubviews: [petFinderPageButton, infoButton])
        buttonStackView.distribution = .equalCentering
        buttonStackView.spacing = buttonSpacing
        addSubview(buttonStackView)
        buttonStackView.anchor(top: githubImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 15, bottom: 0, right: 15))
    }
    
    override func layoutSubviews() {
        [githubImageView, infoButton, petFinderPageButton].forEach { (view) in
            view.setupShadow(opacity: 0.5, radius: 8, offset: .init(width: 4, height: 5), color: .black)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
