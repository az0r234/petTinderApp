//
//  BreedModel.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/13/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation

// MARK: - BreedModel
struct BreedModel : Decodable {
    let breeds: [Breed]?
}

// MARK: - Breed
struct Breed : Decodable {
    let name: String?
    let links: Links.BreedLink?
}
