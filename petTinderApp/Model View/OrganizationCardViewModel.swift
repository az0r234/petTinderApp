//
//  OrganizationCardViewModel.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/19/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

protocol ProducesOrganizationCardViewModel {
    func toOrganizationCardViewModel() -> OrganizationCardViewModel
}

class OrganizationCardViewModel {
    
    let name : String
    let organizationId : String
    
    let email : String
    let phone : String
    let address: String
    let website: String
    let photo : String
    
    init(name: String, organizationId: String, email: String, phone: String, address: String, website: String, photo: String) {
        self.name = name
        self.organizationId = organizationId
        self.email = email
        self.phone = phone
        self.address = address
        self.website = website
        self.photo = photo
    }
    
    
}
