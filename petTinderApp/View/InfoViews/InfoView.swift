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
        setImage(iconImage.withRenderingMode(.alwaysOriginal), for: .normal)
        layer.cornerRadius = btnHeight / 2
        backgroundColor = .white
        imageView?.fillSuperview(padding: .init(top: btnImagePadding, left: btnImagePadding, bottom: btnImagePadding, right: btnImagePadding))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum InfoViewButtonTitles: String{
    case petFinder = "Petfinder"
    case reset = "Reset"
    case moreInfo = "More Info"
}


class InfoStackView: UIStackView {
    let iconImage : UIImage
    let infoLabel : InfoViewButtonTitles
    let backGroundColor : UIColor
    
    lazy var infoButton = InfoButtons(iconImage: iconImage)
    var buttonLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    init(iconImage: UIImage, infoLabel: InfoViewButtonTitles, backGroundColor: UIColor) {
        self.iconImage = iconImage
        self.infoLabel = infoLabel
        self.backGroundColor = backGroundColor
        super.init(frame: .zero)
        setupStackView()
    }
    
    func setupStackView(){
        buttonLabel.text = infoLabel.rawValue
        infoButton.backgroundColor = backGroundColor
        axis = .vertical
        [infoButton, buttonLabel].forEach { (v) in
            addArrangedSubview(v)
        }
        alignment = .center
        distribution = .equalCentering
        spacing = 15
        
    }
    
    required init(coder: NSCoder) {
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
    
//    rgb(0, 216, 214)
//    rgb(5, 196, 107)
    
    let petFinderBtn = InfoStackView(iconImage: #imageLiteral(resourceName: "petfinderLogo"), infoLabel: .petFinder, backGroundColor: .rgb(red: 102, green: 2, blue: 184))
    let resetSelectionBtn = InfoStackView(iconImage: #imageLiteral(resourceName: "icons8-reset-100"), infoLabel: .reset, backGroundColor: .rgb(red: 0, green: 216, blue: 214))
    let moreInfoBtn = InfoStackView(iconImage: #imageLiteral(resourceName: "info"), infoLabel: .moreInfo, backGroundColor: .rgb(red: 5, green: 196, blue: 107))
    
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
        petFinderBtn.infoButton.backgroundColor = UIColor.rgb(red: 102, green: 2, blue: 184)
        let buttonStackView = UIStackView(arrangedSubviews: [petFinderBtn, resetSelectionBtn, moreInfoBtn])
        buttonStackView.distribution = .equalCentering
        addSubview(buttonStackView)
        buttonStackView.anchor(top: githubImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 20, left: 15, bottom: 0, right: 15))
    }
    
    override func layoutSubviews() {
        [githubImageView, moreInfoBtn.infoButton, petFinderBtn.infoButton, resetSelectionBtn.infoButton].forEach { (view) in
            view.setupShadow(opacity: 0.5, radius: 8, offset: .init(width: 4, height: 5), color: .black)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
