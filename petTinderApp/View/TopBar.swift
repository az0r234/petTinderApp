//
//  TopSlidingBar.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/4/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class TopBarCollectionViewCell: BaseCell{
    
    let menuImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    override var isHighlighted: Bool{
        didSet{
            menuImageView.tintColor = isHighlighted ? UIColor.rgb(red: 248, green: 212, blue: 157) : .darkGray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            menuImageView.tintColor = isSelected ? UIColor.rgb(red: 248, green: 212, blue: 157) : .darkGray
        }
    }
    
    override func setupView() {
        addSubview(menuImageView)
        menuImageView.centerInSuperview()
    }
}


private let reuseCellId = "reuseCellId"
class TopBar: UIView {
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let iconImages = [#imageLiteral(resourceName: "info"), #imageLiteral(resourceName: "paw"), #imageLiteral(resourceName: "map")]
    var rootController : RootViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(red: 90, green: 164, blue: 105)
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView(){
        collectionView.register(TopBarCollectionViewCell.self, forCellWithReuseIdentifier: reuseCellId)
        
        
        addSubview(collectionView)
        collectionView.anchor(top: centerYAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 50))
        
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TopBar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rootController?.scrollToMenuItem(menuItem: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellId, for: indexPath) as! TopBarCollectionViewCell
        cell.menuImageView.image = iconImages[indexPath.row].withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}




//class TopSlidingBar: UIView {
//
//    var settingsButton = TopBarButtons(image: #imageLiteral(resourceName: "info"))
//    var profileButton = TopBarButtons(image: #imageLiteral(resourceName: "paw"))
//    var pickedAnimalsButton = TopBarButtons(image: #imageLiteral(resourceName: "map"))
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        let stackView = UIStackView(arrangedSubviews: [settingsButton, UIView(), profileButton, UIView(), pickedAnimalsButton])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
//
//        addSubview(stackView)
//        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 80))
//
//        backgroundColor = .white
//    }
//
//    func changeTintForButtons(){
//        if settingsButton.isEnabled {
//            settingsButton.tintColor = .red
//
//            profileButton.isEnabled = false
//            profileButton.tintColor = .gray
//            pickedAnimalsButton.isEnabled = false
//            pickedAnimalsButton.tintColor = .gray
//        }else if profileButton.isEnabled {
//            profileButton.tintColor = .red
//
//            settingsButton.isEnabled = false
//            settingsButton.tintColor = .gray
//            pickedAnimalsButton.isEnabled = false
//            pickedAnimalsButton.tintColor = .gray
//        }else if pickedAnimalsButton.isEnabled{
//            pickedAnimalsButton.tintColor = .red
//
//            settingsButton.isEnabled = false
//            settingsButton.tintColor = .gray
//            profileButton.isEnabled = false
//            profileButton.tintColor = .gray
//        }
//    }
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
