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
import CoreData

protocol ProfileViewControllerProtocol {
    func settingsDidGoUp()
    func settingsDidGoDown()
}

class ProfileViewController: UIViewController{
    let cardDeckView = UIView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let animalSettingsView = UIView()
    let animalPrefBtn = UIButton()
    
    let layout = UICollectionViewFlowLayout()
    var animalPrefController : AnimalPreferenceController!
    
    var settingsCardMoveUp: NSLayoutConstraint!
    var settingsCardMoveDown: NSLayoutConstraint!
    
    var delegate: ProfileViewControllerProtocol?
    var settingsCardIsPoppedUp = false
    var isLocationEnabled = false
    var foundDuplicate = false
    
    let loadingHud = JGProgressHUD(style: .dark)
    var topCard: CardView?
    let locationManager = CLLocationManager()
    var urlPath = String()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pickedAnimals : [PickedAnimals]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalPrefController = AnimalPreferenceController(collectionViewLayout: layout)
        setupLayoutCardView()
        fetchPickedAnimalData()
        getLocationIfAvailable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPickedAnimalData()
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
        animalPrefBtn.backgroundColor = .red
        animalPrefBtn.translatesAutoresizingMaskIntoConstraints = false
        animalPrefBtn.addTarget(self, action: #selector(cardExit), for: .touchUpInside)
        animalPrefBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        animalPrefBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        animalPrefBtn.layer.cornerRadius = 15
        
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
        animalSettingsView.translatesAutoresizingMaskIntoConstraints = false
        animalSettingsView.layer.cornerRadius = 30
        animalSettingsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        animalSettingsView.autoresizesSubviews = true
    
        
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
        animalPrefController.didMove(toParent: self)
        animalPrefController.view.fillSuperview()
        
        animalPrefController.viewDidLoad()
    }
    
}

//MARK: - Grab User Location
extension ProfileViewController: CLLocationManagerDelegate{

    fileprivate func getLocationIfAvailable(localPath: String = ""){
        let didAskUserForLocationPermission = UserDefaults.standard.bool(forKey: "didAskUserForLocationPermission")
        urlPath = "\(K.defaultUrlPath)\(localPath)"
        locationManager.delegate = self
        if didAskUserForLocationPermission{
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func getLocationIfUnavailable(localPath: String = ""){
        urlPath = "\(K.defaultUrlPath)&location"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        UserDefaults.standard.setValue(true, forKey: "didAskUserForLocationPermission")
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            isLocationEnabled = true
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            isLocationEnabled = true
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
//            isLocationEnabled = false
//            let hasBeenAskedToChangeLocation = UserDefaults.standard.bool(forKey: "hasBeenAskedForLocation")
//            print(hasBeenAskedToChangeLocation)
//            if hasBeenAskedToChangeLocation{
//                print("yeet")
//            }else{
            alertViewMaker(alertTitle: K.enableLocationErrorTitle, alertMessage: K.enableLocationError, actionTitle: K.okString)
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            urlPath = "\(urlPath)&location=\(lat),\(long)"
            loadingHud.textLabel.text = "Loading Animals"
            getAnimalData(urlPath: urlPath)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        failedWithError(error: error)
        print(error.localizedDescription)
    }
}

extension ProfileViewController: CardViewDelegate, AnimalPreferenceProtocol{
    
    // Shows the Website for that specific Animal
    func didPressMoreInfo(url: String) {
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            safariVC.modalPresentationStyle = .popover
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    //get's the animalData
    func getAnimalData(urlPath: String) {
        let url = "\(K.apiString)\(urlPath)"

        topCard = nil
        loadingHud.show(in: self.view)
        
        cardDeckView.subviews.forEach({$0.removeFromSuperview()})
        
        FetchManager().fetchAnimalData(url: url) { (animalData, error) in
            DispatchQueue.main.async {
                if error != nil{
                    self.failedWithError(error: error!)
                    return
                }
                
                guard let animals = animalData?.animals else { return }
                guard let pagination = animalData?.pagination else { return }
                guard let pickedAnimalsVal = self.pickedAnimals else { return }
                
                var previousCardView : CardView?
                let paginationUrl = pagination.links?.next.href
                var idArray = [Int]()
                
                
                if pickedAnimalsVal.isEmpty {
                    for pickedAnimal in pickedAnimalsVal{
                        idArray.append(Int(pickedAnimal.animalId))
                    }
                }
                
                if !animals.isEmpty{
                    for animal in animals{
                        if !idArray.contains(animal.id!){
                            self.foundDuplicate = false
                            let cardView = self.setupCardsFromAnimals(animal: animal, paginationUrl: paginationUrl)
                            
                            previousCardView?.nextCard = cardView
                            previousCardView?.nextCard?.isHidden = true
                            previousCardView?.nextCard?.alpha = 0
                            previousCardView = cardView
                            
                            if self.topCard == nil{
                                self.topCard = cardView
                            }
                        }else{
                            self.foundDuplicate = true
                            self.loadingHud.dismiss()
                            continue;
                        }
                    }
                }else{
                    self.loadingHud.dismiss()
//                    self.getAnimalData(urlPath: paginationUrl!)
                    print(url)
                }
                
                if self.foundDuplicate{
                    self.getAnimalData(urlPath: paginationUrl!)
                }
            }
        }
    }
    
    //shows this card when animal not found
    fileprivate func animalNotFound(){
        let animalNotFound = CardView()
        animalNotFound.layer.cornerRadius = 20
        animalNotFound.isUserInteractionEnabled = false
        animalNotFound.profileImage.image = #imageLiteral(resourceName: "ResultNotFound")
        animalNotFound.gradientLayer.removeFromSuperlayer()
        animalNotFound.moreInfoBtn.removeFromSuperview()
        cardDeckView.addSubview(animalNotFound)
        cardDeckView.bringSubviewToFront(animalNotFound)
        animalNotFound.fillSuperview()
        
        cardDeckView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.cardDeckView.alpha = 1
        }
        loadingHud.dismiss()
    }
    
    //shows animals if card/animal was found
    fileprivate func setupCardsFromAnimals(animal: Animals, paginationUrl: String?) -> CardView{
        let cardView = CardView()
        cardView.cardViewModel = animal.toAnimalCardViewModel()
        cardView.paginationUrl = paginationUrl
        cardView.delegate = self
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        loadingHud.dismiss()
        return cardView
    }
    
    @objc func handleLike(){
        let newPetPick = PickedAnimals(context: context)
        newPetPick.animalId = Int64((topCard?.cardViewModel.id)!)
        newPetPick.animalName = topCard?.cardViewModel.name
        newPetPick.animalProfileImageUrl = topCard?.cardViewModel.croppedImageUrl
        newPetPick.animalUrl = topCard?.cardViewModel.petFinderUrl
        newPetPick.animalPlaceHolderString = topCard?.cardViewModel.placeHolderImage
        saveData(pickedAnimal: newPetPick)
        
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    @objc func handleDislike(){
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    //does the swipe animation when it's swiped on
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat){
        
        let duration = 0.5
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
                loadingHud.textLabel.text = "Loading Animals"
                fetchPickedAnimalData()
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
    
    //Sends the data to getAnimalData function
    func sendData(path: String) {
        getLocationIfAvailable(localPath: path)
    }
    
}

//MARK: - Data Save & Fetch Methods
extension ProfileViewController{
    fileprivate func saveData(pickedAnimal: PickedAnimals){
        do {
            try self.context.save()
        } catch {
            failedWithError(error: error)
        }
        
    }
    
    fileprivate func fetchPickedAnimalData(){
        do{
            self.pickedAnimals = try context.fetch(PickedAnimals.fetchRequest())
        }catch{
            failedWithError(error: error)
        }
    }
}

//MARK: - Handle Preference Buttons
extension ProfileViewController{
    
    @objc func cardExit(){
        switch settingsCardIsPoppedUp {
        case false:
            goUp()
        case true:
            goDown()
        }
        settingsCardIsPoppedUp.toggle()
    }
    
    fileprivate func goUp() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.3, options: .curveEaseInOut) {
            self.animalPrefController.viewWillAppear(true)
            self.settingsCardMoveUp?.isActive = true
            self.settingsCardMoveDown?.isActive = false
            self.view.layoutIfNeeded()
            self.blurView.alpha = 1.0
        } completion: { (_) in
            self.delegate?.settingsDidGoUp()
        }
    }
    
    fileprivate func goDown() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.animalPrefController.viewWillDisappear(true)
            self.settingsCardMoveUp?.isActive = false
            self.settingsCardMoveDown?.isActive = true
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0
        } completion: { (_) in
            self.delegate?.settingsDidGoDown()
        }
    }
}

//MARK: - Error Handling Section
extension ProfileViewController {
    fileprivate func failedWithError(error: Error) {
        let localizedError = error.localizedDescription
        loadingHud.dismiss()
        alertViewMaker(alertTitle: K.errorTitle, alertMessage: "\(localizedError)\n\(K.errorSuggestion)", actionTitle: K.okString)
    }
    
    fileprivate func alertViewMaker(alertTitle: String, alertMessage: String, actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
