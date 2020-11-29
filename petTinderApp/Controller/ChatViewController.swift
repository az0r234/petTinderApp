//
//  ChatViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 8/31/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
import SafariServices

class ChatViewController: UITableViewController{
    
    lazy var pickedAnimalData = realm.objects(PickedAnimalData.self)
    let realm = try! Realm()
    var profileVC = ProfileViewController()
    var notificationToken : NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AnimalPickedTableViewCell.self, forCellReuseIdentifier: "cellId")
        
        notificationToken = pickedAnimalData.observe {change in
            switch change {
            case .initial:
                self.tableView.reloadData()
            case .update:
                self.pickedAnimalData = self.realm.objects(PickedAnimalData.self)
                self.tableView.reloadData()
            default: ()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickedAnimalData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AnimalPickedTableViewCell
        if let imageURL = URL(string: (pickedAnimalData[indexPath.row].animalProfileImage)){
            cell.profileImageView.sd_setImage(with: imageURL)
        }else{
            cell.profileImageView.image = #imageLiteral(resourceName: "dog")
        }
        cell.nameLabel.text = pickedAnimalData[indexPath.row].animalName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = pickedAnimalData[indexPath.row].animalUrl
        tableView.deselectRow(at: indexPath, animated: true)
        didPressMoreInfo(url: url)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            updateModel(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func updateModel(at indexPath: IndexPath) {
        let pickedPetForDeletion = self.pickedAnimalData[indexPath.row]
        do{
            try self.realm.write{
                self.realm.delete(pickedPetForDeletion)
            }
        }catch{
            print("Error deleting category, \(error)")
        }
    }
    
    func didPressMoreInfo(url: String) {
        if let safeUrl = URL(string: url){
            let safariVC = SFSafariViewController(url: safeUrl)
            safariVC.modalPresentationStyle = .popover
            present(safariVC, animated: true, completion: nil)
        }
    }

}


