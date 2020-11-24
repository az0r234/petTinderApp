//
//  SharedModelData.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/16/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation

struct Links: Codable {
    
    struct AnimalDataLink : Codable {
        let linkSelf: Href
        let type: Href
        let organization: Href
        
        enum CodingKeys: String, CodingKey{
            case linkSelf = "self"
            case type, organization
        }
    }
    
    struct BreedLink : Codable {
        let type: Href
    }
    
    struct AnimalTypesLink : Codable {
        let linkSelf: Href
        let breeds: Href
        
        enum CodingKeys: String, CodingKey{
            case linkSelf = "self"
            case breeds
        }
    }
    
    struct OrganizationLinks : Codable {
        let linkSelf : Href
        let animals : Href
        
        enum CodingKeys: String, CodingKey{
            case linkSelf = "self"
            case animals
        }
    }
    
    struct PaginationLink : Codable{
        let next: Href
    }
    
    struct Href: Codable{
        let href: String
    }
}

//MARK: - Photos
struct Photos : Codable {
    let small: String?
    let medium: String?
    let large: String?
    let full: String?
}

//MARK: - Address
struct Address: Codable {
    let address1: String?
    let address2: String?
    let city: String?
    let state: String?
    let postcode: String?
    let country: String?
}
