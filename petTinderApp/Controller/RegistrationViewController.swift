//
//  RegistrationViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/25/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import AVFoundation

class RegistrationViewController: UIViewController {
    
    let playerView = UIView()
    let registerLoginView = UIView()
    let registerBtn = CustomButton(centerLabel: "Register")
    let loginBtn = CustomButton(centerLabel: "Login")
    var player : AVPlayer!
    var playerLayer : AVPlayerLayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        playVideo()
        addObserverForVideo()
    }
    

    
    fileprivate func setupLayout(){
        
        registerLoginView.translatesAutoresizingMaskIntoConstraints = false
        registerLoginView.backgroundColor = UIColor.rgb(red: 179, green: 107, blue: 57)
        registerLoginView.layer.cornerRadius = 25
        registerLoginView.clipsToBounds = true
        view.addSubview(registerLoginView)
        registerLoginView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height * 1/3))
        
        addLoginAndRegisterBtn()
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.backgroundColor = .white
        view.addSubview(playerView)
        playerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height * 8/9))
        
        view.bringSubviewToFront(registerLoginView)
    }
    
    fileprivate func addLoginAndRegisterBtn(){
        let buttonStackView = UIStackView(arrangedSubviews: [registerBtn, loginBtn])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .center
        buttonStackView.spacing = 10
        
        registerBtn.backgroundColor = .red
        loginBtn.backgroundColor = .red
        
        registerBtn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        registerLoginView.addSubview(buttonStackView)
        buttonStackView.centerInSuperview()
        buttonStackView.anchor(top: nil, leading: registerLoginView.leadingAnchor, bottom: nil, trailing: registerLoginView.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    @objc fileprivate func handleRegister(){
        let rootVC = RootTabViewController()
        navigationController?.pushViewController(rootVC, animated: true)
    }
    
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradient(){
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.25]
        playerView.layer.insertSublayer(gradientLayer, above: playerLayer)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.bounds
        gradientLayer.frame = playerView.bounds
        setupGradient()
    }
    
    fileprivate func addObserverForVideo(){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    fileprivate func playVideo(){
        guard let path = Bundle.main.path(forResource: "intro", ofType: "mp4") else { return }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        
        playerView.layer.addSublayer(playerLayer)
        playerView.clipsToBounds = true
        
        player.play()
    }

}
