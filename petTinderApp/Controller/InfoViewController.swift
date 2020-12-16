//
//  SettingsViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 8/31/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import SafariServices
import CoreData
import JGProgressHUD

class InfoViewController: UIViewController{
    
    let userProfileView = InfoView()
    let curveView = AnimalFactsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupInfoView()
        setupAnimalFactView()
    }
    
    private func setupInfoView(){
        view.addSubview(userProfileView)
        userProfileView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 15), size: .init(width: view.frame.width, height: 280))
        
        userProfileView.petFinderBtn.infoButton.addTarget(self, action: #selector(handlePetFinderPresed), for: .touchUpInside)
        userProfileView.resetSelectionBtn.infoButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        userProfileView.moreInfoBtn.infoButton.addTarget(self, action: #selector(handleMoreInfoPressed), for: .touchUpInside)
        userProfileView.githubImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGoToGitHub)))
    }
    
    @objc func handleGoToGitHub(gesture: UITapGestureRecognizer){
        let url = "https://www.github.com/az0r234"
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc func handlePetFinderPresed(){
        let url = "https://www.petfinder.com"
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc func handleReset(){
        let loadingHud = JGProgressHUD(style: .dark)
        loadingHud.textLabel.text = "Deletion In Progress"
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var pickedAnimals : [PickedAnimals]?
        do {
            loadingHud.show(in: view)
            pickedAnimals = try context.fetch(PickedAnimals.fetchRequest())
            pickedAnimals?.forEach({ (animal) in
                context.delete(animal)
            })
            try context.save()
            loadingHud.dismiss(afterDelay: 2, animated: true)
        }catch let resetError{
            print(resetError.localizedDescription)
        }
        
    }
    
    @objc func handleMoreInfoPressed(){
        let appInfo = AppInfoViewController()
        appInfo.modalPresentationStyle = .fullScreen
        present(appInfo, animated: true, completion: nil)
    }
    
    private func setupAnimalFactView(){
        view.addSubview(curveView)
        curveView.backgroundColor = .clear
        curveView.anchor(top: view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
}
