//
//  AnimalTypes.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/11/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation

// MARK: - AnimalTypesModel
struct AnimalTypesData : Codable {
    let types: [AnimalTypes]?
}

// MARK: - AnimalType
struct AnimalTypes : Codable {
    let name: String?
    let coats: [String]?
    let colors: [String]?
    let genders: [String]?
    let links: Links.AnimalTypesLink
    
    enum CodingKeys: String, CodingKey {
        case name, coats, colors, genders
        case links = "_links"
    }
}

