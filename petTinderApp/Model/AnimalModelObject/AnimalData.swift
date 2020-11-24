//
//  Animal.swift
//  petTinderApp
//
//  Created by Alok Acharya on 10/28/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

struct AnimalData: Codable {
    let animals: [Animals]
    let pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        case animals = "animals"
        case pagination = "pagination"
    }
}

//MARK: - Animal Object
struct Animals: Codable, ProducesAnimalCardViewModel{
    
    let id: Int?
    let organizationId: String?
    let url: String?
    let type: String?
    let species: String?
    let breeds: Breeds?
    let colors: Colors?
    let age: String?
    let gender: String?
    let size: String?
    let coat: String?
    let attributes: Attributes?
    let environment: Environment?
    let name: String?
    let description: String?
    let organizationAnimalId: String?
    let photos: [Photos]?
    let primaryPhotoCropped: Photos?
    let videos: [Videos]?
    let status: String?
    let statusChangedAt: String?
    let publishedAt:String?
    let distance: Double?
    let contact: Contact?
    let links: Links.AnimalDataLink?
    
    enum CodingKeys: String, CodingKey {
        case id,url,type,species,breeds,colors,age,gender,size,coat,attributes,environment,name,description,photos,videos,status,contact,distance
        case organizationId = "organization_id"
        case organizationAnimalId = "organization_animal_id"
        case primaryPhotoCropped = "primary_photo_cropped"
        case statusChangedAt = "status_changed_at"
        case publishedAt = "published_at"
        case links = "_links"
    }
    
    //MARK: - Turn to CardView Model
    func toAnimalCardViewModel() -> AnimalCardViewModel {
        let id = self.id!
        let organizationId = self.links?.organization.href
        let petFinderUrl = self.url!
        
        let name = getFirstName()
        let cardAttributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .bold)])
        
        let coat = self.coat != nil ? "\(self.coat!) Haired " : ""
        let age = self.age!
        let gender = self.gender != "Unknown" ? self.gender! : ""
        let species = self.species!
    
        
        cardAttributedText.append(NSAttributedString(string: "\n\(coat)\(age) \(gender) \(species)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let description = self.description != nil ? self.description! : ""
        
        let city = self.contact!.address!.city!
        let state = self.contact!.address!.state!
        let distance = self.distance != nil ? self.distance! : 0.0
        let formattedDistance = String(format: "%.2f", distance)
        cardAttributedText.append(NSAttributedString(string: "\n\(city), \(state)\n\(formattedDistance) miles away", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)]))
        
        var imageUrls = [String]()
        if !photos!.isEmpty{
            for image in photos!{
                imageUrls.append(image.large!)
            }
        }
        
        let croppedImage = primaryPhotoCropped?.small != nil ? self.primaryPhotoCropped!.small! : ""
        
        let placeHolderImage = UIImage(named: type!.lowercased())
//            , placeHolderImage: placeHolderImage!
        
        return AnimalCardViewModel(id: id, organizationLink: organizationId!, petFinderUrl: petFinderUrl, imageUrl: imageUrls, croppedImage: croppedImage, cardAttributedString: cardAttributedText, description: description, textAlignment: .left, placeHolderImage: placeHolderImage!)
    }
    
    fileprivate func getFirstName()->String{
        let name = self.name!
        var newName = String()
        if name.contains(" "){
            let index = name.firstIndex(of: " ")
            newName = String(name[..<index!])
        }else{
            newName = name
        }
        return newName
    }
    

    
    //MARK: - Breeds Object
    struct Breeds: Codable {
        let primary: String?
        let secondary: String?
        let mixed: Bool?
        let unknown: Bool?
    }
    
    //MARK: - Color Object
    struct Colors: Codable {
        let primary: String?
        let secondary: String?
        let tertiary: String?
    }
    
    //MARK: - Attribute Object
    struct Attributes: Codable {
        let spayedNeutered: Bool?
        let houseTrained: Bool?
        let declawed: Bool?
        let specialNeeds: Bool?
        let shotsCurrent: Bool?
        
        enum CodingKeys: String, CodingKey {
            case declawed
            case spayedNeutered = "spayed_neutered"
            case houseTrained = "house_trained"
            case specialNeeds = "special_needs"
            case shotsCurrent = "shots_current"
        }
    }
    
    //MARK: - Environment Object
    struct Environment: Codable {
        let children: Bool?
        let dogs: Bool?
        let cats: Bool?
    }
    
    //MARK: - Video Object
    struct Videos: Codable {
        let embed: String?
    }
    
    //MARK: - Contact Information Object
    struct Contact: Codable {
        let email: String?
        let phone: String?
        let address: Address?
    }    
}


//MARK: - Pagination Object
struct Pagination: Codable {
    let countPerPage: Int?
    let totalCount: Int?
    let currentPage: Int?
    let totalPages: Int?
    let links: Links.PaginationLink?
    
    enum CodingKeys: String, CodingKey {
        case countPerPage = "count_per_page"
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case links = "_links"
    }
}

