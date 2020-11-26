//
//  AnimalPreferenceController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/10/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

protocol AnimalPreferenceProtocol {
    func cardExit()
    func sendData(path: String)
}

class AnimalPreferenceController: UICollectionViewController {
    
    let preferenceBtnView = AnimalPreferences()
    var dataView = DataTableView()
    let dispatchGroup = DispatchGroup()
    
    var delegate: AnimalPreferenceProtocol?
    
    var collectionViewArray = [UIView]()
    var animalTypeData = [AnimalTypes]()
    var breedData = [Breed]()
    var animalType : String!{
        didSet{
            preferenceBtnView.resetButtonsWhenTypeChanges()
        }
    }
    var isOnTableView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewArray = [preferenceBtnView, dataView] //sets the collection view views
        setDelegates() //sets all the delegates needed
        registerAndSetupCollection() //registers the collectionview cell
        setButtonTargets() //sets target for each buttons
    }
    
//    deinit {
//        print("object getting destroyed")
//    }
    
    fileprivate func setButtonTargets(){
        //Table View
        preferenceBtnView.typeBtn.addTarget(self, action: #selector(handleType), for: .touchUpInside)
        preferenceBtnView.breedBtn.addTarget(self, action: #selector(handleBreed), for: .touchUpInside)
        preferenceBtnView.colorBtn.addTarget(self, action: #selector(handleColor), for: .touchUpInside)
        preferenceBtnView.coatBtn.addTarget(self, action: #selector(handleCoat), for: .touchUpInside)
        
        //Bottom Button Stack
        preferenceBtnView.bottomStack.resetBtn.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        preferenceBtnView.bottomStack.exitBtn.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        preferenceBtnView.bottomStack.submitBtn.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        //Go Back Button
        dataView.goBack.addTarget(self, action: #selector(slideExitAndEnter), for: .touchUpInside)
    }
    
    fileprivate func registerAndSetupCollection(){
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.layer.cornerRadius = 25
    }
    
    fileprivate func setDelegates(){
        collectionView.delegate = self
        dataView.delegate = self
    }
}

//MARK: - Load Data On PopUp
extension AnimalPreferenceController {
    
    //Load Animal Type Data, Coat, Color Data
    func loadAnimalPreferenceData() {
        let animalTypeUrl = "https://api.petfinder.com/v2/types"
        dispatchGroup.enter()
        FetchManager().fetchAnimalTypes(url: animalTypeUrl) { (typeModel, error) in
            guard let types = typeModel?.types else { return }
            self.animalTypeData = types
            self.dispatchGroup.leave()
        }
    }
    
    //Loads all breed Data
    func loadBreedDataForType(){
        let animalType = preferenceBtnView.typeBtn.rightLbl.text!
        var breedLink = "https://api.petfinder.com"
        for type in animalTypeData{
            if type.name == animalType{
                breedLink += type.links.breeds.href
            }
        }
        
        FetchManager().fetchBreed(url: breedLink) { (breedModel, error) in
            guard let breeds = breedModel?.breeds else { return }
            self.breedData = breeds
        }
    }
}

//MARK: - Handle Button Code
extension AnimalPreferenceController: OptionSelected{
    
    //Hides button with arrays that are empty
    fileprivate func hideEmptyBtns(){
        var tempCoatArray = [String]()
        for type in animalTypeData{
            if type.name == animalType{
                tempCoatArray = type.coats!
            }
        }
        if tempCoatArray.isEmpty {
            preferenceBtnView.coatBtn.isHidden = true
        }else{
            preferenceBtnView.coatBtn.isHidden = false
        }
    }
    
    //Passes data to the tableview in the front
    fileprivate func passDataToTable(placeHolder: String, button: ParametersButtons, data: [String]){
        dataView.searchBar.placeholder = placeHolder
        dataView.buttonPressed = button
        dataView.dataArray = data
        slideExitAndEnter()
    }
    
    //Sets the label on the right of button to the selected choice
    func selectedOption(button: ParametersButtons) {
        if button == preferenceBtnView.typeBtn{
            animalType = button.rightLbl.text
        }
        
        preferenceBtnView.makeButtonVisible()
        hideEmptyBtns()
        slideExitAndEnter()
    }
    
    //handles animal type tableview
    @objc fileprivate func handleType(button: ParametersButtons){
        DispatchQueue.main.async {
            let placeHolder = "Search Animal Type"
            let data = self.animalTypeData.map({ (type) -> String in
                return type.name!
            })
            self.passDataToTable(placeHolder: placeHolder, button: button, data: data)
        }
    }
    
    //Sets breed tableview
    @objc fileprivate func handleBreed(button: ParametersButtons){
        let placeHolder = "Search \(animalType!) By Breed"
        
        let data = breedData.map({ (breed) -> String in
            return breed.name!
        })
        passDataToTable(placeHolder: placeHolder, button: button, data: data)
    }
    
    //Sets the Color table view
    @objc fileprivate func handleColor(button: ParametersButtons){
        let placeHolder = "Search \(animalType!) Colors"
        var data = [String]()
        for type in animalTypeData{
            if type.name == animalType{
                data = type.colors!
            }
        }
        passDataToTable(placeHolder: placeHolder, button: button, data: data)
    }
    
    //Sets the Coat type tableviews
    @objc fileprivate func handleCoat(button: ParametersButtons){
        let placeHolder = "Search \(animalType!) Coats"
        var data = [String]()
        for type in animalTypeData{
            if type.name == animalType{
                data = type.coats!
            }
        }
        passDataToTable(placeHolder: placeHolder, button: button, data: data)
    }
    
    //Resets the buttons
    @objc fileprivate func handleReset(){
        preferenceBtnView.resetButtons()
        handleSubmit()
    }
    
    //exits the cardView
    @objc fileprivate func handleExit(){
        delegate?.cardExit()
    }
    
    //Submits to ProfileVC
    @objc fileprivate func handleSubmit(){
        let animalType = formatString(input: preferenceBtnView.typeBtn.rightLbl.text!)
        let breed = formatString(input: preferenceBtnView.breedBtn.rightLbl.text!)
        let color = formatString(input: preferenceBtnView.colorBtn.rightLbl.text!)
        let coat = formatString(input: preferenceBtnView.coatBtn.rightLbl.text!)
        
        let size = formatString(input: preferenceBtnView.sizeBtn.itemLabel.text!)
        let gender = formatString(input: preferenceBtnView.genderBtn.itemLabel.text!)
        let age = formatString(input: preferenceBtnView.ageBtn.itemLabel.text!)
        
        let locationRange = preferenceBtnView.locationRange.itemLabel.text!
        
        let path = "type=\(animalType)&breed=\(breed)&color=\(color)&coat=\(coat)&size=\(size)&gender=\(gender)&age=\(age)&distance=\(locationRange)"
        
        delegate?.cardExit()
        delegate?.sendData(path: path)
    }
    
    //Formats the string to send to profilevc
    fileprivate func formatString(input: String)-> String{
        if input == K.random{
            return ""
        }else if input == K.smallFurry{
            return K.formattedSmallFurry
        }else if input == K.scalesFinsOthers{
            return K.FormattedScalesFinsOthers
        }
        return input
    }
    
    //Combining both goForward and goBack function
    @objc func slideExitAndEnter(){
        switch isOnTableView {
        case true:
            goBack()
            self.loadBreedDataForType()
            isOnTableView = false
        case false:
            goForward()
            isOnTableView = true
        }
    }
    
    //Go Towards TableView
    func goForward(){
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        dataView.tableView.isHidden = false
        
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut) {
            self.preferenceBtnView.alpha = 0
            self.dataView.alpha = 1
            self.preferenceBtnView.isHidden = true
            self.dataView.isHidden = false
        } completion: { (_) in
            
        }
    }
    
    //Go back to preference selection
    func goBack(){
        dataView.dataArray = []
        dataView.tableView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseInOut) {
            self.preferenceBtnView.alpha = 1
            self.dataView.alpha = 0
            self.preferenceBtnView.isHidden = false
            self.dataView.isHidden = true
        } completion: { (_) in
            
        }
    }
    
}

//MARK: - CollectionView Flow Layout
extension AnimalPreferenceController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        let arrayItem = collectionViewArray[indexPath.item]
        cell.addSubview(arrayItem)
        arrayItem.fillSuperview()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
