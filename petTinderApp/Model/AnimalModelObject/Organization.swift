//
//  OrganizationData.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/16/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation

// MARK: - OrganizationData
struct OrganizationData : Codable{
    let organization: Organization?
}

// MARK: - Organization
struct Organization : Codable, ProducesOrganizationCardViewModel {
    
    
    let id: String?
    let name: String?
    let email: String?
    let phone: String?
    let address: Address?
    let url: String?
    let website: String?
    let photos: [Photos]?
    let links: Links.OrganizationLinks
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, address, url, website, photos
        case links = "_links"
    }
    
    func toOrganizationCardViewModel() -> OrganizationCardViewModel {
        let name = self.name!
        let organizationId = self.id!
        let email = self.email != nil ? self.email! : " "
        let phone = self.phone != nil ? self.phone! : " "
        let address1 = self.address!.address1 != nil ? self.address!.address1! : " "
        let city = self.address!.city != nil ? self.address!.city! : " "
        let state = self.address!.state!
        let zipCode = self.address!.postcode!
        let address = "\(address1), \(city), \(state) \(zipCode)"
        let website = self.website != nil ? self.website! : "https://www.petfinder.com"
        let photo = (self.photos!.first?.medium != nil ? self.photos!.first!.medium : " ")!
        
        return OrganizationCardViewModel(name: name, organizationId: organizationId, email: email, phone: phone, address: address, website: website, photo: photo)
    }
}
