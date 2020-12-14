//
//  SettingsLauncher.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/6/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class SettingsObject : NSObject{
    let settingsName : ButtonTitles
    let x : UIViewController
    let selection : String
    
    init(settingName: ButtonTitles, selection: String = "", x: UIViewController) {
        self.settingsName = settingName
        self.selection = selection
        self.x = x
    }
}

class Settings: NSObject{
    
    let settings: [SettingsObject] = {
        let animalType  = SettingsObject(settingName: .AnimalType, x: UIViewController())
        let breed = SettingsObject(settingName: .Breed, x: UIViewController())
        let color = SettingsObject(settingName: .Color, x: UIViewController())
        let coat = SettingsObject(settingName: .Coat, x: UIViewController())
        let size = SettingsObject(settingName: .Size, x: UIViewController())
        let gender = SettingsObject(settingName: .Gender, x: UIViewController())
        let age = SettingsObject(settingName: .Age, x: UIViewController())
        let range = SettingsObject(settingName: .Range, x: UIViewController())
        return [animalType, breed, color, coat, size, gender, age, range]
    }()
    
    let blackView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let animalSettingsView = UIView()
    
//    func setupLayout(){
//        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first{
//            window.addSubview(blackView)
//            blackView.frame = window.frame
//            blackView.alpha = 0
//            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
//
//            window.addSubview(animalSettingsView)
//            animalSettingsView.backgroundColor = .white
//            animalSettingsView.layer.cornerRadius = 30
//            animalSettingsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//            animalSettingsView.autoresizesSubviews = true
//            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
//            swipeGesture.direction = .down
//            animalSettingsView.addGestureRecognizer(swipeGesture)
//            let height = window.frame.height * 2/3
//            animalSettingsView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
//
//            window.bringSubviewToFront(animalSettingsView)
//        }
//    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    @objc func showSettings(){
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first{
            
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
//            window.addSubview(animalSettingsView)
//            animalSettingsView.backgroundColor = .white
//            animalSettingsView.layer.cornerRadius = 30
//            animalSettingsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//            animalSettingsView.autoresizesSubviews = true
//            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
//            swipeGesture.direction = .down
//            animalSettingsView.addGestureRecognizer(swipeGesture)
//            let height = window.frame.height * 2/3
//            animalSettingsView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
//            window.bringSubviewToFront(animalSettingsView)
            
            window.addSubview(collectionView)
            collectionView.layer.cornerRadius = 30
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismiss))
            swipeGesture.direction = .down
            collectionView.addGestureRecognizer(swipeGesture)
//            let height: CGFloat = CGFloat(settings.count * 70 + window.safeAreaInsets.bottom + 15 * settings.count)
            let height: CGFloat = CGFloat(settings.count) * 50 + window.safeAreaInsets.bottom + 15 * CGFloat(settings.count)
//            let height: CGFloat = window.frame.height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

            collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.3, options: .curveEaseIn) {
                self.blackView.alpha = 1
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: -height)
            } completion: { (_) in
                
            }
        }
    }
    
    @objc func handleDismiss(gesture: UIGestureRecognizer){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.collectionView.transform = .identity
        } completion: { (_) in
            self.blackView.removeFromSuperview()
            self.collectionView.removeFromSuperview()
        }
    }
    
//    override init() {
//        super.init()
////        setupAnimalSettings()
//    }
    
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    

}

extension Settings: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCollectionViewCell
        cell.preferenceName.text = settings[indexPath.row].settingsName.rawValue
        cell.selectionName.text = settings[indexPath.row].selection
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(settings[indexPath.row].settingsName.rawValue)
        
    }
    
    func showVC(){
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        
    }
    
}
