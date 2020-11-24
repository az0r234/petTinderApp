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
    let organizationLink: String
    let petFinderUrl : String
    let imageUrl : [String]
    let cardAttributedString : NSAttributedString
    let description: String
    let textAlignment : NSTextAlignment
    
    init(id: Int, organizationLink: String, petFinderUrl: String, imageUrl: [String], cardAttributedString: NSAttributedString, description: String ,textAlignment: NSTextAlignment) {
        self.id = id
        self.organizationLink = organizationLink
        self.petFinderUrl = petFinderUrl
        self.imageUrl = imageUrl
        self.cardAttributedString = cardAttributedString
        self.description = description
        self.textAlignment = textAlignment
    }
}
