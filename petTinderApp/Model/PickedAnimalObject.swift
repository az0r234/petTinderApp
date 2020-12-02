//
//  PickedAnimalData.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/29/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import Foundation
import RealmSwift

class PickedAnimalObject : Object{
    @objc dynamic var animalId: Int = 0
    @objc dynamic var animalName: String = ""
    @objc dynamic var animalUrl: String = ""
    @objc dynamic var animalProfileImage: String = ""
}
