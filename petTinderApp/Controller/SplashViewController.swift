//
//  SplashViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/1/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    let animationView = AnimationView()
    let logoLabel = UILabel()
    let isNotOnStartScreen = UserDefaults.standard.bool(forKey: "PressedSwipe")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    fileprivate func setupAnimation(){
        view.addSubview(animationView)
        animationView.animation = Animation.named("dog")
        animationView.backgroundColor = .white
        animationView.play { (_) in
            UserDefaults.standard.setValue(true, forKey: "PressedSwipe")
            self.presentRootVC()
        }
        animationView.centerInSuperview(size: .init(width: 200, height: 200))
        
        logoLabel.text = "Pettastic!"
        logoLabel.textAlignment = .center
        logoLabel.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        view.addSubview(logoLabel)
        logoLabel.anchor(top: animationView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNotOnStartScreen{
            presentRootVC()
        }else{
            setupAnimation()
        }
    }

    fileprivate func presentRootVC(){
        let rootVC = RootTabViewController()
        rootVC.modalPresentationStyle = .fullScreen
        rootVC.modalTransitionStyle = .crossDissolve
        present(rootVC, animated: true, completion: nil)
    }

}
