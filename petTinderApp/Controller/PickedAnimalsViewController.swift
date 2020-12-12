//
//  ChatViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 8/31/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
import CoreData

class PickedAnimalsViewController: UIViewController{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pickedAnimals : [PickedAnimals]?
    
    let searchBar = UISearchBar()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AnimalPickedTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        fetchPickedAnimalData()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPickedAnimalData()
    }
    
    fileprivate func removeSeperatorIfPickedAnimalEmpty(){
        if pickedAnimals!.isEmpty{
            tableView.separatorStyle = .none
        }else{
            tableView.separatorStyle = .singleLine
        }
    }
    
    fileprivate func setupSearchBar(){
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        view.addSubview(searchBar)
        searchBar.anchor(top: nil, leading: view.leadingAnchor, bottom: tableView.topAnchor, trailing: view.trailingAnchor)
    }
}

//MARK: - TableView Methods
extension PickedAnimalsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickedAnimals!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AnimalPickedTableViewCell
        
        if let pickedAnimalDataVal = pickedAnimals?[indexPath.row]{
            if let imageURL = URL(string: (pickedAnimalDataVal.animalProfileImageUrl!)){
                cell.profileImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .continueInBackground, context: nil)
            }else{
                cell.profileImageView.image = UIImage(named: pickedAnimalDataVal.animalPlaceHolderString!)
            }
            cell.nameLabel.text = pickedAnimals?[indexPath.row].animalName
        }
        cell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:))))
        return cell
    }
    
    @objc fileprivate func handleLongPress(gesture: UILongPressGestureRecognizer){
        switch gesture.state {
        case .began:
            let touchPoint = gesture.location(in: self.tableView)
            showActionSheet(touchPoint: touchPoint)
        case .failed:
            print("failed")
        default:
            break
        }
    }
    
    fileprivate func showActionSheet(touchPoint: CGPoint){
        guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }
        
        tableView.performBatchUpdates {
            self.deletePickedData(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .middle)
        } completion: { (_) in
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = pickedAnimals?[indexPath.row].animalUrl else {return}
        tableView.deselectRow(at: indexPath, animated: true)
        didPressMoreInfo(url: url)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func didPressMoreInfo(url: String) {
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            safariVC.modalPresentationStyle = .popover
            present(safariVC, animated: true, completion: nil)
        }
    }
}

//MARK: - Data Save & Fetch Methods
extension PickedAnimalsViewController{
    fileprivate func saveData(pickedAnimal: PickedAnimals){
        do {
            try self.context.save()
        } catch {
            failedWithError(error: error)
        }
    }
    
    func deletePickedData(at indexPath: IndexPath) {
        let pickedPetForDeletion = self.pickedAnimals![indexPath.row]
        self.context.delete(pickedPetForDeletion)
        do{
            try self.context.save()
        }catch{
            failedWithError(error: error)
        }
        fetchPickedAnimalData()
    }
    
    fileprivate func fetchPickedAnimalData(){
        do{
            self.pickedAnimals = try context.fetch(PickedAnimals.fetchRequest())
        }catch{
            failedWithError(error: error)
        }
        removeSeperatorIfPickedAnimalEmpty()
        tableView.reloadData()
//        UIView.transition(with: tableView, duration: 0.4, options: [.curveEaseInOut, .transitionCrossDissolve]) {
//            self.tableView.reloadData()
//        } completion: { (_) in
//
//        }
    }
}

//MARK: - Error Handling Section
extension PickedAnimalsViewController {
    fileprivate func failedWithError(error: Error) {
        let localizedError = error.localizedDescription
        alertViewMaker(alertTitle: ButtonTitles.Error.rawValue, alertMessage: "\(localizedError)\n\(K.errorSuggestion)", actionTitle: ButtonTitles.Ok.rawValue)
    }
    
    fileprivate func alertViewMaker(alertTitle: String, alertMessage: String, actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


