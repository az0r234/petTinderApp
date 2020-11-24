//
//  ProfileViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 8/31/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import LBTATools
import JGProgressHUD
import SafariServices
import CoreLocation

protocol ProfileViewControllerProtocol {
    func settingsDidGoUp()
    func settingsDidGoDown()
}

class ProfileViewController: UIViewController{
    let cardDeckView = UIView()
    let layout = UICollectionViewFlowLayout()
    lazy var animalPrefController = AnimalPreferenceController(collectionViewLayout: layout)
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var settingsCardMoveUp: NSLayoutConstraint!
    var settingsCardMoveDown: NSLayoutConstraint!
    
    var delegate: ProfileViewControllerProtocol?
    var isPoppedUp = false
    
    let hud = JGProgressHUD(style: .dark)
    var topCard: ProfileImageView?
    let locationManager = CLLocationManager()
    let defualtUrlPath = "/v2/animals?sort=distance&limit=20"
    var path = String()
    
    let animalPrefBtn: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cardExit), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    let animalSettingsView: UIView = {
        let settingsView = UIView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.layer.cornerRadius = 30
        settingsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        settingsView.autoresizesSubviews = true
        settingsView.alpha = 0
        return settingsView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        setupLayoutCardView()
        getLocation()
        animalPrefController.loadAnimalPreferenceData()
    }
    
    fileprivate func setupLayoutCardView() {
        view.backgroundColor = .white
        
        animalPrefController.delegate = self
        addAnimalSettingsBtn()
        addCardDeckView()
        addBlurViewAndGesture()
        addSettingsCardView()
        
    }
    
    fileprivate func addAnimalSettingsBtn() {
        view.addSubview(animalPrefBtn)
        animalPrefBtn.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 15))
    }
    
    fileprivate func addCardDeckView() {
        view.addSubview(cardDeckView)
        cardDeckView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 3, bottom: 74, right: 3))
    }
    
    fileprivate func addBlurViewAndGesture() {
        //Blur View
        view.addSubview(blurView)
        blurView.fillSuperview()
        blurView.alpha = 0
        
        // - Add Tap Gesture to BlurView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardExit))
        blurView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func addSettingsCardView() {
        view.addSubview(animalSettingsView)
        animalSettingsView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: view.frame.height * 2/3))
        
        settingsCardMoveDown = animalSettingsView.topAnchor.constraint(equalTo: view.bottomAnchor)
        settingsCardMoveDown?.isActive = true
        
        settingsCardMoveUp = animalSettingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        addSlideDownGesture()
        addSettingsVC()
    }
    
    fileprivate func addSlideDownGesture(){
        let slideDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(cardExit))
        slideDownGesture.direction = .down
        animalSettingsView.addGestureRecognizer(slideDownGesture)
    }
    
    fileprivate func addSettingsVC(){
        addChild(animalPrefController)
        layout.scrollDirection = .horizontal
        animalPrefController.view.translatesAutoresizingMaskIntoConstraints = false
        animalSettingsView.addSubview(animalPrefController.view)
        animalPrefController.view.fillSuperview()
        
    }
    
}

//MARK: - Grab User Location
extension ProfileViewController: CLLocationManagerDelegate{

    fileprivate func getLocation(localPath: String = ""){
        path = "\(defualtUrlPath)&\(localPath)"
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            path = "\(path)&location=\(lat),\(long)"
            getAnimalData(urlPath: path)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ProfileViewController: CardViewDelegate, AnimalPreferenceProtocol{
    
    // Shows the Website for that specific Animal
    func didPressMoreInfo(url: String) {
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    //get's the animalData
    func getAnimalData(urlPath: String) {
        let url = "\(K.apiString)\(urlPath)"
        topCard = nil
        
        hud.textLabel.text = K.hudLoadingLabel
        hud.show(in: self.view)
        
        cardDeckView.subviews.forEach({$0.removeFromSuperview()})
        
        FetchManager().fetchAnimalData(url: url) { (animalData, error) in
            DispatchQueue.main.async {
                guard let animals = animalData?.animals else { return }
                guard let pagination = animalData?.pagination else { return }
                var previousCardView : ProfileImageView?
        
                let paginationUrl = pagination.links?.next.href
                
                if !animals.isEmpty{
                    for animal in animals{
                        let cardView = self.setupCardsFromAnimals(animal: animal, paginationUrl: paginationUrl)
                        
                        previousCardView?.nextCard = cardView
                        previousCardView?.nextCard?.isHidden = true
                        previousCardView?.nextCard?.alpha = 0
                        previousCardView = cardView
                        
                        if self.topCard == nil{
                            self.topCard = cardView
                        }
                    }
                }else{
                    self.animalNotFound()
                }
            }
        }
    }
    
    //shows this card when animal not found
    fileprivate func animalNotFound(){
        let animalNotFound = ProfileImageView()
        animalNotFound.layer.cornerRadius = 20
        animalNotFound.isUserInteractionEnabled = false
        animalNotFound.profileImage.image = #imageLiteral(resourceName: "iPhone 11")
        animalNotFound.gradientLayer.removeFromSuperlayer()
        animalNotFound.moreInfoBtn.removeFromSuperview()
        cardDeckView.addSubview(animalNotFound)
        cardDeckView.bringSubviewToFront(animalNotFound)
        animalNotFound.fillSuperview()
        
        cardDeckView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.cardDeckView.alpha = 1
        }
        hud.dismiss()
    }
    
    //shows animals if card/animal was found
    fileprivate func setupCardsFromAnimals(animal: Animals, paginationUrl: String?) -> ProfileImageView{
        let cardView = ProfileImageView()
        cardView.cardViewModel = animal.toAnimalCardViewModel()
        cardView.paginationUrl = paginationUrl
        cardView.delegate = self
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        hud.dismiss()
        return cardView
    }
    
    @objc func handleLike(){
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    @objc func handleDislike(){
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    //does the swipe animation when it's swiped on
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat){
        
        let duration = 0.3
        let positionXKeyPath = "position.x"
        let roationAnimationKeyPath = "transform.rotation.z"
        let translationKeyPath = "translation"
        let rotationKeyPath = "rotation"
        
        let translationAnimation = CABasicAnimation(keyPath: positionXKeyPath)
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: roationAnimationKeyPath)
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        
        if topCard?.nextCard == nil{
            if let nextPage = topCard?.paginationUrl{
                getAnimalData(urlPath: nextPage)
            }else{
                animalNotFound()
            }
        }
        
        let cardView = topCard
        topCard = cardView?.nextCard
        

        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCard?.alpha = 1
            self.topCard?.transform = .identity
        })
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
            cardView?.subviews.forEach({ (v) in
                v.removeFromSuperview()
            })
        }
        
        cardView?.layer.add(translationAnimation, forKey: translationKeyPath)
        cardView?.layer.add(rotationAnimation, forKey: rotationKeyPath)
        CATransaction.commit()
    }
    
//    /v2/animals?
    
    //Sends the data to getAnimalData function
    func sendData(path: String) {
//        let fullPath = "\(defualtUrlPath)\(path)"
        getLocation(localPath: path)
        
        
//        print(locationManager.location!.coordinate.latitude)
//        getAnimalData(urlPath: fullPath)
        
    }
    
//    func getLocation(){
//        if let location = locationManager.location{
//            let lat = location.coordinate.latitude
//            let long = location.coordinate.longitude
//        }
//    }
    
}

//MARK: - Handle Preference Buttons
extension ProfileViewController{
    
    @objc func cardExit(){
        switch isPoppedUp {
        case false:
            goUp()
        case true:
            goDown()
        }
        isPoppedUp.toggle()
    }
    
    fileprivate func goUp() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.3, options: .curveEaseInOut) {
            self.settingsCardMoveUp?.isActive = true
            self.settingsCardMoveDown?.isActive = false
            self.view.layoutIfNeeded()
            self.blurView.alpha = 1.0
            self.animalSettingsView.alpha = 1.0
        } completion: { (_) in
            self.delegate?.settingsDidGoUp()
        }
    }
    
    fileprivate func goDown() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.settingsCardMoveUp?.isActive = false
            self.settingsCardMoveDown?.isActive = true
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0
            self.animalSettingsView.alpha = 0
        } completion: { (_) in
            self.delegate?.settingsDidGoDown()
        }
    }
}

//MARK: - Error Handling Section
extension ProfileViewController {
    func failedWithError(error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
