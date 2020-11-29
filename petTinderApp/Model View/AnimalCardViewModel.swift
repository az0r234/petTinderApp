//
//  AnimalCardViewModel.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/16/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

protocol ProducesAnimalCardViewModel {
    func toAnimalCardViewModel() -> AnimalCardViewModel
}

class AnimalCardViewModel {
    let id : Int
    let name: String
    let organizationLink: String
    let petFinderUrl : String
    let imageUrl : [String]
    let croppedImageUrl : String
    let cardAttributedString : NSAttributedString
    let description: String
    let textAlignment : NSTextAlignment
    let placeHolderImage : UIImage
    
    init(id: Int, name: String, organizationLink: String, petFinderUrl: String, imageUrl: [String], croppedImage: String, cardAttributedString: NSAttributedString, description: String ,textAlignment: NSTextAlignment, placeHolderImage: UIImage) {
        self.id = id
        self.name = name
        self.organizationLink = organizationLink
        self.petFinderUrl = petFinderUrl
        self.imageUrl = imageUrl
        self.croppedImageUrl = croppedImage
        self.cardAttributedString = cardAttributedString
        self.description = description
        self.textAlignment = textAlignment
        self.placeHolderImage = placeHolderImage
    }
}
