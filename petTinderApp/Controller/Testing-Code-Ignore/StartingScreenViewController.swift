//
//  RegistrationViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/25/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import AVFoundation

class StartingScreenViewController: UIViewController {
    
    let playerView = UIView()
    let registerLoginView = UIView()
    let getSwipingBtn = CustomButton(centerLabel: .Swiping, background: .red)
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
        view.addSubview(registerLoginView)
        registerLoginView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: view.frame.height * 1/4))
        
        addRegisterButtons()
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.backgroundColor = .white
        view.addSubview(playerView)
        playerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        view.bringSubviewToFront(registerLoginView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isNotOnStartScreen = UserDefaults.standard.bool(forKey: "PressedSwipe")
        if isNotOnStartScreen{
            let rootVC = RootTabViewController()
            rootVC.modalPresentationStyle = .fullScreen
            present(rootVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
    }
    
    fileprivate func addRegisterButtons(){
        getSwipingBtn.addTarget(self, action: #selector(goToSwipePage), for: .touchUpInside)
        registerLoginView.addSubview(getSwipingBtn)
        getSwipingBtn.centerInSuperview()
        getSwipingBtn.anchor(top: nil, leading: registerLoginView.leadingAnchor, bottom: nil, trailing: registerLoginView.trailingAnchor, padding: .init(top: 0, left: 15, bottom: 0, right: 15))
    }
    
    @objc fileprivate func goToSwipePage(){
        UserDefaults.standard.setValue(true, forKey: "PressedSwipe")
        let rootVC = RootTabViewController()
        rootVC.modalPresentationStyle = .fullScreen
        present(rootVC, animated: true, completion: nil)
    }
    
    let playerGradientLayer = CAGradientLayer()
    let buttonGradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientForPlayer(){
        playerGradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        playerGradientLayer.locations = [0, 0.25]
        playerView.layer.addSublayer(playerGradientLayer)
    }
    
    fileprivate func setupGradientForButton(){
        buttonGradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        buttonGradientLayer.locations = [0, 1.1]
        registerLoginView.layer.insertSublayer(buttonGradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.bounds
        playerGradientLayer.frame = playerView.bounds
        buttonGradientLayer.frame = registerLoginView.bounds
        setupGradientForPlayer()
        setupGradientForButton()
    }
    
    fileprivate func addObserverForVideo(){
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: nil) { (_) in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
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
