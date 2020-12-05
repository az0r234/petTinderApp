//
//  PickedAnimals+CoreDataProperties.swift
//  
//
//  Created by Alok Acharya on 12/3/20.
//
//

import Foundation
import CoreData


extension PickedAnimals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PickedAnimals> {
        return NSFetchRequest<PickedAnimals>(entityName: "PickedAnimals")
    }

    @NSManaged public var animalId: Int64
    @NSManaged public var animalName: String?
    @NSManaged public var animalPlaceHolderString: String?
    @NSManaged public var animalProfileImageUrl: String?
    @NSManaged public var animalUrl: String?

}
