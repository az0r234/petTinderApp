//
//  SettingsViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 8/31/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import SafariServices

enum SettingsVal: String {
    case AnimalType
}

class SettingsViewController: UIViewController{
    
    let userProfileView = UserProfileView()
    let curveView = AnimalFactsView()
    let settingsDictionary : [String : String] = [SettingsVal.AnimalType.rawValue : "YEET"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        UserDefaults.standard.setValuesForKeys(settingsDictionary)
        
        setupUserProfileView()
        setupAnimalFactView()
    }
    
    private func setupUserProfileView(){
        view.addSubview(userProfileView)
        userProfileView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 15, bottom: 0, right: 15), size: .init(width: view.frame.width, height: 280))
        
        userProfileView.animalPreferenceBtn.addTarget(self, action: #selector(handlePreferencePressed), for: .touchUpInside)
        userProfileView.infoBtn.addTarget(self, action: #selector(handleInfoPressed), for: .touchUpInside)
        userProfileView.userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGoToGitHub)))
    }
    
    @objc func handleGoToGitHub(gesture: UITapGestureRecognizer){
        let url = "https://www.github.com/az0r234"
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc func handlePreferencePressed(){
        let url = "https://www.petfinder.com"
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc func handleInfoPressed(){
        let appInfo = AppInfoViewController()
        appInfo.modalPresentationStyle = .fullScreen
        present(appInfo, animated: true, completion: nil)
    }
    
    private func setupAnimalFactView(){
        view.addSubview(curveView)
        curveView.anchor(top: view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
}
